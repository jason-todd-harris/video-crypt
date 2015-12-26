//
//  AllTheNotes.h
//  notes-flick
//
//  Created by JASON HARRIS on 12/25/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteObject.h"

@interface AllTheNotes : NSObject
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSMutableArray *notesArray;
@property (nonatomic, strong) NSMutableArray *deletedArray;
@property (nonatomic, assign) CGFloat defaultNoteSize;

//@property (nonatomic, strong) NSMutableArray *notesDictionariesArray;

-(instancetype)init;

+(instancetype)sharedNotes;
+(void)updateDefaultsWithNotes;
+(void)updateAppNotesFromNSDefaults;

@end
