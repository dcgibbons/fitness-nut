//
//  AthleteWeight.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Kilograms,
    Pounds
} WeightUnits;

@interface AthleteWeight : NSObject {
    NSNumber *weight;
    WeightUnits units;
}

@property (nonatomic, retain) NSNumber *weight;
@property (nonatomic) WeightUnits units;

- (id)initWithWeight:(NSNumber *)aWeight usingUnits:(WeightUnits)aUnit;

- (NSNumber *)weightAsKilograms;
- (NSNumber *)weightAsPounds;

@end
