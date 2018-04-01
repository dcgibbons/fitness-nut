//
//  AthleteActivityLevel.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/12/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum 
{
    Sedentary = 0,
    LightlyActive = 1,
    ModeratelyActive = 2,
    VeryActive = 3,
    ExtraActive = 4
} ActivityLevels;

@interface AthleteActivityLevel : NSObject 
{
    ActivityLevels activityLevel;
}

@property (nonatomic, assign) ActivityLevels activityLevel;

@end
