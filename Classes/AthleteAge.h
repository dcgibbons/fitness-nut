//
//  AthleteAge.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AthleteAge : NSObject {
    NSUInteger age;
}

@property (nonatomic) NSUInteger age;

- (id)initWithAge:(NSUInteger)age; // designated initializer

@end
