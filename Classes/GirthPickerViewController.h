//
//  GirthPickerViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/26/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AthleteDataDelegate.h"
#import "AthleteMeasurement.h"

@interface GirthPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSString *dataName;
    AthleteMeasurement *data;
    id<AthleteDataDelegate> delegate;
    
@private
    UIPickerView *pickerView;
    UISegmentedControl *unitsControl;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *doneButton;
}

@property (nonatomic, retain) NSString *dataName;
@property (nonatomic, retain) AthleteMeasurement *data;
@property (nonatomic, assign) id<AthleteDataDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *unitsControl;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
