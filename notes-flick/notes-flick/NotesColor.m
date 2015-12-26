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
    if ([string isEqualToString:@"yellow"])
    {
        return [UIColor notesYellow];
    } else if ([string isEqualToString:@"red"])
    {
        return [UIColor notesRed];
    } else if ([string isEqualToString:@"orange"])
    {
        return [UIColor notesOrange];
    } else if ([string isEqualToString:@"blue"])
    {
        return [UIColor notesBlue];
    } else if ([string isEqualToString:@"brown"])
    {
        return [UIColor notesBrown];
    }
    
    return [UIColor notesYellow];
}

+(NSString *)stringFromColor:(UIColor *)theColor
{
    if ([theColor isEqual:[UIColor notesYellow]]) {
        return @"yellow";
    } else if ([theColor isEqual:[UIColor notesRed]])
    {
        return @"red";
    } else if ([theColor isEqual:[UIColor notesOrange]])
    {
        return @"orange";
    } else if ([theColor isEqual:[UIColor notesBlue]])
    {
        return @"blue";
    } else if ([theColor isEqual:[UIColor notesBrown]])
    {
        return @"brown";
    }
    
    return @"yellow";
}



+(UIColor *)notesYellow { return [UIColor colorWithRed:237/255.0 green:201/255.0 blue:81/255.0 alpha:1]; }

+(UIColor *)notesRed { return [UIColor colorWithRed:204/255.0 green:51/255.0 blue:63/255.0 alpha:1]; }

+(UIColor *)notesOrange { return [UIColor colorWithRed:235/255.0 green:104/255.0 blue:65/255.0 alpha:1]; }

+(UIColor *)notesBlue { return [UIColor colorWithRed:0/255.0 green:160/255.0 blue:176/255.0 alpha:1]; }

+(UIColor *)notesBrown { return [UIColor colorWithRed:106/255.0 green:74/255.0 blue:60/255.0 alpha:1]; }

//not set up to go from color to string yet:

+(UIColor *)notesDarkGray { return [ UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1]; }

+(UIColor *)notesLightGray { return [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1]; }

+(UIColor *)notesMediumGray { return [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1]; }

+(UIColor *)notesMilk { return [UIColor colorWithRed:226/255.0 green:223/255.0 blue:154/255.0 alpha:1]; }


@end
