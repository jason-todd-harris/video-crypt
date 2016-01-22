//
//  NoteView.h
//  notes-flick
//
//  Created by JASON HARRIS on 12/24/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteView : UIView

@property (nonatomic, strong) UILabel *interiorTextBox;
@property (nonatomic, strong) UIView *interiorView;

@property (nonatomic, strong) NSString *textValue;
@property (nonatomic, strong) NSString *noteFontName;

@property (nonatomic, assign) CGFloat noteSizeValue;
@property (nonatomic, strong) UIColor *noteColor;
@property (nonatomic, assign) BOOL crossedOut;
@property (nonatomic, strong) NSDate *noteDate;
@property (nonatomic, assign) NSUInteger orderNumber;
@property (nonatomic, assign) NSUInteger notePriority;




- (instancetype)initWithText:(NSString *)textValue
                    noteSize:(CGFloat)noteSizeValue
                    withDate:(NSDate *)date
                 orderNumber:(NSUInteger)orderNumber
                    priority:(NSUInteger)notePriority
                       color:(UIColor *)noteColor
                  crossedOut:(BOOL)crossedOut
                    fontName:(NSString *)fontName;

- (instancetype)initWithNoteView:(NoteView *)noteView;

-(void)toggleCrossedOut;

-(void)removeFromSuperview;

@end
