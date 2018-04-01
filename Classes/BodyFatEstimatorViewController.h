//
//  BodyFatEstimatorViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/26/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "DetailViewController.h"


@interface BodyFatEstimatorViewController : DetailViewController 
    <MFMailComposeViewControllerDelegate>
{
}

- (NSString *)calculatePredictedBodyFat;

@end
