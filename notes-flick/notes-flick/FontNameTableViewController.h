//
//  FontNameTableViewController.h
//  notes-flick
//
//  Created by JASON HARRIS on 1/22/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FontNameTableViewDelegate

@required

-(void)newFontPicked:(NSString *)newFont;

@end

@interface FontNameTableViewController : UITableViewController
@property (nonatomic, weak) id<FontNameTableViewDelegate> delegate;

@property (nonatomic, strong) NSString *fontNamePassed;


@end
