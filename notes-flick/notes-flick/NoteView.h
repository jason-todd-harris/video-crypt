//
//  NoteView.h
//  notes-flick
//
//  Created by JASON HARRIS on 12/24/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteView : UIView

@property (nonatomic, strong) NSString *textValue;
@property (nonatomic, assign) CGFloat noteSizeValue;
@property (nonatomic, strong) UILabel *interiorTextBox;


//+(NoteView *)newNoteSize:(CGFloat)noteSize withText:(NSString *)text;

-(instancetype)initWithSize:(CGFloat)noteSize withText:(NSString *)text;
-(void)removeFromSuperview;

@end
