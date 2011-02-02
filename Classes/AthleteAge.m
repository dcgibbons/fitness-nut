//
//  AthleteAge.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "AthleteAge.h"


@implementation AthleteAge

- (id)initWithAge:(NSUInteger)initialAge
{
    if (self = [super init]) {
        self.age = initialAge;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%u years", age];
}

#pragma mark -
#pragma mark Properties

- (NSUInteger)age
{
    return age;
}

- (void)setAge:(NSUInteger)newAge
{
    if (newAge >= 10 && newAge <= 100) {
        age = newAge;
    }
}

@end
