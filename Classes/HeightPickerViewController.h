//
//  HeightPickerViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AthleteDataDelegate.h"
#import "AthleteDataProtocol.h"
#import "SecondaryDetailViewController.h"

@class AthleteHeight;

@interface HeightPickerViewController : SecondaryDetailViewController <UIPickerViewDataSource, 
                                                            UIPickerViewDelegate, 
                                                            AthleteDataProtocol> 
{
    NSString *dataName;
    AthleteHeight *data;
    id<AthleteDataDelegate> delegate;
    
@private
    UIPickerView *pickerView;
    UISegmentedControl *unitsControl;
}

@property (nonatomic, retain) NSString *dataName;
@property (nonatomic, retain) AthleteHeight *data;
@property (nonatomic, assign) id<AthleteDataDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *unitsControl;

- (IBAction)changeUnits:(id)sender;
- (void)layoutPicker:(UIInterfaceOrientation)orientation;

@end
