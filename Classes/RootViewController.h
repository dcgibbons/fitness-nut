//
//  RootViewController.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/01/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "ContentController.h"

@interface RootViewController :  UIViewController <UITableViewDataSource, 
                                                   UITableViewDelegate, 
                                                   ADBannerViewDelegate,
                                                   UIAlertViewDelegate> 
{
    ContentController *contentController;
    NSMutableDictionary *userData;
    NSArray *groups;
    UITableView *menuTableView;
    ADBannerView *adBannerView;
    BOOL bannerIsVisible;
    
    UIView *upgradeBannerView;
}

@property (nonatomic, retain) IBOutlet ContentController *contentController;
@property (nonatomic, retain) NSMutableDictionary *userData;
@property (nonatomic, retain) NSArray *groups;
@property (nonatomic, retain) IBOutlet UITableView *menuTableView;
@property (nonatomic, retain) ADBannerView *adBannerView;
@property (nonatomic, assign) BOOL bannerIsVisible;
@property (nonatomic, retain) UIView *upgradeBannerView;

@end
