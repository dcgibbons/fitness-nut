//
//  Macronutrients.m
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/14/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "Macronutrients.h"


@implementation Macronutrients

@synthesize carbohydrates, protein, fat, calories;

- (id)initWithTotalCalories:(NSUInteger)totalCalories
       andCarbohydrateRatio:(float)carbohydrateRatio
            andProteinRatio:(float)proteinRatio
                andFatRatio:(float)fatRatio
{
    if (self = [super init]) {
        calories = totalCalories;
        // TODO: ensure the 3 ratios add up to 100%
        carbohydrates = ceil((float)totalCalories * carbohydrateRatio / 4.0);
        protein = ceil((float)totalCalories * proteinRatio / 4.0);
        fat = ceil((float)totalCalories * fatRatio / 9.0);
    }
    return self;
}

- (id)initWithGramsOfCarbohydrates:(NSUInteger)gmCarbohydrates
                 andGramsOfProtein:(NSUInteger)gmProtein
                     andGramsOfFat:(NSUInteger)gmFat
{
    if (self = [super init]) {
        carbohydrates = gmCarbohydrates;
        protein = gmProtein;
        fat = gmFat;
        calories = (carbohydrates * 4) + (protein * 4) + (fat * 9);
    }
    return self;
}

@end
