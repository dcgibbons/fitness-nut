//
//  AthleteGender.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "AthleteGender.h"


@implementation AthleteGender

@synthesize gender;

- (NSString *)description
{
    return (gender == Male) ? @"Male" : @"Female";
}

@end
