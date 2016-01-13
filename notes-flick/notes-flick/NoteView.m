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
    self = [self initWithText:@"init used" noteSize:50 withDate:nil orderNumber:0 priority:1 color:nil crossedOut:NO];
    return self;
}

- (instancetype)initWithText:(NSString *)textValue
                    noteSize:(CGFloat)noteSizeValue
                    withDate:(NSDate *)date
                 orderNumber:(NSUInteger)orderNumber
                    priority:(NSUInteger)notePriority
                       color:(UIColor *)noteColor
                  crossedOut:(BOOL)crossedOut
{
    self = [super init];
    if(self)
    {
        if(date)
        {
            _noteDate = date;
        } else
        {
            _noteDate = [NSDate date];
        }
        _orderNumber = orderNumber;
        _notePriority = notePriority;
        _crossedOut = crossedOut;
        //INNER VIEW
        _interiorView = [[UIView alloc] init];
        _interiorView.layer.cornerRadius = 15;
        [self addSubview:_interiorView];
        [_interiorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
        //TEXT BOX
        _interiorTextBox = [[UILabel alloc] init];
        _interiorTextBox.contentMode = UIViewContentModeCenter;
//        _interiorTextBox.backgroundColor = [UIColor greenColor];
        [self setTextValue:textValue];
        [_interiorView addSubview:_interiorTextBox];
        [_interiorTextBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.width.equalTo(self.interiorView);
            make.center.equalTo(self.interiorView);
        }];
        //SETTERS
        [self setNoteColor:noteColor];
        [self setCrossedOut:crossedOut];
        [self setNoteSizeValue:noteSizeValue];
        
    }
    
    return self;
}


-(instancetype)initWithNoteView:(NoteView *)noteView
{
    self = [self initWithText:noteView.textValue
                     noteSize:noteView.noteSizeValue
                     withDate:noteView.noteDate
                  orderNumber:noteView.orderNumber
                     priority:noteView.notePriority
                        color:noteView.noteColor
                   crossedOut:noteView.crossedOut];
    return self;
}

//-(void)setTheNoteObject:(NoteObject *)theNoteObject
//{
//    [self setTextValue:theNoteObject.noteText];
//    [self setNoteColor:theNoteObject.noteColor];
//    _theNoteObject = theNoteObject;
//}



-(void)setCrossedOut:(BOOL)crossedOut
{
    _crossedOut = crossedOut;
    if(crossedOut)
    {
        self.alpha = 0.5;
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
    
    self.interiorView.backgroundColor = _noteColor;
}


-(void)setTextValue:(NSString *)textValue
{
    _textValue = textValue;
    _interiorTextBox.text = textValue;
    _interiorTextBox.textAlignment = NSTextAlignmentCenter;
    _interiorTextBox.numberOfLines = 0;
}


-(void)setNoteSizeValue:(CGFloat)noteSizeValue
{
    if(noteSizeValue == 0)
    {
        _noteSizeValue = [AllTheNotes sharedNotes].currentNoteSize;
    } else
    {
        _noteSizeValue = noteSizeValue;
    }
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.equalTo(@(noteSizeValue));
    }];
}

-(void)removeFromSuperview //ALSO REMOVES FROM THE PERSISTENT ARRAY
{
    [[AllTheNotes sharedNotes].notesArray removeObject:self];
    [self removeConstraints:self.constraints];
    [super removeFromSuperview];
}








@end
