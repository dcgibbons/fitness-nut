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

@interface BMRViewController : UITableViewController <UINavigationControllerDelegate, AthleteDataDelegate> 
{
    NSMutableDictionary *userData;

@private
    NSArray *sections;
}

@property (nonatomic, retain) NSMutableDictionary *userData;
@property (nonatomic, retain) NSArray *sections;

- (NSString *)calculateBMR;

@end
