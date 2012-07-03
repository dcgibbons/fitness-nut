//
//  ContentController.m
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/28/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import "ContentController.h"
#import "RootViewController.h"
#import "DetailViewController.h"

@implementation ContentController

@synthesize userData, masterViewController, detailViewController;

- (void)dealloc
{
    [userData release];
    [super dealloc];
}

- (UIView *)view
{
    return nil; // subclasses need to override this with their own view property
}

- (void)setUserData:(NSMutableDictionary *)newUserData
{
    [userData release];
    userData = [newUserData retain];
    self.masterViewController.userData = userData;
}

@end
