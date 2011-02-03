//
//  BMRViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgePickerViewController.h"
#import "AthleteDataDelegate.h"

@interface BMRViewController : UIViewController <UITableViewDelegate, 
                                                 UITableViewDataSource, 
                                                 UINavigationControllerDelegate, 
                                                 AthleteDataDelegate> 
{
    NSMutableDictionary *userData;

@private
    NSArray *sections;
    UITableView *tableView;
    UIButton *infoButton;
}

@property (nonatomic, retain) NSMutableDictionary *userData;
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;

- (NSString *)calculateBMR;

@end
