//
//  NoteObject.h
//  notes-flick
//
//  Created by JASON HARRIS on 12/25/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotesColor.h"

@interface NoteObject : NSObject
@property (nonatomic, strong) NSString *noteText;
@property (nonatomic, strong) NSDate *noteDate;
@property (nonatomic, assign) NSUInteger orderNumber;
@property (nonatomic, strong) UIColor *noteColor;
@property (nonatomic, assign) NSUInteger notePriority;
@property (nonatomic, assign) bool crossedOut;


- (instancetype)initWithNote:(NSString *)noteText
                    withDate:(NSDate *)date
                 orderNumber:(NSUInteger)orderNumber
                    priority:(NSUInteger)notePriority
                       color:(UIColor *)noteColor
                  crossedOut:(BOOL)crossedOut;





@end
