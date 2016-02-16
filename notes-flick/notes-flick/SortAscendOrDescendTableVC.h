//
//  DateSortTableVC.h
//  Flicky Notes
//
//  Created by JASON HARRIS on 2/13/16.
//  Copyright © 2016 jason harris. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SortOrderDelegate

@required

-(void)sortChosen;

@end

@interface SortAscendOrDescendTableVC : UITableViewController
@property (nonatomic, weak) id<SortOrderDelegate> delegate;
@property (nonatomic, strong) NSString *variableToSort;

@end

