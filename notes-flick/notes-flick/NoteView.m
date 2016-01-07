//
//  NoteView.m
//  notes-flick
//
//  Created by JASON HARRIS on 12/24/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import "NoteView.h"
#import <Masonry.h>
#import "NotesColor.h"
#import "AllTheNotes.h"

@interface NoteView ()
//@property (nonatomic, strong) UIColor *backgroundColor;

@end

@implementation NoteView

-(instancetype)init
{
    NoteObject *theNote = [[NoteObject alloc] initWithNote:@"init used"
                                                  withDate:nil
                                               orderNumber:0
                                                  priority:1
                                                     color:nil
                                                crossedOut:0];
    self = [self initWithSize:50 withNote:theNote];
    return self;
}

-(instancetype)initWithSize:(CGFloat)noteSize withNote:(NoteObject *)theNote
{
    self = [super init];
    if(self)
    {
        _interiorTextBox = [[UILabel alloc] init];
        _interiorTextBox.textAlignment = NSTextAlignmentCenter;
        _interiorTextBox.backgroundColor = [UIColor colorWithRed:100/255 green:0/255 blue:0/255 alpha:0.0];// debugging text box
        _interiorTextBox.numberOfLines = 0;
        [self addSubview:_interiorTextBox];
        [_interiorTextBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.width.equalTo(self);
            make.center.equalTo(self);
        }];
        [self setNoteSizeValue:noteSize];
        [self setTheNoteObject:theNote];
        [self setCrossedOut:theNote.crossedOut];
    }
    
    return self;
}
-(void)setCrossedOut:(BOOL)crossedOut
{
    _crossedOut = crossedOut;
    _theNoteObject.crossedOut = crossedOut;
    
    if(crossedOut)
    {
        self.alpha = 0.333;
    } else
    {
        self.alpha = 1;
    }
    
    
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    if(backgroundColor)
    {
        _noteColor = backgroundColor;
    } else
    {
        _noteColor = [UIColor notesYellow];
    }
    _theNoteObject.noteColor = backgroundColor;
}

-(void)setTheNoteObject:(NoteObject *)theNoteObject
{
    [self setTextValue:theNoteObject.noteText];
    [self setNoteColor:theNoteObject.noteColor];
    _theNoteObject = theNoteObject;
}


-(void)setNoteColor:(UIColor *)noteColor
{
    if(noteColor)
    {
         _noteColor = noteColor;
    } else
    {
        _noteColor = [UIColor notesYellow];
    }
    
    self.backgroundColor = _noteColor;
    _theNoteObject.noteColor = noteColor;
}


-(void)setTextValue:(NSString *)textValue
{
    _textValue = textValue;
    _interiorTextBox.text = textValue;
    _interiorTextBox.textAlignment = NSTextAlignmentCenter;
    _theNoteObject.noteText = textValue;
}


-(void)setNoteSizeValue:(CGFloat)noteSizeValue
{
    _noteSizeValue = noteSizeValue;
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.equalTo(@(noteSizeValue));
    }];
}

-(void)removeFromSuperview //ALSO REMOVES FROM THE PERSISTENT ARRAY
{
    [[AllTheNotes sharedNotes].notesArray removeObject:self.theNoteObject];
    [self removeConstraints:self.constraints];
    [super removeFromSuperview];
}








@end
