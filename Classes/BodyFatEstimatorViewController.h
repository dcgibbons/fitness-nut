//
//  BodyFatEstimatorViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/26/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BodyFatEstimatorViewController : UITableViewController 
{
    NSMutableDictionary *userData;
    
@private
    NSArray *sections;
}

@property (nonatomic, retain) NSMutableDictionary *userData;
@property (nonatomic, retain) NSArray *sections;

- (NSString *)calculatePredictedBodyFat;

@end
