//
//  WeightPredictorViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/24/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "DetailViewController.h"


@interface WeightPredictorViewController : DetailViewController <MFMailComposeViewControllerDelegate>
{
}

- (NSString *)calculatePredictedWeight;

@end
