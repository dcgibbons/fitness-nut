//
//  ActivityLevelViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/12/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AthleteDataDelegate.h"
#import "AthleteDataProtocol.h"
#import "SecondaryDetailViewController.h"


@class AthleteActivityLevel;

@interface ActivityLevelViewController : SecondaryDetailViewController <AthleteDataProtocol>
{
    NSString *dataName;
    AthleteActivityLevel *data;
    id<AthleteDataDelegate> delegate;
    
@private
    NSArray *activityLevels;
    UITableView *tableView;
}

@property (nonatomic, retain) NSString *dataName;
@property (nonatomic, retain) AthleteActivityLevel *data;
@property (nonatomic, retain) id<AthleteDataDelegate> delegate;
@property (nonatomic, retain) NSArray *activityLevels;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
