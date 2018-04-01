//
//  Fitness_NutAppDelegate.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/01/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentController.h"

@interface Fitness_NutAppDelegate : NSObject <UIApplicationDelegate> 
{
    NSMutableDictionary *userData;
    UIWindow *window;
    ContentController *contentController;
}

@property (nonatomic, readonly) BOOL isPadDevice;
@property (nonatomic, retain) NSMutableDictionary *userData;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ContentController *contentController;

@end

