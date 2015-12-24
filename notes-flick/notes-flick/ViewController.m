//
//  ViewController.m
//  notes-flick
//
//  Created by JASON HARRIS on 12/23/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>

@interface ViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIView *outsideStackview;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor yellowColor];
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self populateStackview];
    
    [self.scrollView addSubview:self.stackView];
    
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.centerY.equalTo(self.view);
//        make.centerY.equalTo(self.view);
    }];
    
    
    self.stackView.backgroundColor = [UIColor blueColor];
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.contentMode = UIViewContentModeScaleToFill;
    self.stackView.distribution = UIStackViewDistributionEqualSpacing;
    self.stackView.alignment = UIStackViewAlignmentCenter;
    self.stackView.spacing = 20;   
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
        interiorText.textAlignment = NSTextAlignmentCenter;
        interiorText.text = @(i*i).stringValue;
        [dummyView addSubview:interiorText];
        [interiorText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(dummyView);
        }];
        
        [dummyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.width.equalTo(@200);
        }];
        
        [mutableSubviews addObject:dummyView];
    }
    self.stackView = [[UIStackView alloc] initWithArrangedSubviews:mutableSubviews];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
