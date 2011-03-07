//
//  BodyFatEstimatorViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/26/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "DetailViewController.h"


@interface BodyFatEstimatorViewController : DetailViewController
{
}

- (NSString *)calculatePredictedBodyFat;

@end
