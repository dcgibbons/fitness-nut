//
//  ContentController_iPhone.m
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/28/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "ContentController_iPhone.h"
#import "DetailViewController.h"

@implementation ContentController_iPhone

@synthesize navigationController;

- (void)dealloc
{
    [detailViewController release];
    [navigationController release];
    [super dealloc];
}

- (UIView *)view
{
    return self.navigationController.view;
}

- (void)setDetailViewController:(DetailViewController *)aDetailViewController
{
    [detailViewController release];
    detailViewController = [aDetailViewController retain];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
