//
//  ViewController.m
//  notes-flick
//
//  Created by JASON HARRIS on 12/23/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>

@interface ViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIView *outsideStackview;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesture;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeReceived:)];
    self.swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.swipeGesture setDelegate:self];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self populateStackview];
    
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


-(void)swipeReceived:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    
    CGPoint point = [swipeGestureRecognizer locationInView:self.stackView];
    CGPoint pointInWindow = [swipeGestureRecognizer locationInView:self.view];
    NSLog(@". \n point in stack: %@ \n point in view: %@",NSStringFromCGPoint(point),NSStringFromCGPoint(pointInWindow));
    CGFloat subviewFraction = point.x / self.stackView.bounds.size.width;
//    NSLog(@"stackview width: %f",self.stackView.bounds.size.width);
//    NSLog(@"subview count: %lu",self.stackView.arrangedSubviews.count);
//    NSLog(@"index: %1.2f",subviewFraction * self.stackView.arrangedSubviews.count);
    CGFloat arrayIndexFract = subviewFraction * self.stackView.arrangedSubviews.count;
    NSLog(@"index # %lu", @(arrayIndexFract).integerValue *1 );
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIView *viewToRemove = self.stackView.arrangedSubviews[@(arrayIndexFract).integerValue *1];
        [self.stackView removeArrangedSubview:viewToRemove];
        // above removes from arranged subviews but not from subviews... can use this to do an animation if necessary
//        [viewToRemove removeFromSuperview];
        [self viewDidLayoutSubviews];
    }];
    
}

-(void)populateStackview
{
    NSUInteger i = 0;
    NSMutableArray *mutableSubviews = [@[] mutableCopy];
    for (i = 0; i <10; i++)
    {
        UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        dummyView.backgroundColor = [UIColor redColor];
        UILabel *interiorText = [[UILabel alloc] init];
        [interiorText addGestureRecognizer:self.swipeGesture];
        interiorText.textAlignment = NSTextAlignmentCenter;
        interiorText.text = @(i).stringValue;
        [dummyView addSubview:interiorText];
        [interiorText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(dummyView);
        }];
        
        [dummyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.width.equalTo(@75);
        }];
        [dummyView addGestureRecognizer:self.swipeGesture];
        
        [mutableSubviews addObject:dummyView];
    }
    self.stackView = [[UIStackView alloc] initWithArrangedSubviews:mutableSubviews];
    
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    id i;
//    i = i;
//    [super touchesEnded:touches withEvent:event];
//    NSLog(@"user touched this object: %@",touches.anyObject.view.class);
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
