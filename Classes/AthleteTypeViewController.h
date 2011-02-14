//
//  AthleteTypePickerViewController.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/09/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AthleteDataDelegate.h"
#import "AthleteType.h"
#import "AthleteDataProtocol.h"


@interface AthleteTypeViewController : UITableViewController <AthleteDataProtocol>
{
    NSString *dataName;
    AthleteType *data;
    id<AthleteDataDelegate> delegate;
    
@private
    NSArray *athleteTypes;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *doneButton;
}

@property (nonatomic, retain) NSString *dataName;
@property (nonatomic, retain) AthleteType *data;
@property (nonatomic, retain) id<AthleteDataDelegate> delegate;
@property (nonatomic, retain) NSArray *athleteTypes;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
