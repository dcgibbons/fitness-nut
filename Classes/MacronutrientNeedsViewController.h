//
//  MacronutrientNeedsViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/14/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "AthleteDataDelegate.h"
#import "DetailViewController.h"


@interface MacronutrientNeedsViewController : DetailViewController <UITableViewDelegate, UITableViewDataSource,
        AthleteDataDelegate, ADBannerViewDelegate>
{
    NSMutableDictionary *userData;
    
@private
    UITableView *tableView;
    NSArray *sections;
    ADBannerView *adBannerView;
    BOOL bannerIsVisible;
}

@property (nonatomic, retain) NSMutableDictionary *userData;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) ADBannerView *adBannerView;
@property (nonatomic, assign) BOOL bannerIsVisible;
@property (nonatomic, retain) NSArray *sections;

@end
