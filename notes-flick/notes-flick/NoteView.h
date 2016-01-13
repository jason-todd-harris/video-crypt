//
//  NoteView.h
//  notes-flick
//
//  Created by JASON HARRIS on 12/24/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteObject.h"

@interface NoteView : UIView

@property (nonatomic, strong) NSString *textValue;
@property (nonatomic, assign) CGFloat noteSizeValue;
@property (nonatomic, strong) UILabel *interiorTextBox;
@property (nonatomic, strong) NoteObject *theNoteObject;
@property (nonatomic, strong) UIColor *noteColor;
@property (nonatomic, assign) BOOL crossedOut;


//ADDING
@property (nonatomic, strong) NSDate *noteDate;
@property (nonatomic, assign) NSUInteger orderNumber;
@property (nonatomic, assign) NSUInteger notePriority;


-(instancetype)initWithSize:(CGFloat)noteSize withNote:(NoteObject *)theNote;
-(void)removeFromSuperview;

@end
