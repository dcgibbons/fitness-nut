//
//  ContentController.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/28/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RootViewController;
@class DetailViewController;

@interface ContentController : NSObject 
{
    NSMutableDictionary *userData;
    RootViewController *masterViewController;
    DetailViewController *detailViewController;
}

@property (nonatomic, retain) NSMutableDictionary *userData;
@property (nonatomic,retain) IBOutlet RootViewController *masterViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

- (UIView *)view;

@end
