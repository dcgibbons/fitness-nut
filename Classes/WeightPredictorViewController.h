//
//  WeightPredictorViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/24/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WeightPredictorViewController : UITableViewController 
{
    NSMutableDictionary *userData;
    
@private
    NSArray *sections;
}

@property (nonatomic, retain) NSMutableDictionary *userData;
@property (nonatomic, retain) NSArray *sections;

- (NSString *)calculatePredictedWeight;

@end
