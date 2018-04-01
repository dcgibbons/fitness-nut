//
//  AthleteBodyFat.m
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/02/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import "AthleteBodyFat.h"


@implementation AthleteBodyFat

@synthesize bodyFat;

- (id)initWithBodyFat:(NSNumber *)aBodyFat
{
    if (self = [super init]) {
        self.bodyFat = aBodyFat;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%.0f%%", [bodyFat doubleValue]];
}

@end
