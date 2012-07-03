//
//  InfoViewController.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/03/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfoViewControllerDelegate;

@interface InfoViewController : UIViewController 
{
    id <InfoViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id <InfoViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;

@end

@protocol InfoViewControllerDelegate

-(void)infoViewControllerDidFinish:(InfoViewController *)controller;

@end
