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
        NSString *fontName = eachNote[@"fontName"];
        
        NoteView *aNoteView = [[NoteView alloc] initWithText:eachNote[@"text"]
                                                    noteSize:[AllTheNotes sharedNotes].currentNoteSize
                                                    withDate:theDate
                                                 orderNumber:orderNumber.integerValue
                                                    priority:notePriority.integerValue
                                                       color:noteColor
                                                  crossedOut:crossedOut.integerValue
                                                    fontName:fontName];
        
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
                                         @"crossedOut":@(eachNote.crossedOut),
                                         @"fontName":eachNote.noteFontName
                                         };
        [dictionaryArray addObject:noteDictionary];
    }
    
    [[AllTheNotes sharedNotes].userDefaults setObject:dictionaryArray forKey:@"notesArray"];
}


+(void)updateDefaultsWithSettings
{
    [[AllTheNotes sharedNotes].userDefaults setObject:@([AllTheNotes sharedNotes].zoomedIn)
                                               forKey:@"zoomedIn"];
    [[AllTheNotes sharedNotes].userDefaults  setObject:@([AllTheNotes sharedNotes].fontDivisor)
                                                forKey:@"fontDivisor"];
}

+(void)settingsFromNSDefaults
{
    if([[AllTheNotes sharedNotes].userDefaults objectForKey:@"zoomedIn"])
    {
        NSNumber *zoomedInNSNumber = [[AllTheNotes sharedNotes].userDefaults objectForKey:@"zoomedIn"];
        [AllTheNotes sharedNotes].zoomedIn =  zoomedInNSNumber.boolValue;
    }
    
    if([[AllTheNotes sharedNotes].userDefaults objectForKey:@"fontDivisor"])
    {
        NSNumber *divisorNSNumber = [[AllTheNotes sharedNotes].userDefaults objectForKey:@"fontDivisor"];
        [AllTheNotes sharedNotes].fontDivisor = divisorNSNumber.floatValue;
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



+(void)sortNotesByValue:(NSUInteger )willBeChanged
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"crossedOut" ascending:YES];
        
    [AllTheNotes sharedNotes].notesArray = [[AllTheNotes sharedNotes].notesArray sortedArrayUsingDescriptors:@[sortDescriptor]].mutableCopy;
    [AllTheNotes updateNoteOrderNumbers];
    
}


+(void)updateNoteOrderNumbers
{
    NSUInteger i = 0;
    for (NoteView *eachNoteView in [AllTheNotes sharedNotes].notesArray) {
        eachNoteView.orderNumber = i;
        i++;
    }
}




@end
