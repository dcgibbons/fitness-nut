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
#import "AthleteDataProtocol.h"
#import "SecondaryDetailViewController.h"


@interface AgePickerViewController : SecondaryDetailViewController <UIPickerViewDataSource, 
                                                                    UIPickerViewDelegate, 
                                                                    AthleteDataProtocol> 
{
    NSString *dataName;
    AthleteAge *data;
    id<AthleteDataDelegate> delegate;

@private
    UIPickerView *pickerView;
}

@property (nonatomic, retain) NSString *dataName;
@property (nonatomic, retain) AthleteAge *data;
@property (nonatomic, assign) id<AthleteDataDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;

@end
