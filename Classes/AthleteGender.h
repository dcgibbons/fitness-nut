//
//  AthleteGender.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Male,
    Female
} Gender;

@interface AthleteGender : NSObject {
    Gender gender;
}

@property (nonatomic) Gender gender;

@end
