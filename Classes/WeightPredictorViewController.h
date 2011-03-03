//
//  WeightPredictorViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/24/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "DetailViewController.h"


@interface WeightPredictorViewController : DetailViewController <UITableViewDelegate, UITableViewDataSource,
    ADBannerViewDelegate>
{
    NSMutableDictionary *userData;
    
@private
    UITableView *tableView;
    ADBannerView *adBannerView;
    BOOL bannerIsVisible;
    NSArray *sections;
}

@property (nonatomic, retain) NSMutableDictionary *userData;
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) ADBannerView *adBannerView;
@property (nonatomic, assign) BOOL bannerIsVisible;

- (NSString *)calculatePredictedWeight;

@end
