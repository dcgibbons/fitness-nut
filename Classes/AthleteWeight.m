//
//  AthleteWeight.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import "AthleteWeight.h"
#import "Conversions.h"


@implementation AthleteWeight

- (id)initWithWeight:(NSNumber *)aWeight usingUnits:(WeightUnits)aUnit
{
    if (self = [super init]) {
        self.weight = aWeight;
        self.units = aUnit;
    }
    return self;
}

- (NSString *)description
{
    NSString *desc;
    if (units == Kilograms) {
        desc = [NSString stringWithFormat:@"%.0f kg", [weight floatValue]];
    } else {
        desc = [NSString stringWithFormat:@"%u lb.", [weight intValue]];
    }
    return desc;
}

- (NSNumber *)weightAsKilograms
{
    float w = [weight floatValue];
    if (units == Pounds) {
        w *= POUNDS_PER_KILOGRAM;
    }
    return [NSNumber numberWithFloat:ceil(w)];
}

- (NSNumber *)weightAsPounds
{
    float w = [weight floatValue];
    if (units == Kilograms) {
        w *= KILOGRAMS_PER_POUND;
    }
    return [NSNumber numberWithFloat:ceil(w)];
}

#pragma mark -
#pragma mark Properties

@synthesize weight, units;

@end
