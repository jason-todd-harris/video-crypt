//
//  ViewController.m
//  notes-flick
//
//  Created by JASON HARRIS on 12/23/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "NewNoteViewController.h"
#import "NoteView.h"

@interface ViewController () <UIGestureRecognizerDelegate, UIScrollViewDelegate, NewNoteViewControllerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIBarButtonItem *addNoteButton;
@property (nonatomic, strong) NewNoteViewController *veryNewNoteVC;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureUp;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureDown;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;

@property (nonatomic, assign) CGFloat noteSize;
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
        make.edges.equalTo(self.view);
    }];
    
    [self populateStackview];
    
    self.topView = UIView.new;
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
    self.addNoteButton.tintColor = [UIColor notesYellow];
    self.navigationItem.rightBarButtonItem = self.addNoteButton;
    
//    [self.addNoteButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_topMargin).offset(self.spacing*2);
//        make.right.equalTo(self.view).offset(-self.spacing);
//    }];
    
}

#pragma mark - WORKING WITH THE NOTES

-(void)populateStackview
{
    NSUInteger i = 0;
    NSMutableArray *mutableSubviews = [@[] mutableCopy];
    for (i = 0; i <[AllTheNotes sharedNotes].notesArray.count; i++)
    {
        NoteView *newNoteView = [[NoteView alloc] initWithSize:self.noteSize withNote:[AllTheNotes sharedNotes].notesArray[i]];
        [mutableSubviews addObject:newNoteView];
    }
    
    self.stackView = [[UIStackView alloc] initWithArrangedSubviews:mutableSubviews];
    
    [self.scrollView addSubview:self.stackView];
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.centerY.equalTo(self.view);
    }];
    
    [self.stackView addGestureRecognizer:self.swipeGestureUp];
    [self.stackView addGestureRecognizer:self.swipeGestureDown];
    [self.stackView addGestureRecognizer:self.pinchGesture];
    
    
    self.stackView.backgroundColor = [UIColor blueColor];
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.contentMode = UIViewContentModeScaleToFill;
    self.stackView.distribution = UIStackViewDistributionEqualSpacing;
    self.stackView.alignment = UIStackViewAlignmentCenter;
    self.stackView.spacing = 20;
    
}

-(void)newNoteResult:(NSDictionary *)result
{
    NSLog(@"result dict: %@",result);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button presses

-(void)addNoteButtonWasPressed:(UIButton *)buttonPressed
{
    self.veryNewNoteVC = [[NewNoteViewController alloc] init];
    self.veryNewNoteVC.delegate = self;
    self.veryNewNoteVC.noteOrder = self.stackView.arrangedSubviews.count;
//    [self.veryNewNoteVC setModalPresentationStyle:UIModalPresentationFullScreen];
//    [self presentViewController:self.veryNewNoteVC animated:YES completion:nil];
    [self showViewController:self.veryNewNoteVC sender:self];
    
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
                                 eachNote.noteSizeValue = self.noteSize;   
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
                                 eachNote.noteSizeValue = self.noteSize;
                             }
                             self.scrollView.pagingEnabled = NO;
                             [self.view layoutIfNeeded];
                         }
                         completion:nil];

    }
    
//    NSLog(@"velocity: %1.1f scale: %1.1f", pinchGestureRecog.velocity, pinchGestureRecog.scale);
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
    
    NoteView *animatedNote = [[NoteView alloc] initWithSize:self.noteSize withNote:oldNoteView.theNoteObject];
    
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
    NSLog(@"SCROLL IS ZOOMING !!!!!!!!!!!!!!!!!!!");
}

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
    for (NoteObject *eachNote in [AllTheNotes sharedNotes].notesArray) {
        eachNote.orderNumber = i;
        i++;
    }
}


@end
