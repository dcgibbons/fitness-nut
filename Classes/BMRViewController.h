//
//  BMRViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import "AgePickerViewController.h"
#import "AthleteDataDelegate.h"
#import "DetailViewController.h"
#import "SecondaryDetailViewController.h"
#import "InfoViewController.h"

#ifdef PRO_VERSION
@interface BMRViewController : DetailViewController <CPPlotDataSource,
                                                     InfoViewControllerDelegate>
#else
@interface BMRViewController : DetailViewController <InfoViewControllerDelegate>
#endif
{
}

- (NSString *)calculateBMR;

#ifdef PRO_VERSION
- (CPXYGraph *)createGraph;
#endif

@end
