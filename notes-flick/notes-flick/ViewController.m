//
//  ViewController.m
//  notes-flick
//
//  Created by JASON HARRIS on 12/23/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "NoteViewController.h"
#import "NoteView.h"
#import "NotesColor.h"

@interface ViewController () <UIGestureRecognizerDelegate, UIScrollViewDelegate, NoteViewControllerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIBarButtonItem *addNoteButton;
@property (nonatomic, strong) NoteViewController *veryNewNoteVC;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureUp;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureDown;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;

@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) NSUInteger pageIndex;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpEntireScreen];
    [self setUpAddNoteButton];
}

-(void)setUpEntireScreen
{
    self.spacing = 10;
    self.noteSize = [AllTheNotes sharedNotes].defaultNoteSize;
    
    self.swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeReceived:)];
    self.swipeGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    self.swipeGestureUp.delegate = self;
    self.swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeReceived:)];
    self.swipeGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    self.swipeGestureDown.delegate = self;
    self.pinchGesture = [[UIPinchGestureRecognizer alloc]  initWithTarget:self action:@selector(pinchReceived:)];
    self.pinchGesture.delegate = self;
    self.doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapReceived:)];
    self.doubleTapGesture.numberOfTapsRequired = 2;
    
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.minimumZoomScale = 0.0;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, self.spacing, 0, self.spacing);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor notesBrown];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view); //.insets(UIEdgeInsetsMake(10, 10, 10, 10)); //TRIED SETTING INSETS AND STILL DOESN'T FIX
    }];
    
    [self populateStackview];
    
    self.topView = UIView.new;
//    self.topView.backgroundColor = [UIColor greenColor]; // FOR DEBUGGING STUFF
    [self.view addSubview:self.topView];
    self.topView.userInteractionEnabled = NO;
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

-(void)setUpAddNoteButton
{
    self.addNoteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                       target:self
                                                                       action:@selector(addNoteButtonWasPressed:)];
    self.addNoteButton.tintColor = [UIColor notesBlue];
    self.navigationItem.rightBarButtonItem = self.addNoteButton;
    
//    [self.addNoteButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_topMargin).offset(self.spacing*2);
//        make.right.equalTo(self.view).offset(-self.spacing);
//    }];
    
}

#pragma mark - WORKING WITH THE NOTES

-(void)populateStackview
{
    
    self.stackView = [[UIStackView alloc] initWithArrangedSubviews:[self returnSubviewsBasedOnDataStore]];

    //DEBUG DUMMY LABEL
    NSUInteger count = 0;
    
    for (count = 0; count <5; count++) {
        UILabel *dummyLabel = [[UILabel alloc] init];
        [dummyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.width.equalTo(@(self.noteSize *1.2));
        }];
        dummyLabel.text = @"BLAH BLAH";
        dummyLabel.backgroundColor = [UIColor notesMilk];
        dummyLabel.textAlignment = NSTextAlignmentCenter;
        [self.stackView addArrangedSubview:dummyLabel];
    }
    //DEBUG DUMMY LABEL
    
    [self.scrollView addSubview:self.stackView];
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.centerY.equalTo(self.view);
    }];
    
    
    
    [self.stackView addGestureRecognizer:self.swipeGestureUp];
    [self.stackView addGestureRecognizer:self.swipeGestureDown];
    [self.stackView addGestureRecognizer:self.pinchGesture];
    [self.stackView addGestureRecognizer:self.doubleTapGesture];
    
    
    self.stackView.backgroundColor = [UIColor blueColor];
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.contentMode = UIViewContentModeScaleToFill;
    self.stackView.distribution = UIStackViewDistributionEqualSpacing;
    self.stackView.alignment = UIStackViewAlignmentCenter;
    self.stackView.spacing = 20;
    
//    //BROKEN ATTEMPT AT USING SCROLLING
//    self.stackView.userInteractionEnabled = NO;
//    [self.scrollView addGestureRecognizer:self.swipeGestureUp];
//    [self.scrollView addGestureRecognizer:self.swipeGestureDown];
//    [self.scrollView addGestureRecognizer:self.doubleTapGesture];
    
}

-(NSMutableArray *)returnSubviewsBasedOnDataStore
{
    NSMutableArray *mutableSubviews = [@[] mutableCopy];
    for (NoteView *eachNoteView in [AllTheNotes sharedNotes].notesArray) {
        eachNoteView.noteSizeValue = [AllTheNotes sharedNotes].currentNoteSize;
        [mutableSubviews addObject:eachNoteView];
    }
    
    
    return mutableSubviews;
}

-(void)newNoteViewControllerEditing:(BOOL)areWeEditing noteViewToEdit:(NoteView *)noteViewToEdit
{
    self.veryNewNoteVC = [[NoteViewController alloc] init];
    self.veryNewNoteVC.delegate = self;
    
    if (areWeEditing)
    {
        self.veryNewNoteVC.theNoteView = noteViewToEdit;
        self.veryNewNoteVC.noteTextView.text = noteViewToEdit.textValue;
        self.veryNewNoteVC.noteOrder = noteViewToEdit.orderNumber;
    } else
    {
        self.veryNewNoteVC.noteOrder = self.stackView.arrangedSubviews.count;
    }
    
    self.veryNewNoteVC.areWeEditing = areWeEditing;
    [self showViewController:self.veryNewNoteVC sender:self];
}

#pragma mark - ADDING NEW NOTES

-(void)addNoteButtonWasPressed:(UIButton *)buttonPressed
{
    
    [self newNoteViewControllerEditing:NO noteViewToEdit:nil];
    
}


-(void)newNoteResult:(NSDictionary *)result updatedNoteView:(NoteView *)updatedNoteView
{
//    NSLog(@"result dict: %@",result);
    [self.navigationController popViewControllerAnimated:YES];
    NSNumber *orderNSNumber = result[@"noteOrder"];
    NSUInteger orderNumber = orderNSNumber.integerValue;
    NSNumber *nsNumberPriority = result[@"priority"];
    NSUInteger priority = nsNumberPriority.integerValue;
    
    NoteView *newNoteView = [[NoteView alloc] initWithText:result[@"noteText"]
                                                  noteSize:self.noteSize
                                                  withDate:nil
                                               orderNumber:orderNumber
                                                  priority:priority
                                                     color:result[@"color"]
                                                crossedOut:NO];
    
    if(updatedNoteView)
    {
        updatedNoteView.backgroundColor = result[@"color"];
        updatedNoteView.textValue = result[@"noteText"];
        updatedNoteView.notePriority = priority;
        
    } else //IF WE'RE ADDING A NEW NOTE DO THIS
    {
        //ADD THE NOTE TO DATA STORE
        [[AllTheNotes sharedNotes].notesArray insertObject:newNoteView atIndex:orderNumber];
        
        //ADD NOTE TO STACKVIEW
        [self addNoteToView:[AllTheNotes sharedNotes].notesArray[orderNumber] afterNumber:orderNumber];
    }
    
    [self updateNoteOrderNumbers];
    [AllTheNotes updateDefaultsWithNotes];
}


-(void)addNoteToView:(NoteView *)newNoteView afterNumber:(NSUInteger)orderNumber
{
    [self.stackView insertArrangedSubview:newNoteView atIndex:orderNumber];
    [self updateNoteOrderNumbers];
}


#pragma mark - gestures

-(void)pinchReceived:(UIPinchGestureRecognizer *)pinchGestureRecog
{
    //INITIAL ATTEMPT AT GETTING UIScrollView TO ZOOM
//    [self.scrollView setZoomScale:pinchGestureRecog.scale animated:YES];
//    [self.scrollView layoutIfNeeded];
//    NSLog(@"%1.2f",self.scrollView.zoomScale);
    
    if (pinchGestureRecog.velocity > 0 && self.noteSize != [AllTheNotes sharedNotes].defaultNoteSize)
    {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.noteSize = [AllTheNotes sharedNotes].defaultNoteSize;
                             for (NoteView *eachNote in self.stackView.arrangedSubviews) {
                                 if ([eachNote isKindOfClass:[NoteView class]])
                                 {
                                     eachNote.noteSizeValue = self.noteSize;
                                 } else
                                 {
                                     UILabel *theLabel = (UILabel *)eachNote;
                                     [theLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                                         make.height.and.width.equalTo(@(self.noteSize * 1.2));
                                     }];
                                 }
                             }
                             self.scrollView.pagingEnabled = YES;
                             [self.view layoutIfNeeded];
                         }
                         completion:nil];

    } else if (pinchGestureRecog.velocity < 0 && self.noteSize == [AllTheNotes sharedNotes].defaultNoteSize)
    {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.noteSize = [AllTheNotes sharedNotes].defaultNoteSize / 3;
                             for (NoteView *eachNote in self.stackView.arrangedSubviews) {
                                 if ([eachNote isKindOfClass:[NoteView class]])
                                 {
                                       eachNote.noteSizeValue = self.noteSize;
                                 } else
                                 {
                                     UILabel *theLabel = (UILabel *)eachNote;
                                     [theLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                                         make.height.and.width.equalTo(@(self.noteSize * 1.2));
                                     }];
                                 }
                             }
                             self.scrollView.pagingEnabled = NO;
                             [self.view layoutIfNeeded];
                         }
                         completion:nil];

    }
    
//    NSLog(@"velocity: %1.1f scale: %1.1f", pinchGestureRecog.velocity, pinchGestureRecog.scale);
}


-(void)doubleTapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint point = [tapGestureRecognizer locationInView:self.stackView];
    CGFloat subviewFraction = point.x / self.stackView.bounds.size.width;
    CGFloat arrayIndexFract = subviewFraction * self.stackView.arrangedSubviews.count;
    NoteView *tappedNoteView = self.stackView.arrangedSubviews[@(arrayIndexFract).integerValue *1];
    [self newNoteViewControllerEditing:YES noteViewToEdit:tappedNoteView];
    
}

-(void)swipeReceived:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionUp)
    {
        [self removeNote:swipeGestureRecognizer];
    } else if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionDown)
    {
        [self crossOutNote:swipeGestureRecognizer];
    }
    
    
}

-(void)crossOutNote:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    CGPoint point = [swipeGestureRecognizer locationInView:self.stackView];
    CGFloat subviewFraction = point.x / self.stackView.bounds.size.width;
    CGFloat arrayIndexFract = subviewFraction * self.stackView.arrangedSubviews.count;
    NoteView *oldNoteView = self.stackView.arrangedSubviews[@(arrayIndexFract).integerValue *1];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         oldNoteView.crossedOut = !oldNoteView.crossedOut;
                         [AllTheNotes updateDefaultsWithNotes];
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
    
}

-(void)removeNote:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    CGPoint point = [swipeGestureRecognizer locationInView:self.stackView];
    CGPoint pointInWindow = [swipeGestureRecognizer locationInView:self.view];
    CGFloat subviewFraction = point.x / self.stackView.bounds.size.width;
    CGFloat arrayIndexFract = subviewFraction * self.stackView.arrangedSubviews.count;
//    NSLog(@". \n point in stack: %@ \n point in view: %@ \n index fract: %1.3f \n index # %lu \n subview count: %lu",NSStringFromCGPoint(point),NSStringFromCGPoint(pointInWindow), subviewFraction * self.stackView.arrangedSubviews.count,@(arrayIndexFract).integerValue *1 ,self.stackView.arrangedSubviews.count);
    
    NoteView *oldNoteView = self.stackView.arrangedSubviews[@(arrayIndexFract).integerValue *1];
    
    CGPoint relativeToWindow = [oldNoteView convertPoint:oldNoteView.bounds.origin toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         oldNoteView.hidden = YES;
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
    [oldNoteView removeFromSuperview];
    
    NoteView *animatedNote = [[NoteView alloc] initWithNoteView:oldNoteView];
    
    [self.topView addSubview:animatedNote];
    
    [animatedNote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(relativeToWindow.x);
        make.top.equalTo(self.view).offset(relativeToWindow.y);
    }];
    [animatedNote.interiorTextBox mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(animatedNote);
    }];
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [animatedNote mas_remakeConstraints:^(MASConstraintMaker *make) {
                             make.bottom.equalTo(self.view.mas_top);
                             make.left.equalTo(self.view).offset(pointInWindow.x-self.noteSize/2);
                             make.height.and.width.equalTo(@(self.noteSize/2));
                         }];
                         [animatedNote.interiorTextBox mas_remakeConstraints:^(MASConstraintMaker *make) {
                             make.edges.equalTo(animatedNote);
                         }];
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [animatedNote removeFromSuperview];
                         [AllTheNotes updateDefaultsWithNotes];
                     }];
    [self updateNoteOrderNumbers];
}

#pragma mark - scrolling

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    id i;
    i = i;
    [super touchesEnded:touches withEvent:event];
    NSLog(@"user touched this object: %@",touches.anyObject.view.class);
}


-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    NSLog(@"SCROLL IS ZOOMED TO: %1.1f", self.scrollView.zoomScale);
}

//-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return self.stackView;
//}



//-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
//{
//
//    return YES;
//}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    CGFloat pageWidth = self.noteSize + scrollView.contentInset.left;
//    CGFloat pageX = self.pageIndex*pageWidth-scrollView.contentInset.left;
//    CGFloat pagesScrolled = (targetContentOffset->x - pageX)/ pageWidth;
//    if (targetContentOffset->x<pageX)
//    {
//        if (self.pageIndex>0) {
//            self.pageIndex += pagesScrolled;
//        }
//    }
//    else if(targetContentOffset->x>pageX){
//        if (self.pageIndex<self.stackView.arrangedSubviews.count)
//        {
//            self.pageIndex += pagesScrolled;
//        }
//    }
//    targetContentOffset->x = self.pageIndex*pageWidth-scrollView.contentInset.left;
//    NSLog(@"%lu %d", self.pageIndex, (int)targetContentOffset->x);
//}


#pragma mark - update order
-(void)updateNoteOrderNumbers
{
    NSUInteger i = 0;
    
    i = 0;
    
    for (NoteView *eachNoteView in self.stackView.arrangedSubviews) {
        eachNoteView.orderNumber = i;
        i++;
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNoteSize:(CGFloat)noteSize
{
    _noteSize = noteSize;
    [AllTheNotes sharedNotes].currentNoteSize = noteSize;
}


@end
