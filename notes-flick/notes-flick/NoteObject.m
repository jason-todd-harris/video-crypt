//
//  NoteObject.m
//  notes-flick
//
//  Created by JASON HARRIS on 12/25/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import "NoteObject.h"

@implementation NoteObject

- (instancetype)init
{
    self = [self initWithNote:@"default init" withDate:nil orderNumber:0 priority:0 color:nil crossedOut:NO];
    if (self) {
        
    }
    return self;
}


- (instancetype)initWithNote:(NSString *)noteText
                    withDate:(NSDate *)date
                 orderNumber:(NSUInteger)orderNumber
                    priority:(NSUInteger)notePriority
                       color:(UIColor *)noteColor
                  crossedOut:(BOOL)crossedOut
{
    self = [super init];
    if (self) {
        _noteText = noteText;
        _orderNumber = orderNumber;
        _notePriority = notePriority;
        _crossedOut = crossedOut;
        if(date)
        {
            _noteDate = date;
        } else
        {
            _noteDate = [NSDate date];
        }
        if(noteColor)
        {
            _noteColor = noteColor;
        } else
        {
            _noteColor = [UIColor notesYellow];
        }
        
    }
    return self;
}

-(void)commonInit
{
    
    
}




@end
