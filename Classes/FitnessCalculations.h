//
//  FitnessCalculations.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/03/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macronutrients.h"
#import "AthleteType.h"

@interface FitnessCalculations : NSObject {

}

// MD Mifflin and ST St Jeor
+ (NSInteger)bmrUsingMassInKilograms:(double)mass 
			usingHeightInCentimeters:(double)height
					 usingAgeInYears:(int)age
							usingSex:(BOOL)isMale;

+ (Macronutrients *)macronutrientNeedsUsingMassInKilograms:(double)mass
                                                usingHours:(NSUInteger)hours
                                            andAthleteType:(AthleteType *)athleteType;


@end
