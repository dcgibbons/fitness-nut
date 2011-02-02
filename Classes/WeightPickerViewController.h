//
//  WeightPickerViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AthleteDataDelegate.h"

@class AthleteWeight;

@interface WeightPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> 
{
    NSString *dataName;
    AthleteWeight *data;
    id<AthleteDataDelegate> delegate;
    
@private
    UIPickerView *pickerView;
    UISegmentedControl *unitsControl;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *doneButton;
}

@property (nonatomic, retain) NSString *dataName;
@property (nonatomic, retain) AthleteWeight *data;
@property (nonatomic, assign) id<AthleteDataDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *unitsControl;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)changeUnits:(id)sender;

@end
