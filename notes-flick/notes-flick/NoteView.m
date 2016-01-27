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
    self = [self initWithText:@"init used" noteSize:50 withDate:nil orderNumber:0 priority:1 color:nil crossedOut:NO fontName:nil notificationDate:nil UUID:nil];
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
            notificationDate:(NSDate *)notificationDate
                        UUID:(NSString *)UUID
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
        [_interiorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 10, 10));
            make.center.equalTo(self);
        }];
        //TEXT BOX
        _interiorTextBox = [[UILabel alloc] init];
        _interiorTextBox.contentMode = UIViewContentModeCenter;
        [self setTextValue:textValue];
        [_interiorView addSubview:_interiorTextBox];
        [_interiorTextBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.interiorView).insets(UIEdgeInsetsMake(7, 7, 7, 7));
            make.center.equalTo(self.interiorView);
        }];
        
        if(UUID)
        {
            _UUID = UUID;
        } else
        {
            _UUID = [[NSUUID UUID] UUIDString];
        }
        //SETTERS
        [self setNotificationDate:notificationDate];
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
                     fontName:noteView.noteFontName
             notificationDate:noteView.notificationDate
                         UUID:noteView.UUID];
    return self;
}


-(void)setNoteFontName:(NSString *)theNoteFontName
{
    if(!theNoteFontName)
    {
//        NSString *tempFontName = self.interiorTextBox.font.fontName;
        theNoteFontName = [AllTheNotes sharedNotes].defaultFont;
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
        }];
    }
    
    
}

-(void)removeFromSuperview //ALSO REMOVES FROM THE PERSISTENT ARRAY
{
    [[AllTheNotes sharedNotes].notesArray removeObject:self];
    [self removeConstraints:self.constraints];
    [super removeFromSuperview];
}

-(void)setNotificationDate:(NSDate *)notificationDate
{
    _notificationDate = notificationDate;
    [self setLocalNotification];
}

- (void)setLocalNotification
{
    NSArray<UILocalNotification*> *allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *eachNotification in allNotifications)
    {
        NSString *UUID = [eachNotification.userInfo valueForKey:@"UUID KEY"];
        if([UUID isEqualToString:_UUID])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:eachNotification];
        }
    }
    
    if(self.notificationDate)
    {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        
        localNotification.fireDate = _notificationDate;
        localNotification.alertBody = _textValue;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = 1; // increment
        
        NSDictionary *infoDict = @{@"UUID KEY":_UUID
                                   };
        localNotification.userInfo = infoDict;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
    }
}




@end
