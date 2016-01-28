//
//  AlignmentTableVC.h
//  notes-flick
//
//  Created by JASON HARRIS on 1/27/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlignmentDelegate

@required

-(void)alignmentChosen;

@end

@interface AlignmentTableVC : UITableViewController
@property (nonatomic, weak) id<AlignmentDelegate> delegate;

@end
