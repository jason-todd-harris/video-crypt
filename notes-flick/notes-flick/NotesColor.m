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

+(UIColor *)notesRed { return [UIColor colorWithRed:252/255.0 green:157/255.0 blue:154/255.0 alpha:1]; }

+(UIColor *)notesOrange { return [UIColor colorWithRed:249/255.0 green:205/255.0 blue:173/255.0 alpha:1]; }

+(UIColor *)notesBlue { return [UIColor colorWithRed:131/255.0 green:206/255.0 blue:202/255.0 alpha:1]; }

+(UIColor *)notesBrown { return [UIColor colorWithRed:254/255.0 green:67/255.0 blue:101/255.0 alpha:1]; }

//not set up to go from color to string yet:

+(UIColor *)notesDarkGray { return [ UIColor colorWithRed:131/255.0 green:175/255.0 blue:155/255.0 alpha:1]; }

+(UIColor *)notesLightGray { return [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1]; }

+(UIColor *)notesMediumGray { return [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1]; }

+(UIColor *)notesMilk { return [UIColor colorWithRed:226/255.0 green:223/255.0 blue:154/255.0 alpha:1]; }


@end
