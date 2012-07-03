//
//  BMRViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "AgePickerViewController.h"
#import "AthleteDataDelegate.h"
#import "DetailViewController.h"
#import "SecondaryDetailViewController.h"
#import "InfoViewController.h"
#import "CorePlot-CocoaTouch.h"

#ifdef PRO_VERSION
@interface BMRViewController : DetailViewController <CPTPlotDataSource,
                                                     InfoViewControllerDelegate,
                                                     MFMailComposeViewControllerDelegate>
#else
@interface BMRViewController : DetailViewController <InfoViewControllerDelegate,
                                                     MFMailComposeViewControllerDelegate>
#endif
{
}

- (NSString *)calculateBMR;

#ifdef PRO_VERSION
- (CPTGraph *)createGraph;
#endif

@end
