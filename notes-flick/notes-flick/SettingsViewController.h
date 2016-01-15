//
//  SettingsViewController.h
//  notes-flick
//
//  Created by JASON HARRIS on 1/15/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (nonatomic, strong) UISegmentedControl *sortSegments;
@property (nonatomic, strong) UISlider *fontSlider;

@property (nonatomic, assign) CGFloat fontDivisor;


@end
