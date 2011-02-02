//
//  AgePickerViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AthleteAge.h"
#import "AthleteDataDelegate.h"

@interface AgePickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> 
{
    NSString *dataName;
    AthleteAge *data;
    id<AthleteDataDelegate> delegate;

@private
    UIPickerView *pickerView;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *doneButton;
    
}

@property (nonatomic, retain) NSString *dataName;
@property (nonatomic, retain) AthleteAge *data;
@property (nonatomic, assign) id<AthleteDataDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
