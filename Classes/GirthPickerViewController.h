//
//  GirthPickerViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/26/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AthleteDataDelegate.h"
#import "AthleteMeasurement.h"
#import "InfoViewController.h"
#import "AthleteDataProtocol.h"
#import "SecondaryDetailViewController.h"

@interface GirthPickerViewController : SecondaryDetailViewController <UIPickerViewDataSource, 
                                                                      UIPickerViewDelegate,
                                                                      InfoViewControllerDelegate, 
                                                                      AthleteDataProtocol>
{
    NSString *dataName;
    AthleteMeasurement *data;
    id<AthleteDataDelegate> delegate;
    
@private
    UIPickerView *pickerView;
    UISegmentedControl *unitsControl;
    UIButton *infoButton;
}

@property (nonatomic, retain) NSString *dataName;
@property (nonatomic, retain) AthleteMeasurement *data;
@property (nonatomic, assign) id<AthleteDataDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *unitsControl;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;

- (IBAction)info:(id)sender;

@end
