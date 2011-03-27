//
//  BMRGraphViewController.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 03/13/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BMRGraphViewController : UIViewController
{
    NSMutableDictionary *userData;
    CPXYGraph *graph;    
}

@property (nonatomic, retain) NSMutableDictionary *userData;
@property (nonatomic, retain) CPXYGraph *graph;

@end
