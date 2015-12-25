//
//  NotesColor.h
//  notes-flick
//
//  Created by JASON HARRIS on 12/25/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIColor (notesflick)


+(UIColor *)colorWithString:(NSString *)string;
+(NSString *)stringFromColor:(UIColor *)theColor;


+(UIColor *)notesYellow;
+(UIColor *)notesOrange;
+(UIColor *)notesDarkGray;
+(UIColor *)notesLightGray;
+(UIColor *)notesMediumGray;
+(UIColor *)notesBlue;

@end
