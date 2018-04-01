//
//  ContentController_iPad.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/28/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentController.h"
#import "RootViewController.h"

@interface ContentController_iPad : ContentController <UIPopoverControllerDelegate, 
                                                       UISplitViewControllerDelegate>
{   
    UISplitViewController *splitViewController;
    UINavigationController *navigationController; // contains our MasterViewController (UITableViewController)
    UINavigationController *detailNavigationController;
    
    UIPopoverController *popoverController;
    UIBarButtonItem *popoverBarButton;
}

@property (nonatomic,retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic,retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic,retain) IBOutlet UINavigationController *detailNavigationController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *popoverBarButton;

- (UIView *)view;

@end
