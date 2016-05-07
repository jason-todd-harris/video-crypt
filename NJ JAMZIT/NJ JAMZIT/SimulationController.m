//
//  SimulationController.m
//  NJ JAMZIT
//
//  Created by JASON HARRIS on 5/7/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import "SimulationController.h"
#import <Masonry.h>

@interface SimulationController ()
@property (nonatomic, strong) UILabel *passengerNumber;



@end

@implementation SimulationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setSimBackground];
    [self changePassengerNumber];
    
    
}


-(void)changePassengerNumber
{
    self.passengerNumber = [[UILabel alloc] init];
    [self.passengerNumber setText:[NSString stringWithFormat:@"%@ ",@(self.numOfPeople)]];
    self.passengerNumber.backgroundColor = [UIColor colorWithWhite:100 alpha:1];
    self.passengerNumber.textAlignment = NSTextAlignmentCenter;
//    self.passengerNumber.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:34.2];
    self.passengerNumber.font = [UIFont boldSystemFontOfSize:33];
    [self.view addSubview:self.passengerNumber];
    [self.passengerNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(7);
        make.centerY.equalTo(self.view).multipliedBy(0.794);
    }];
    
    
}






-(void)setSimBackground
{
    [self.view addSubview:self.ticketView];
    
    self.view.backgroundColor = [UIColor greenColor];
    self.ticketView.contentMode = UIViewContentModeScaleToFill;
    [self.ticketView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.equalTo(self.view);
        make.top.equalTo(self.view);
        make.center.equalTo(self.view);
    }];
}





- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
