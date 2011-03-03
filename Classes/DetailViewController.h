//
//  DetailViewController.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/28/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>
{
    UINavigationBar *navBar;
    UIPopoverController *popoverController;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) UIPopoverController *popoverController;

@end
