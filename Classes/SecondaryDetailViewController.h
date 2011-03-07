//
//  SecondaryDetailViewController.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 03/07/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SecondaryDetailViewController;
@protocol SecondaryDetailInputDelegate

// Sent when the user dismisses the input view.
- (void)didDismissInputView:(SecondaryDetailViewController *)aViewController;

@end

// This view controller is provides a secondary level of details in the navigation of the
// application. On the iPhone, this will be displayed in the navigation stack, but on the
// iPad it will be displayed in a popover.

@interface SecondaryDetailViewController : UIViewController 
{
@private
    id <SecondaryDetailInputDelegate> inputDelegate;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *doneButton;
}

@property (nonatomic, assign) id <SecondaryDetailInputDelegate> inputDelegate;
@property (nonatomic, retain) UIBarButtonItem *cancelButton;
@property (nonatomic, retain) UIBarButtonItem *doneButton;

- (BOOL)shouldShowInPopover;

// Sent when the view controller should layout the view for the specified orientation.
- (void)layoutView:(UIInterfaceOrientation)orientation;

- (void)cancel:(id)sender;
- (void)done:(id)sender;

@end
