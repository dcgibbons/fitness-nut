//
//  WeightPredictorViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/24/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import "DetailViewController.h"
#import "InfoViewController.h"


@interface WeightPredictorViewController : DetailViewController <InfoViewControllerDelegate>
{
}

- (NSString *)calculatePredictedWeight;
- (IBAction)info:(id)sender;

@end
