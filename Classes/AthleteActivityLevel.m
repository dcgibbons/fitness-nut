//
//  AthleteActivityLevel.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/12/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import "AthleteActivityLevel.h"


@implementation AthleteActivityLevel

@synthesize activityLevel;

- (NSString *)description
{
    NSString *descr = nil;
    switch (activityLevel) {
        case Sedentary:
            descr = @"Sedentary";
            break;
        case LightlyActive:
            descr = @"Lightly Active";
            break;
        case ModeratelyActive:
            descr = @"Moderately Active";
            break;
        case VeryActive:
            descr = @"Very Active";
            break;
        case ExtraActive:
            descr = @"Extra Active";
            break;
    }
    return descr;
}

@end
