//
//  ActivityLevelViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/12/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AthleteDataDelegate.h"


@class AthleteActivityLevel;

@interface ActivityLevelViewController : UITableViewController
{
    NSString *dataName;
    AthleteActivityLevel *data;
    id<AthleteDataDelegate> delegate;
    
@private
    NSArray *activityLevels;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *doneButton;
}

@property (nonatomic, retain) NSString *dataName;
@property (nonatomic, retain) AthleteActivityLevel *data;
@property (nonatomic, retain) id<AthleteDataDelegate> delegate;
@property (nonatomic, retain) NSArray *activityLevels;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
