//
//  BMRGraphViewController.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 03/13/2011.
//  Copyright 2011-2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface BMRGraphViewController : UIViewController
{
    NSMutableDictionary *userData;
    CPTGraph *graph;    
}

@property (nonatomic, retain) NSMutableDictionary *userData;
@property (nonatomic, retain) CPTGraph *graph;

@end
