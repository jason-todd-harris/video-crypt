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
    self = [self initWithText:@"init used" noteSize:50 withDate:nil orderNumber:0 priority:1 color:nil crossedOut:NO fontName:nil];
    return self;
}

- (instancetype)initWithText:(NSString *)textValue
                    noteSize:(CGFloat)noteSizeValue
                    withDate:(NSDate *)date
                 orderNumber:(NSUInteger)orderNumber
                    priority:(NSUInteger)notePriority
                       color:(UIColor *)noteColor
                  crossedOut:(BOOL)crossedOut
                    fontName:(NSString *)fontName
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
        self.layer.cornerRadius = _interiorView.layer.cornerRadius;
        [self addSubview:_interiorView];
//        CGFloat interiorSize = ([AllTheNotes sharedNotes].screenWidth - [AllTheNotes sharedNotes].navigationBarSize - 30);
        [_interiorView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.and.width.equalTo(@(interiorSize));
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 10, 10));
            make.center.equalTo(self);
        }];
        //TEXT BOX
        _interiorTextBox = [[UILabel alloc] init];
        _interiorTextBox.contentMode = UIViewContentModeCenter;
//        _interiorView.alpha = 0.9;
//        self.backgroundColor = [UIColor blueColor];
//        _interiorTextBox.backgroundColor = [UIColor greenColor];
//        _interiorTextBox.alpha = 0.5;
        [self setTextValue:textValue];
        [_interiorView addSubview:_interiorTextBox];
        [_interiorTextBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.interiorView).insets(UIEdgeInsetsMake(5, 5, 5, 5));
            make.center.equalTo(self.interiorView);
        }];
        //SETTERS
        [self setNoteColor:noteColor];
        [self setCrossedOut:crossedOut];
        [self setNoteSizeValue:noteSizeValue];
        [self setNoteFontName:fontName];
        
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
                   crossedOut:noteView.crossedOut
                     fontName:noteView.noteFontName];
    return self;
}

-(void)setNoteFontName:(NSString *)theNoteFontName
{
    if(!theNoteFontName)
    {
        NSString *tempFontName = self.interiorTextBox.font.fontName;
        theNoteFontName = tempFontName;
    }
    _noteFontName = theNoteFontName;
    CGFloat fontSize = self.interiorTextBox.font.pointSize;
    self.interiorTextBox.font = [UIFont fontWithName:theNoteFontName size:fontSize];
}


-(void)setCrossedOut:(BOOL)crossedOut
{
    _crossedOut = crossedOut;

    if(_crossedOut)
    {
        self.alpha = 1;
        NSAttributedString* attributedText = [[NSAttributedString alloc] initWithString:_textValue
                                                                       attributes:  @{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleThick),
                                                                                      NSStrikethroughColorAttributeName : [UIColor blackColor]
                                                                                      }];
        _interiorTextBox.attributedText = attributedText;
        
    } else
    {
        self.alpha = 1;
        _interiorTextBox.text = _interiorTextBox.text;
    }
}

-(void)toggleCrossedOut
{
    _crossedOut = !_crossedOut;
    
    if(_crossedOut)
    {
        self.alpha = 1;
        
        
        NSAttributedString* attributedText = [[NSAttributedString alloc] initWithString:_textValue
                                                                             attributes:  @{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleThick),
                                                                                            NSStrikethroughColorAttributeName : [UIColor blackColor]
                                                                                            }];
        _interiorTextBox.attributedText = attributedText;
        CATransition *transition = CATransition.new; //FADES IN THE TRANSITION
        transition.delegate = self;
        transition.startProgress = 0.0;
        transition.type = kCATransitionPush;
        transition.duration = 0.5;
        [_interiorTextBox.layer addAnimation:transition forKey:@"transition"];
        
        
    } else
    {
        self.alpha = 1;
        _interiorTextBox.text = _interiorTextBox.text;
        CATransition *transition = CATransition.new; //FADES IN THE TRANSITION
        transition.delegate = self;
        transition.startProgress = 0.0;
        transition.type = kCATransitionReveal;
        transition.duration = 0.5;
        [_interiorTextBox.layer addAnimation:transition forKey:@"transition"];
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
    
    self.crossedOut = _crossedOut;
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
    
    
    if(noteSizeValue == [AllTheNotes sharedNotes].defaultNoteSize)
    { //LARGE
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.and.width.equalTo(@(noteSizeValue));
        }];
        [_interiorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.and.width.equalTo(@(([AllTheNotes sharedNotes].screenWidth - [AllTheNotes sharedNotes].navigationBarSize - 30)));
            make.center.equalTo(self);
        }];
    } else //SMALL
    {
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.and.width.equalTo(@(noteSizeValue));
        }];
        [_interiorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 10, 10));
//            make.center.equalTo(self);
        }];
    }
    
    
}

-(void)removeFromSuperview //ALSO REMOVES FROM THE PERSISTENT ARRAY
{
    [[AllTheNotes sharedNotes].notesArray removeObject:self];
    [self removeConstraints:self.constraints];
    [super removeFromSuperview];
}








@end
