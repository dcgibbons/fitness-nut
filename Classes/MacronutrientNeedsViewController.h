//
//  MacronutrientNeedsViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/14/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AthleteDataDelegate.h"
#import "DetailViewController.h"
#import "InfoViewController.h"

@interface MacronutrientNeedsViewController : DetailViewController <MFMailComposeViewControllerDelegate,
                                                                    InfoViewControllerDelegate>
{
}

@end
