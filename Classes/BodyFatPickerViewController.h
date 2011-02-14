//
//  BodyFatPickerViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/24/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AthleteDataDelegate.h"
#import "AthleteBodyFat.h"
#import "AthleteDataProtocol.h"

@interface BodyFatPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate,
                                                            AthleteDataProtocol>
{
    NSString *dataName;
    AthleteBodyFat *data;
    id<AthleteDataDelegate> delegate;
    
@private
    UIPickerView *pickerView;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *doneButton;
}

@property (nonatomic, retain) NSString *dataName;
@property (nonatomic, retain) AthleteBodyFat *data;
@property (nonatomic, assign) id<AthleteDataDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
