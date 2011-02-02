//
//  GenderViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AthleteDataDelegate.h"

@class AthleteGender;

@interface GenderViewController : UITableViewController 
{
    NSString *dataName;
    AthleteGender *data;
    id<AthleteDataDelegate> delegate;
    
@private
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *doneButton;
}

@property (nonatomic, retain) NSString *dataName;
@property (nonatomic, retain) AthleteGender* data;
@property (nonatomic, assign) id<AthleteDataDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
