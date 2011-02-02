//
//  AthleteDataDelegate.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AthleteDataDelegate

- (void)athleteDataInputDone:(UIViewController *)viewController
               withDataNamed:(NSString *)dataName
               withDataValue:(id)data;

@end
