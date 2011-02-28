//
//  BodyFatEstimatorViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/26/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


@interface BodyFatEstimatorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate>
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
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, retain) ADBannerView *adBannerView;
@property (nonatomic, assign) BOOL bannerIsVisible;

- (NSString *)calculatePredictedBodyFat;

@end
