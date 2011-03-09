//
//  UpgradeBannerView.h
//  Fitness Nut
//
//  Created by Chad Gibbons on 03/09/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>


// A custom UIView that displays an advertisement banner to upgrade to the Pro version of the
// application. This would probably be easier to accomplish with 2 different pre-generated images,
// but doing it programatically is fun and might be easier for me to code up rather than try and
// figure out how to draw again.
@interface UpgradeBannerView : UIView 
{
@private
    UILabel *label;
}

@property (nonatomic, retain) UILabel *label;

@end
