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
    self = [self initWithNote:@"default init" withDate:nil orderNumber:0];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithNote:(NSString *)noteText withDate:(NSDate *)date orderNumber:(NSUInteger)orderNumber
{
    self = [super init];
    if (self) {
        _noteText = noteText;
        if(date)
        {
            _noteDate = date;
        } else
        {
            _noteDate = [NSDate date];
        }
        _orderNumber = orderNumber;
    }
    return self;
}




@end
