//
//  AthleteMeasurement.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/26/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MeasurementInches,
    MeasurementCentimeters
} MeasurementUnits;

@interface AthleteMeasurement : NSObject 
{
    NSNumber *measurement;
    MeasurementUnits units;
}

@property (nonatomic, retain) NSNumber *measurement;
@property (nonatomic) MeasurementUnits units;

- (id)initWithMeasurement:(NSNumber *)aMeasurement usingUnits:(MeasurementUnits)aUnit;

- (NSNumber *)measurementAsInches;
- (NSNumber *)measurementAsCentimeters;

@end
