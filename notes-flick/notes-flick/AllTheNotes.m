//
//  AllTheNotes.m
//  notes-flick
//
//  Created by JASON HARRIS on 12/25/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import "AllTheNotes.h"

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
    _colorArray = [@[[UIColor notesYellow], [UIColor notesOrange], [UIColor notesRed], [UIColor notesBlue], [UIColor notesGreen]] mutableCopy];
    _sortOrderArray = [@[@"Date Created", @"Colors", @"Completed Status"] mutableCopy];
    _fontDivisor = 6;
    _defaultFont = @"Helvetica";
    
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
        NSString *UUID = eachNote[@"UUID"];
        NSDate *notificationDate = eachNote[@"notificationDate"];
        
        NoteView *aNoteView = [[NoteView alloc] initWithText:eachNote[@"text"]
                                                    noteSize:[AllTheNotes sharedNotes].currentNoteSize
                                                    withDate:theDate
                                                 orderNumber:orderNumber.integerValue
                                                    priority:notePriority.integerValue
                                                       color:noteColor
                                                  crossedOut:crossedOut.integerValue
                                                    fontName:fontName
                                            notificationDate:notificationDate
                                                        UUID:UUID];
        
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
                                         @"fontName":eachNote.noteFontName,
                                         @"UUID":eachNote.UUID
                                         };
        if(eachNote.notificationDate)
        {
            noteDictionary = @{@"date":dateString,
                               @"text":eachNote.textValue,
                               @"order":@(eachNote.orderNumber),
                               @"priority":@(eachNote.notePriority),
                               @"color" : colorString,
                               @"crossedOut":@(eachNote.crossedOut),
                               @"fontName":eachNote.noteFontName,
                               @"notificationDate":eachNote.notificationDate,
                               @"UUID":eachNote.UUID
                               };
        }
        
        [dictionaryArray addObject:noteDictionary];
    }
    
    [[AllTheNotes sharedNotes].userDefaults setObject:dictionaryArray forKey:@"notesArray"];
}


+(void)updateDefaultsWithSettings
{
    [[AllTheNotes sharedNotes].userDefaults setObject:@([AllTheNotes sharedNotes].zoomedIn)
                                               forKey:@"zoomedIn"];
    
    [[AllTheNotes sharedNotes].userDefaults setObject:@([AllTheNotes sharedNotes].fontDivisor)
                                               forKey:@"fontDivisor"];

    [[AllTheNotes sharedNotes].userDefaults setObject:[AllTheNotes sharedNotes].sortOrderArray
                                               forKey:@"sortOrder"];
    
    [[AllTheNotes sharedNotes].userDefaults setObject:[AllTheNotes sharedNotes].defaultFont
                                               forKey:@"defaultFont"];
    
    //COLORS
    NSMutableArray *colorStringArray = [NSMutableArray new];
    for (UIColor *eachColor in [AllTheNotes sharedNotes].colorArray) {
        [colorStringArray addObject:[UIColor stringFromColor:eachColor]];
    }
    [[AllTheNotes sharedNotes].userDefaults setObject:colorStringArray
                                               forKey:@"colorStrings"];
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
    
    if([[AllTheNotes sharedNotes].userDefaults objectForKey:@"sortOrder"])
    {
        [AllTheNotes sharedNotes].sortOrderArray = [[[AllTheNotes sharedNotes].userDefaults objectForKey:@"sortOrder"] mutableCopy];
    }
    
    if([[AllTheNotes sharedNotes].userDefaults objectForKey:@"defaultFont"])
    {
        [AllTheNotes sharedNotes].defaultFont = [[[AllTheNotes sharedNotes].userDefaults objectForKey:@"defaultFont"] mutableCopy];
    }
    
    if([[AllTheNotes sharedNotes].userDefaults objectForKey:@"colorStrings"])
    {
        NSMutableArray *colorStrings = [[[AllTheNotes sharedNotes].userDefaults objectForKey:@"colorStrings"] mutableCopy];
        NSMutableArray *localColorArray = [@[] mutableCopy];
        for (NSString *eachString in colorStrings) {
            [localColorArray addObject:[UIColor colorWithString:eachString]];
        }
        [AllTheNotes sharedNotes].colorArray = localColorArray;
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



+(void)sortNotesByValue:(NSArray *)sortArray
{
    NSMutableArray *sortDescriptorArray = [NSMutableArray new];
    
    for (NSString *eachString in [AllTheNotes sharedNotes].sortOrderArray) {
        
        if([eachString isEqualToString:@"Colors"])
        {
            [sortDescriptorArray addObject:[NSSortDescriptor sortDescriptorWithKey:@"noteColor" ascending:YES]];
        } else if([eachString isEqualToString:@"Date Created"])
        {
            [sortDescriptorArray addObject:[NSSortDescriptor sortDescriptorWithKey:@"noteDate" ascending:YES]];
        } else if([eachString isEqualToString:@"Completed Status"])
        {
            [sortDescriptorArray addObject:[NSSortDescriptor sortDescriptorWithKey:@"crossedOut" ascending:YES]];
        }
    }
    
    
    [AllTheNotes sharedNotes].notesArray = [[AllTheNotes sharedNotes].notesArray sortedArrayUsingDescriptors:sortDescriptorArray].mutableCopy;
    [AllTheNotes updateNoteOrderNumbers];
    [AllTheNotes updateDefaultsWithNotes];
    
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
