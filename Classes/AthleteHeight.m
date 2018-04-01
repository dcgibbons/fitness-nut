//
//  AthleteHeight.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import "AthleteHeight.h"
#import "Conversions.h"

@implementation AthleteHeight

- (id)initWithHeight:(NSNumber *)aHeight usingUnits:(HeightUnits)aUnit
{
    if (self = [super init]) {
        self.height = aHeight;
        self.units = aUnit;
    }
    return self;
}

- (NSString *)description
{
    NSString *desc;
    
    if (units == Inches) {
        int feet = [height intValue] / 12;
        int inches = [height intValue] % 12;
        desc = [NSString stringWithFormat:@"%d' %d\"", feet, inches];
    } else {
        desc = [NSString stringWithFormat:@"%.0f cm", [height floatValue]];
    }
    
    return desc;
}

- (NSNumber *)heightAsInches
{
    float h = [height floatValue];
    if (units == Centimeters) {
        h *= CENTIMETERS_PER_INCH;
    }
    return [NSNumber numberWithFloat:ceil(h)];
}

- (NSNumber *)heightAsCentimeters
{
    float h = [height floatValue];
    if (units == Inches) {
        h *= INCHES_PER_CENTIMETER;
    }
    return [NSNumber numberWithFloat:ceil(h)];
}


#pragma mark -
#pragma mark Properties

@synthesize height, units;

@end
