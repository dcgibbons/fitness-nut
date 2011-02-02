//
//  FitnessCalculations.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/03/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "FitnessCalculations.h"
#import "Conversions.h"

@implementation FitnessCalculations

// Basal Metabolic Rate (BMR) estimation using MD Mifflin and ST St Jeor
// equation.

+ (NSInteger)bmrUsingMassInKilograms:(double)mass
			usingHeightInCentimeters:(double)height
					 usingAgeInYears:(int)age
							usingSex:(BOOL)isMale
{
	double p = (10.0 * mass)
	         + (6.25 * height)
	         - (5.0 * age)
	         + ((isMale) ? 5 : -161);
    
	return (NSInteger)ceil(p);
}

// TODO STUFF!
+ (NSUInteger)carbohydrateNeedsUsingMassInKilograms:(double)mass
                                         usingHours:(NSUInteger)hours
{
    double gramsPerKg;
    if (hours < 8.0) {
        gramsPerKg = 2.5 * KILOGRAMS_PER_POUND;
    } else if (hours >= 8.0 && hours < 12.0) {
        gramsPerKg = 2.75 * KILOGRAMS_PER_POUND;
    } else {
        gramsPerKg = 3.0 * KILOGRAMS_PER_POUND;
    }
    
    return ceil(gramsPerKg * mass);
}

+ (NSUInteger)proteinNeedsUsingMassInKilograms:(double)mass 
                                    usingHours:(NSUInteger)hours
{
    double gramsPerKg;
    if (hours < 8.0) {
        gramsPerKg = 0.5 * KILOGRAMS_PER_POUND;
    } else if (hours >= 8.0 & hours < 12.0) {
        gramsPerKg = 0.55 * KILOGRAMS_PER_POUND;
    } else {
        gramsPerKg = 0.6 * KILOGRAMS_PER_POUND;
    }
    
    return ceil(gramsPerKg * mass);
}

+ (NSUInteger)fatNeedsUsingMassInKilograms:(double)mass
                                usingHours:(NSUInteger)hours
{
    double gramsPerKg;
    
    // 0.35 - 0.45 grams per lbs of body weight, foundation period
    if (hours < 8.0) {
        gramsPerKg = 0.35 * KILOGRAMS_PER_POUND;
    } else if (hours >= 8.0 & hours < 12.0) {
        gramsPerKg = 0.40 * KILOGRAMS_PER_POUND;
    } else {
        gramsPerKg = 0.45 * KILOGRAMS_PER_POUND;
    }
    
    return ceil(gramsPerKg * mass);
}


@end
