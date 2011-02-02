//
//  RootViewController.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/01/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController :  UIViewController <UITableViewDataSource, UITableViewDelegate> 
{
@private
    NSMutableDictionary *userData;
    NSArray *groups;
    UITableView *menuTableView;
}

@property (nonatomic, retain) NSMutableDictionary *userData;
@property (nonatomic, retain) NSArray *groups;
@property (nonatomic, retain) IBOutlet UITableView *menuTableView;

@end
