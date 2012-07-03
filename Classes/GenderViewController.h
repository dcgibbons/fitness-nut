//
//  GenderViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AthleteDataDelegate.h"
#import "AthleteDataProtocol.h"
#import "SecondaryDetailViewController.h"

@class AthleteGender;

@interface GenderViewController : SecondaryDetailViewController <AthleteDataProtocol>
{
    NSString *dataName;
    AthleteGender *data;
    id<AthleteDataDelegate> delegate;
    
@private
    IBOutlet UITableView *tableView;
}

@property (nonatomic, retain) NSString *dataName;
@property (nonatomic, retain) AthleteGender* data;
@property (nonatomic, assign) id<AthleteDataDelegate> delegate;
@property (nonatomic, retain) UITableView *tableView;

@end
