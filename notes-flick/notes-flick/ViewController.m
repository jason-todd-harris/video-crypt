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
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesture;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, assign) CGFloat noteSize;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noteSize = 75;
    
    self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeReceived:)];
    self.swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.swipeGesture setDelegate:self];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor yellowColor];
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

-(void)swipeReceived:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    CGPoint point = [swipeGestureRecognizer locationInView:self.stackView];
    CGPoint pointInWindow = [swipeGestureRecognizer locationInView:self.view];
    CGFloat subviewFraction = point.x / self.stackView.bounds.size.width;
    CGFloat arrayIndexFract = subviewFraction * self.stackView.arrangedSubviews.count;
    NSLog(@". \n point in stack: %@ \n point in view: %@ \n index fract: %1.3f \n index # %lu \n subview count: %lu",NSStringFromCGPoint(point),NSStringFromCGPoint(pointInWindow), subviewFraction * self.stackView.arrangedSubviews.count,@(arrayIndexFract).integerValue *1 ,self.stackView.arrangedSubviews.count);
    
    NoteView *oldNoteView = self.stackView.arrangedSubviews[@(arrayIndexFract).integerValue *1];

    CGPoint relativeToWindow = [oldNoteView convertPoint:oldNoteView.bounds.origin toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
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
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [animatedNote mas_remakeConstraints:^(MASConstraintMaker *make) {
                             make.bottom.equalTo(self.view.mas_top);
                         }];
                         [self.view layoutIfNeeded];
                     }
                     completion:Nil];
    
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
    
    [self.stackView addGestureRecognizer:self.swipeGesture];
    
    
    self.stackView.backgroundColor = [UIColor blueColor];
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.contentMode = UIViewContentModeScaleToFill;
    self.stackView.distribution = UIStackViewDistributionEqualSpacing;
    self.stackView.alignment = UIStackViewAlignmentCenter;
    self.stackView.spacing = 20;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    id i;
//    i = i;
//    [super touchesEnded:touches withEvent:event];
//    NSLog(@"user touched this object: %@",touches.anyObject.view.class);
//}

@end
