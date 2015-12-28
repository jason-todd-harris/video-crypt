//
//  NewNoteViewController.h
//  notes-flick
//
//  Created by JASON HARRIS on 12/26/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteView.h"

@protocol NewNoteViewControllerDelegate

@required

-(void)newNoteResult:(NSDictionary *)result;

@end

@interface NewNoteViewController : UIViewController
@property (nonatomic, weak) id<NewNoteViewControllerDelegate> delegate;

@property (nonatomic, strong) UITextView *noteTextView;
@property (nonatomic, assign) NSUInteger noteOrder;


@end
