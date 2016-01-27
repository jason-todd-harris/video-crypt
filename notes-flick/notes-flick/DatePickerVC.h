//
//  DatePickerVC.h
//  notes-flick
//
//  Created by JASON HARRIS on 1/26/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerVCDelegate

@required

-(void)datePickerFinished:(NSDate *)theDate;

@end


@interface DatePickerVC : UIViewController
@property (nonatomic, weak) id<DatePickerVCDelegate> delegate;

@property (nonatomic, strong) NSDate *notificationDate;

@end
