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

@interface BMRViewController : DetailViewController <UITableViewDelegate, 
                                                 UITableViewDataSource, 
                                                 UINavigationControllerDelegate, 
                                                 AthleteDataDelegate,
                                                 ADBannerViewDelegate,
                                                 UIPopoverControllerDelegate,
                                                 SecondaryDetailInputDelegate> 
{
    NSMutableDictionary *userData;

@private
    NSArray *sections;
    UITableView *tableView;
    UIButton *infoButton;
    ADBannerView *adBannerView;
    BOOL bannerIsVisible;
}

@property (nonatomic, retain) NSMutableDictionary *userData;
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) ADBannerView *adBannerView;
@property (nonatomic, assign) BOOL bannerIsVisible;

- (NSString *)calculateBMR;

@end
