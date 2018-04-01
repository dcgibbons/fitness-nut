//
//  FitnessCalculations.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/03/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
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

+ (Macronutrients *)macronutrientNeedsUsingMassInKilograms:(double)mass
                                                usingHours:(NSUInteger)hours
                                            andAthleteType:(AthleteType *)athleteType
{
    double gmCarbs = 0.0;
    double gmProtein = 0.0;
    double gmFat = 0.0;
    
    switch (athleteType.athleteType) {
        case BodyBuilder:
            gmCarbs = 2.5 * KILOGRAMS_PER_POUND;
            gmProtein = 1.0 * KILOGRAMS_PER_POUND;
            gmFat = 0.35 * KILOGRAMS_PER_POUND;
            break;
        case EnduranceTransition:
            if (hours < 8.0) {
                gmCarbs = 2.0 * KILOGRAMS_PER_POUND;
                gmProtein = 0.6 * KILOGRAMS_PER_POUND;
                gmFat = 0.30 * KILOGRAMS_PER_POUND;
            } else if (hours >= 8.0 && hours < 12.0) {
                gmCarbs = 2.5 * KILOGRAMS_PER_POUND;
                gmProtein = 0.65 * KILOGRAMS_PER_POUND;
                gmFat = 0.35 * KILOGRAMS_PER_POUND;
            } else {
                gmCarbs = 2.75 * KILOGRAMS_PER_POUND;
                gmProtein = 0.7 * KILOGRAMS_PER_POUND;
                gmFat = 0.40 * KILOGRAMS_PER_POUND;
            }
            break;
        case EndurancePreparation:
            if (hours < 8.0) {
                gmCarbs = 2.5 * KILOGRAMS_PER_POUND;
                gmProtein = 0.5 * KILOGRAMS_PER_POUND;
                gmFat = 0.35 * KILOGRAMS_PER_POUND;
            } else if (hours >= 8.0 && hours < 12.0) {
                gmCarbs = 2.75 * KILOGRAMS_PER_POUND;
                gmProtein = 0.55 * KILOGRAMS_PER_POUND;
                gmFat = 0.40 * KILOGRAMS_PER_POUND;
            } else {
                gmCarbs = 3.0 * KILOGRAMS_PER_POUND;
                gmProtein = 0.6 * KILOGRAMS_PER_POUND;
                gmFat = 0.45 * KILOGRAMS_PER_POUND;
            }
            break;
        case EnduranceCompetitive:
            if (hours < 8.0) {
                gmCarbs = 4.0 * KILOGRAMS_PER_POUND;
                gmProtein = 0.8 * KILOGRAMS_PER_POUND;
                gmFat = 0.40 * KILOGRAMS_PER_POUND;
            } else if (hours >= 8.0 && hours < 12.0) {
                gmCarbs = 4.5 * KILOGRAMS_PER_POUND;
                gmProtein = 0.85 * KILOGRAMS_PER_POUND;
                gmFat = 0.45 * KILOGRAMS_PER_POUND;
            } else {
                gmCarbs = 5.0 * KILOGRAMS_PER_POUND;
                gmProtein = 0.9 * KILOGRAMS_PER_POUND;
                gmFat = 0.50 * KILOGRAMS_PER_POUND;
            }
            break;
        case GeneralFitness:
        default:
            if (hours < 8.0) {
                gmCarbs = 2.0 * KILOGRAMS_PER_POUND;
                gmProtein = 0.6 * KILOGRAMS_PER_POUND;
                gmFat = 0.30 * KILOGRAMS_PER_POUND;
            } else if (hours >= 8.0 && hours < 12.0) {
                gmCarbs = 2.5 * KILOGRAMS_PER_POUND;
                gmProtein = 0.65 * KILOGRAMS_PER_POUND;
                gmFat = 0.35 * KILOGRAMS_PER_POUND;
            } else {
                gmCarbs = 2.75 * KILOGRAMS_PER_POUND;
                gmProtein = 0.7 * KILOGRAMS_PER_POUND;
                gmFat = 0.40 * KILOGRAMS_PER_POUND;
            }
            break;
    }
    
    NSUInteger totalCarbs = ceil(gmCarbs * mass);
    NSUInteger totalProtein = ceil(gmProtein * mass);
    NSUInteger totalFat = ceil(gmFat * mass);

    return [[[Macronutrients alloc] initWithGramsOfCarbohydrates:totalCarbs
                                               andGramsOfProtein:totalProtein
                                                   andGramsOfFat:totalFat] autorelease];
}


@end
