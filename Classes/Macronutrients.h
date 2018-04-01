//
//  Macronutrients.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/14/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Macronutrients : NSObject 
{
@private
    NSUInteger carbohydrates;
    NSUInteger protein;
    NSUInteger fat;
    NSUInteger calories;
}

@property (nonatomic, readonly) NSUInteger carbohydrates;
@property (nonatomic, readonly) NSUInteger protein;
@property (nonatomic, readonly) NSUInteger fat;
@property (nonatomic, readonly) NSUInteger calories;

- (id)initWithTotalCalories:(NSUInteger)totalCalories
       andCarbohydrateRatio:(float)carbohydrateRatio
            andProteinRatio:(float)proteinRatio
                andFatRatio:(float)fatRatio;

- (id)initWithGramsOfCarbohydrates:(NSUInteger)gmCarbohydrates
                 andGramsOfProtein:(NSUInteger)gmProtein
                     andGramsOfFat:(NSUInteger)gmFat;

@end
