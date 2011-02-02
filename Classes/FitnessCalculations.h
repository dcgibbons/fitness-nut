//
//  FitnessCalculations.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/03/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FitnessCalculations : NSObject {

}

// MD Mifflin and ST St Jeor
+ (NSInteger)bmrUsingMassInKilograms:(double)mass 
			usingHeightInCentimeters:(double)height
					 usingAgeInYears:(int)age
							usingSex:(BOOL)isMale;

+ (NSUInteger)carbohydrateNeedsUsingMassInKilograms:(double)mass
                                         usingHours:(NSUInteger)hours;

+ (NSUInteger)proteinNeedsUsingMassInKilograms:(double)mass 
                                    usingHours:(NSUInteger)hours;

+ (NSUInteger)fatNeedsUsingMassInKilograms:(double)mass
                                usingHours:(NSUInteger)hours;

@end
