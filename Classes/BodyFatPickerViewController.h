//
//  BodyFatPickerViewController.h
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/24/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AthleteDataDelegate.h"
#import "AthleteBodyFat.h"
#import "AthleteDataProtocol.h"
#import "SecondaryDetailViewController.h"


@interface BodyFatPickerViewController : SecondaryDetailViewController <UIPickerViewDataSource, 
                                                                        UIPickerViewDelegate,
                                                                        AthleteDataProtocol>
{
    NSString *dataName;
    AthleteBodyFat *data;
    id<AthleteDataDelegate> delegate;
    
@private
    UIPickerView *pickerView;
}

@property (nonatomic, retain) NSString *dataName;
@property (nonatomic, retain) AthleteBodyFat *data;
@property (nonatomic, assign) id<AthleteDataDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;

@end
