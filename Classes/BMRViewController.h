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

#ifdef PRO_VERSION
@interface BMRViewController : DetailViewController <MFMailComposeViewControllerDelegate,
                                                     CPPlotDataSource>
#else
@interface BMRViewController : DetailViewController <MFMailComposeViewControllerDelegate>
#endif
{
    UIButton *infoButton;
}

@property (nonatomic, retain) IBOutlet UIButton *infoButton;

- (NSString *)calculateBMR;

#ifdef PRO_VERSION
- (CPXYGraph *)createGraph;
#endif

@end
