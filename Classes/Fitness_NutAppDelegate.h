//
//  Fitness_NutAppDelegate.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/01/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface Fitness_NutAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
	UINavigationController *navController;
    RootViewController *topLevelController;
    NSMutableDictionary *userData;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain, readonly) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet RootViewController *topLevelController;
@property (nonatomic, retain) NSMutableDictionary *userData;

@end

