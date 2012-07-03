//
//  AthleteTypePickerViewController.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/09/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AthleteDataDelegate.h"
#import "AthleteType.h"
#import "AthleteDataProtocol.h"
#import "SecondaryDetailViewController.h"


@interface AthleteTypeViewController : SecondaryDetailViewController <AthleteDataProtocol,
                                                                      UITableViewDataSource,
                                                                      UITableViewDelegate>
{
    NSString *dataName;
    AthleteType *data;
    id<AthleteDataDelegate> delegate;
    
@private
    NSArray *athleteTypes;
    UITableView *tableView;
}

@property (nonatomic, retain) NSString *dataName;
@property (nonatomic, retain) AthleteType *data;
@property (nonatomic, retain) id<AthleteDataDelegate> delegate;
@property (nonatomic, retain) NSArray *athleteTypes;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
