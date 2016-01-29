//
//  ScrollView.h
//  notes-flick
//
//  Created by JASON HARRIS on 1/29/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollView : UIScrollView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *scrollViewTWO;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIStackView *stackViewTWO;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *topViewTWO;


@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureUp;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureDown;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;

@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat transformScalar;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) CGFloat noteSize;
@property (nonatomic, assign) CGFloat fontDivisor;
@property (nonatomic, assign) CGFloat largeFontSize;
@property (nonatomic, assign) BOOL alreadyLoaded;
@property (nonatomic, assign) BOOL zoomedIn;

@end
