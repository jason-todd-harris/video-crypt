//
//  NewNoteViewController.h
//  notes-flick
//
//  Created by JASON HARRIS on 12/26/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteView.h"

@protocol NoteViewControllerDelegate

@required

-(void)newNoteResult:(NSDictionary *)result updatedNoteView:(NoteView *)updatedNoteView notificationDate:(NSDate *)notificationDate UUID:(NSString *)UUID;

@end

@interface NoteViewController : UIViewController
@property (nonatomic, weak) id<NoteViewControllerDelegate> delegate;

@property (nonatomic, strong) UITextView *noteTextView;
@property (nonatomic, strong) NoteView *theNoteView;
@property (nonatomic, strong) NSDate *notificationDate;

@property (nonatomic, assign) NSUInteger noteOrder;
@property (nonatomic, assign) BOOL areWeEditing;

@property (nonatomic, assign) CGFloat layoutGuideSize;
@property (nonatomic, assign) CGFloat fontSize;


@end
