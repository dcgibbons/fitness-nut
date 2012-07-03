//
//  WeightPickerViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AthleteDataDelegate.h"
#import "AthleteDataProtocol.h"
#import "SecondaryDetailViewController.h"


@class AthleteWeight;

@interface WeightPickerViewController : SecondaryDetailViewController <UIPickerViewDataSource, 
                                                                       UIPickerViewDelegate,
                                                                       AthleteDataProtocol> 
{
    NSString *dataName;
    AthleteWeight *data;
    id<AthleteDataDelegate> delegate;
    
@private
    UIPickerView *pickerView;
    UISegmentedControl *unitsControl;
}

@property (nonatomic, retain) NSString *dataName;
@property (nonatomic, retain) AthleteWeight *data;
@property (nonatomic, assign) id<AthleteDataDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *unitsControl;

- (IBAction)changeUnits:(id)sender;

@end
