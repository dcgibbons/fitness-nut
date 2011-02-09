//
//  AthleteType.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/09/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    GeneralFitness = 0,
    BodyBuilder = 1,
    EnduranceTransition = 2,
    EndurancePreparation = 3,
    EnduranceCompetitive = 4

} AthleteTypes;

@interface AthleteType : NSObject 
{
    AthleteTypes athleteType;
}

@property (nonatomic, assign) AthleteTypes athleteType;

@end
