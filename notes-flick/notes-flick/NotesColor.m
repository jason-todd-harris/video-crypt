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
    if ([string isEqualToString:@"Yellow"])
    {
        return [UIColor notesYellow];
    } else if ([string isEqualToString:@"Red"])
    {
        return [UIColor notesRed];
    } else if ([string isEqualToString:@"Orange"])
    {
        return [UIColor notesOrange];
    } else if ([string isEqualToString:@"Blue"])
    {
        return [UIColor notesBlue];
    } else if ([string isEqualToString:@"Brown"])
    {
        return [UIColor notesBrown];
    }
    
    return [UIColor notesYellow];
}

+(NSString *)stringFromColor:(UIColor *)theColor
{
    if ([theColor isEqual:[UIColor notesYellow]]) {
        return @"Yellow";
    } else if ([theColor isEqual:[UIColor notesRed]])
    {
        return @"Red";
    } else if ([theColor isEqual:[UIColor notesOrange]])
    {
        return @"Orange";
    } else if ([theColor isEqual:[UIColor notesBlue]])
    {
        return @"Blue";
    } else if ([theColor isEqual:[UIColor notesBrown]])
    {
        return @"Brown";
    }
    
    return @"Yellow";
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
