//
//  WeightPredictorViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/24/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "DetailViewController.h"
#import "InfoViewController.h"


@interface WeightPredictorViewController : DetailViewController <InfoViewControllerDelegate,
                                                                 MFMailComposeViewControllerDelegate>
{
}

- (NSNumber *)calculatePredictedMass;
- (NSString *)calculatePredictedWeight;
- (void)calculateWeightChangeGoodies;
- (IBAction)info:(id)sender;

@end
