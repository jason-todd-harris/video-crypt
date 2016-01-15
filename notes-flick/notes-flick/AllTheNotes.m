//
//  AllTheNotes.m
//  notes-flick
//
//  Created by JASON HARRIS on 12/25/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import "AllTheNotes.h"
#import "NotesColor.h"
#import "NoteView.h"

@implementation AllTheNotes


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}


-(void)commonInit
{
    _notesArray = NSMutableArray.new;
    _deletedArray = NSMutableArray.new;
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _colorArray = @[ [UIColor notesYellow], [UIColor notesOrange], [UIColor notesRed], [UIColor notesBlue], [UIColor notesGreen] ];
    
}


+(void)updateAppNotesFromNSDefaults
{
    NSArray *dictionaryArray = NSArray.new;
    NSMutableArray *aNoteArray = NSMutableArray.new;
    
    if([[AllTheNotes sharedNotes].userDefaults objectForKey:@"notesArray"])
    {
         dictionaryArray = [[AllTheNotes sharedNotes].userDefaults objectForKey:@"notesArray"];
    }
    
    for (NSDictionary *eachNote in dictionaryArray)
    {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *theDate = [dateFormatter dateFromString:eachNote[@"date"]];
        NSNumber *orderNumber = eachNote[@"order"];
        NSNumber *notePriority = eachNote[@"priority"];
        NSString *colorString = eachNote[@"color"];
        UIColor *noteColor = [UIColor colorWithString:colorString];
        NSNumber *crossedOut = eachNote[@"crossedOut"];
        
        NoteView *aNoteView = [[NoteView alloc] initWithText:eachNote[@"text"]
                                                    noteSize:[AllTheNotes sharedNotes].currentNoteSize
                                                    withDate:theDate
                                                 orderNumber:orderNumber.integerValue
                                                    priority:notePriority.integerValue
                                                       color:noteColor
                                                  crossedOut:crossedOut.integerValue];
        
        [aNoteArray addObject:aNoteView];
    }
    [AllTheNotes sharedNotes].notesArray = aNoteArray;
    
}

+(void)updateDefaultsWithNotes
{
    NSMutableArray *dictionaryArray = NSMutableArray.new;
    for (NoteView *eachNote in [AllTheNotes sharedNotes].notesArray) {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [dateFormatter stringFromDate:eachNote.noteDate];
        NSString *colorString = [UIColor stringFromColor:eachNote.noteColor];
        NSDictionary *noteDictionary = @{@"date":dateString,
                                         @"text":eachNote.textValue,
                                         @"order":@(eachNote.orderNumber),
                                         @"priority":@(eachNote.notePriority),
                                         @"color" : colorString,
                                         @"crossedOut":@(eachNote.crossedOut)
                                         };
        [dictionaryArray addObject:noteDictionary];
    }
    
    [[AllTheNotes sharedNotes].userDefaults setObject:dictionaryArray forKey:@"notesArray"];
}


+(void)updateDefaultsWithZoomIn
{
        [[AllTheNotes sharedNotes].userDefaults setObject:@([AllTheNotes sharedNotes].zoomedIn)
                                                   forKey:@"zoomedIn"];
}

+(void)zoomInFromDefaults
{
    if([[AllTheNotes sharedNotes].userDefaults objectForKey:@"zoomedIn"])
    {
        NSNumber *zoomedInNSNumber = [[AllTheNotes sharedNotes].userDefaults objectForKey:@"zoomedIn"];
        [AllTheNotes sharedNotes].zoomedIn =  zoomedInNSNumber.boolValue;
    }
}

+ (instancetype)sharedNotes {
    static AllTheNotes *_sharedNotes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedNotes = [[AllTheNotes alloc] init];;
    });
    return _sharedNotes;
}







@end
