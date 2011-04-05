//
//  RootViewController.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/01/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ContentController.h"

@interface RootViewController :  UIViewController <UITableViewDataSource, 
                                                   UITableViewDelegate, 
                                                   ADBannerViewDelegate,
                                                   UIAlertViewDelegate,
                                                   UIActionSheetDelegate,
                                                   MFMailComposeViewControllerDelegate> 
{
    ContentController *contentController;
    NSMutableDictionary *userData;
    NSArray *groups;
    UITableView *menuTableView;
    ADBannerView *adBannerView;
    BOOL bannerIsVisible;
    UIActionSheet *infoActionSheet;
}

@property (nonatomic, retain) IBOutlet ContentController *contentController;
@property (nonatomic, retain) NSMutableDictionary *userData;
@property (nonatomic, retain) NSArray *groups;
@property (nonatomic, retain) IBOutlet UITableView *menuTableView;
@property (nonatomic, retain) ADBannerView *adBannerView;
@property (nonatomic, assign) BOOL bannerIsVisible;
@property (nonatomic, retain) UIActionSheet *infoActionSheet;

- (void)rateThisApp;
- (void)sendFeedback;
- (void)upgradeToProVersion;

@end
