//
//  SettingsTableViewController.h
//  notes-flick
//
//  Created by JASON HARRIS on 1/15/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsTableViewControllerDelegate

@required

-(void)changeInSettings:(NSString *)theChange;

@end


@interface SettingsTableViewController : UITableViewController
@property (nonatomic, weak) id<SettingsTableViewControllerDelegate> delegate;

@end
