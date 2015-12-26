//
//  ViewController.m
//  notes-flick
//
//  Created by JASON HARRIS on 12/23/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "NoteView.h"

@interface ViewController () <UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIView *outsideStackview;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureUp;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureDown;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, assign) CGFloat noteSize;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpEntireScreen];

}

-(void)setUpEntireScreen
{
    
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
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.scrollView.clipsToBounds = YES;
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

-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    
    return YES;
}

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
    self.stackView.spacing = 10;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - gestures

-(void)pinchReceived:(UIPinchGestureRecognizer *)pinchGestureRecog
{
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
                             [self.view layoutIfNeeded];
                         }
                         completion:nil];

    } else if (pinchGestureRecog.velocity < 0 && self.noteSize == [AllTheNotes sharedNotes].defaultNoteSize)
    {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.noteSize = [AllTheNotes sharedNotes].defaultNoteSize / 2;
                             for (NoteView *eachNote in self.stackView.arrangedSubviews) {
                                 eachNote.noteSizeValue = self.noteSize;
                             }
                             [self.view layoutIfNeeded];
                         }
                         completion:nil];

    }
    
    
    
//    [self.view layoutIfNeeded];
    
    NSLog(@"velocity: %1.1f scale: %1.1f", pinchGestureRecog.velocity, pinchGestureRecog.scale);
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
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    id i;
//    i = i;
//    [super touchesEnded:touches withEvent:event];
//    NSLog(@"user touched this object: %@",touches.anyObject.view.class);
//}

@end
