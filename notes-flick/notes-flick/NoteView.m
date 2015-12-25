//
//  NoteView.m
//  notes-flick
//
//  Created by JASON HARRIS on 12/24/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import "NoteView.h"
#import <Masonry.h>

@implementation NoteView

-(instancetype)init
{
    self = [self initWithSize:50 withText:@"init used"];
    return self;
}

-(instancetype)initWithSize:(CGFloat)noteSize withText:(NSString *)text
{
    self = [super init];
    if(self)
    {
        _interiorTextBox = [[UILabel alloc] init];
        _interiorTextBox.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_interiorTextBox];
        [_interiorTextBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self setTextValue:text];
        [self setNoteSizeValue:noteSize];
        self.backgroundColor = [UIColor redColor];
    }
    
    return self;
}


-(void)setTextValue:(NSString *)textValue
{
    _textValue = textValue;
    _interiorTextBox.text = textValue;
    _interiorTextBox.textAlignment = NSTextAlignmentCenter;
}


-(void)setNoteSizeValue:(CGFloat)noteSizeValue
{
    _noteSizeValue = noteSizeValue;
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.equalTo(@(noteSizeValue));
    }];
}

-(void)removeFromSuperview
{
    [self removeConstraints:self.constraints];
    [super removeFromSuperview];
}

//+(NoteView *)newNoteSize:(CGFloat)noteSize withText:(NSString *)text
//{
//    NoteView *theNoteView = [[NoteView alloc] init];
//    theNoteView.noteSizeValue = noteSize;
//    theNoteView.textValue = text;
//    theNoteView.backgroundColor = [UIColor redColor];
//    return theNoteView;
//}










@end
