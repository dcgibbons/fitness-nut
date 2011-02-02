//
//  AthleteMeasurement.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/26/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "AthleteMeasurement.h"
#import "Conversions.h"

@implementation AthleteMeasurement

- (id)initWithMeasurement:(NSNumber *)aMeasurement usingUnits:(MeasurementUnits)aUnit
{
    if (self = [super init]) {
        self.measurement = aMeasurement;
        self.units = aUnit;
    }
    return self;
}

- (NSString *)description
{
    NSString *desc;
    
    if (units == MeasurementInches) {
        desc = [NSString stringWithFormat:@"%d\"", [measurement intValue]];
    } else {
        desc = [NSString stringWithFormat:@"%.0f cm", [measurement floatValue]];
    }
    
    return desc;
}

- (NSNumber *)measurementAsInches
{
    float m = [measurement floatValue];
    if (units == MeasurementCentimeters) {
        m *= CENTIMETERS_PER_INCH;
    }
    return [NSNumber numberWithFloat:m];
}

- (NSNumber *)measurementAsCentimeters
{
    float m = [measurement floatValue];
    if (units == MeasurementInches) {
        m *= INCHES_PER_CENTIMETER;
    }
    return [NSNumber numberWithFloat:m];
}


#pragma mark -
#pragma mark Properties

@synthesize measurement, units;

@end
