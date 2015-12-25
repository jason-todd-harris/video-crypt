//
//  NotesColor.m
//  notes-flick
//
//  Created by JASON HARRIS on 12/25/15.
//  Copyright © 2015 jason harris. All rights reserved.
//

#import "NotesColor.h"

@implementation UIColor (notesflick)

+(UIColor *)colorWithString:(NSString *)string
{
    if ([string isEqualToString:@"yellow"]) {
        return [UIColor notesYellow];
    }
    
    return [UIColor notesYellow];
}

+(NSString *)stringFromColor:(UIColor *)theColor
{
    if ([theColor isEqual:[UIColor notesYellow]]) {
        return @"yellow";
    }
    
    return @"yellow";
}



+(UIColor *)notesYellow { return [UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1]; }

+(UIColor *)notesOrange { return [UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1]; }

+(UIColor *)notesDarkGray { return [ UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1]; }

+(UIColor *)notesLightGray { return [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1]; }

+(UIColor *)notesMediumGray { return [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1]; }

+(UIColor *)notesBlue { return [UIColor colorWithRed:50/255.0 green:153/255.0 blue:187/255.0 alpha:1]; }

@end
