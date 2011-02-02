//
//  MacronutrientNeedsViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/14/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AthleteDataDelegate.h"

@interface MacronutrientNeedsViewController : UITableViewController <AthleteDataDelegate>
{
    NSMutableDictionary *userData;
    
@private
    NSArray *sections;
}

@property (nonatomic, retain) NSMutableDictionary *userData;
@property (nonatomic, retain) NSArray *sections;

@end
