//
//  AllTheNotes.h
//  notes-flick
//
//  Created by JASON HARRIS on 12/25/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AllTheNotes : NSObject
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSMutableArray *notesArray;
@property (nonatomic, strong) NSMutableArray *deletedArray;
@property (nonatomic, strong) NSArray *colorArray;

@property (nonatomic, assign) CGFloat defaultNoteSize;
@property (nonatomic, assign) CGFloat largeInnerNoteSize;
@property (nonatomic, assign) CGFloat currentNoteSize;

@property (nonatomic, assign) CGFloat navigationBarSize;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenWidth;

//settings
@property (nonatomic, assign) CGFloat fontDivisor;
@property (nonatomic, assign) BOOL zoomedIn;
@property (nonatomic, strong) NSArray *sortOrderArray;


//@property (nonatomic, strong) NSMutableArray *notesDictionariesArray;

-(instancetype)init;

+(instancetype)sharedNotes;

+(void)updateDefaultsWithNotes;
+(void)updateAppNotesFromNSDefaults;

+(void)updateDefaultsWithSettings;
+(void)settingsFromNSDefaults;


+(void)sortNotesByValue:(NSUInteger )willBeChanged;

@end
