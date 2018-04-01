//
//  HoursPickerViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/20/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AthleteDataDelegate.h"
#import "AthleteDataProtocol.h"
#import "SecondaryDetailViewController.h"


@interface HoursPickerViewController : SecondaryDetailViewController <UIPickerViewDataSource, 
                                                                      UIPickerViewDelegate,
                                                                      AthleteDataProtocol>
{
    NSString *dataName;
    NSNumber *data;
    id<AthleteDataDelegate> delegate;
    
@private
    UIPickerView *pickerView;
}

@property (nonatomic, retain) NSString *dataName;
@property (nonatomic, retain) NSNumber *data;
@property (nonatomic, assign) id<AthleteDataDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;

@end
