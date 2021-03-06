//
//  AllTheNotes.h
//  notes-flick
//
//  Created by JASON HARRIS on 12/25/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteView.h"
#import "NotesColor.h"


@interface AllTheNotes : NSObject


@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSMutableArray<NoteView *> *notesArray;
@property (nonatomic, strong) NSMutableArray<NoteView *> *deletedArray;
@property (nonatomic, strong) NSMutableArray<UIColor *> *colorArray;
@property (nonatomic, strong, readonly) NSArray<NSString *> *beginningInstructions;

@property (nonatomic, assign) CGFloat defaultNoteSize;
@property (nonatomic, assign) CGFloat currentNoteSize;

@property (nonatomic, assign) CGFloat navigationBarSize;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenWidth;

@property (nonatomic, strong) UILocalNotification *launchNotification;

//settings
@property (nonatomic, strong) NSString *defaultFont;
@property (nonatomic, assign) CGFloat fontDivisor;
@property (nonatomic, assign) BOOL zoomedIn;
@property (nonatomic, assign) BOOL notFirstLoad;
@property (nonatomic, assign) BOOL scrollVertically;
@property (nonatomic, assign) BOOL ignoreScrollSettings;
@property (nonatomic, assign) BOOL sortDateAscending;
@property (nonatomic, assign) BOOL sortCrossOutAscending;


//SORT SETTINGS
@property (nonatomic, strong) NSMutableArray<NSString *> *sortOrderArray;


//@property (nonatomic, strong) NSMutableArray *notesDictionariesArray;

-(instancetype)init;

+(instancetype)sharedNotes;

+(void)updateDefaultsWithNotes;
+(void)updateAppNotesFromNSDefaults;

+(void)updateDefaultsWithSettings;
+(void)settingsFromNSDefaults;


+(void)sortNotesByValue:(NSArray *)sortArray;

+ (void)renumberBadgesOfPendingNotifications;

@end
