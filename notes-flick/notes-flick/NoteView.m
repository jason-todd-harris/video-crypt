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
        [self addSubview:_interiorTextBox];
        [_interiorTextBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self setNoteSizeValue:noteSize];
        [self setTheNoteObject:theNote];
    }
    
    return self;
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
        _noteColor = [UIColor yellowColor];
    }
    
    self.backgroundColor = _noteColor;
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
    [[AllTheNotes sharedNotes].notesArray removeObject:self.theNoteObject];
    [AllTheNotes updateDefaultsWithNotes];
    [self removeConstraints:self.constraints];
    [super removeFromSuperview];
}











@end
