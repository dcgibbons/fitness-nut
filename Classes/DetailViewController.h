//
//  DetailViewController.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/28/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "AthleteDataDelegate.h"
#import "SecondaryDetailViewController.h"


@interface DetailViewController : UIViewController <UISplitViewControllerDelegate,
                                                    UITableViewDataSource,
                                                    UITableViewDelegate,
                                                    UIActionSheetDelegate,
                                                    SecondaryDetailInputDelegate,
                                                    UIPopoverControllerDelegate,
                                                    ADBannerViewDelegate, 
                                                    AthleteDataDelegate>
{
    NSMutableDictionary *userData;

    UIPopoverController *popoverController;
    IBOutlet UITableView *tableView;
    
    NSArray *sections;

    ADBannerView *adBannerView;
    BOOL bannerIsVisible;
}

@property (nonatomic, retain) NSMutableDictionary *userData;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, retain) ADBannerView *adBannerView;
@property (nonatomic, assign) BOOL bannerIsVisible;

- (void)share:(id)sender;
- (void)shareViaEmail;
- (void)shareViaFacebook;
- (void)shareViaTwitter;

@end
