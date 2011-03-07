//
//  ContentController_iPad.m
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/28/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "ContentController_iPad.h"
#import "DetailViewController.h"

@implementation ContentController_iPad

static NSString *buttonTitle = @"Fitness Nut";

@synthesize splitViewController, navigationController, detailNavigationController;
@synthesize popoverController;
@synthesize popoverBarButton;

- (void)awakeFromNib
{
    // configure the master popover button:
    //
    // In portrait mode (when the master view is not being displayed by the split view controller)
    // add a bar button item to display the master view in a popover; in landcape mode, remove the button.
    //
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
    {
        UIBarButtonItem *popoverMasterViewControllerBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:buttonTitle
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(presentMasterInPopoverFromBarButtonItem:)];
        // TODO XXX FIXME
//        [self.detailViewController.navBar.topItem setLeftBarButtonItem:popoverMasterViewControllerBarButtonItem 
//                                                              animated:YES];
        self.popoverBarButton = popoverMasterViewControllerBarButtonItem;
        [popoverMasterViewControllerBarButtonItem release];
    }
    else
    {
        // TODO XXX FIXME
//        [self.detailViewController.navBar.topItem setLeftBarButtonItem:nil animated:YES];
    }
}

- (IBAction)presentMasterInPopoverFromBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.popoverController presentPopoverFromBarButtonItem:barButtonItem
                                   permittedArrowDirections:UIPopoverArrowDirectionUp
                                                   animated:YES];
}

- (void)dealloc
{
    [splitViewController release];
    [masterViewController release];
    [popoverController release];
    [navigationController release];
    [detailNavigationController release];
    [detailViewController release];
    
    [super dealloc];
}

- (void)setDetailViewController:(DetailViewController *)aDetailViewController
{
    if (aDetailViewController != detailViewController) {
        [detailViewController release];
        detailViewController = [aDetailViewController retain];
        
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
            detailViewController.navigationItem.leftBarButtonItem = self.popoverBarButton;
        } else {
            detailViewController.navigationItem.leftBarButtonItem = nil;
        }
        
        detailNavigationController.viewControllers = [NSArray arrayWithObject:detailViewController];
    }

    [self.popoverController dismissPopoverAnimated:YES];
}

- (UIView *)view
{
    return self.splitViewController.view;
}

#pragma mark -
#pragma mark Split view support

- (void)splitViewController:(UISplitViewController *)svc 
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    [barButtonItem setTitle:buttonTitle];
    detailViewController.navigationItem.leftBarButtonItem = barButtonItem;
    self.popoverController = pc;
}


// called when the view is shown again in the split view, invalidating the button and popover controller
//
- (void)splitViewController:(UISplitViewController *)svc 
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    detailViewController.navigationItem.leftBarButtonItem = nil;
    self.popoverController = nil;
}

@end
