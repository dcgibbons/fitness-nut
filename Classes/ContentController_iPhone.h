//
//  ContentController_iPhone.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/28/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentController.h"

@interface ContentController_iPhone : ContentController 
{
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

- (UIView *)view;

@end
