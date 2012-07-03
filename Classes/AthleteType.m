//
//  AthleteType.m
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/09/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import "AthleteType.h"


@implementation AthleteType

@synthesize athleteType;

- (NSString *)description
{
    NSString *descr;

    switch (athleteType) {
        case GeneralFitness:
            descr = @"General Fitness";
            break;
        case BodyBuilder:
            descr = @"Body Builder";
            break;
        case EnduranceTransition:
            descr = @"Endurance - Transition";
            break;
        case EndurancePreparation:
            descr = @"Endurance - Preparation";
            break;
        case EnduranceCompetitive:
            descr = @"Endurance - Competitive";
            break;
    }

    return descr;
}

@end
