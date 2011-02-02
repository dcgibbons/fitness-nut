//
//  AthleteBodyFat.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/02/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AthleteBodyFat : NSObject 
{
    NSNumber *bodyFat;
}

@property (nonatomic, retain) NSNumber *bodyFat;

- (id)initWithBodyFat:(NSNumber *)aBodyFat;

@end
