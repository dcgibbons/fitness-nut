//
//  BMRViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
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

#ifdef PRO_VERSION
#import "CorePlot-CocoaTouch.h"

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
