//
//  BodyFatPickerViewController.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/24/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "BodyFatPickerViewController.h"


@implementation BodyFatPickerViewController

#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    self.title = @"Athlete Body Fat";
    
    // pick the selected row based upon a default or the user's existing value
    double bodyFat = 18.5;
    if (self.data) {
        bodyFat = [self.data doubleValue];
    }
    double intPart;
    double fracPart = modf(bodyFat, &intPart);
    [self.pickerView selectRow:(int)intPart - 4 inComponent:0 animated:NO];
    [self.pickerView selectRow:(int)(fracPart * 10.0) inComponent:1 animated:NO];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.dataName = nil;
    self.data = nil;
    self.pickerView = nil;
    self.cancelButton = nil;
    self.doneButton = nil;
}

- (void)dealloc 
{
    [dataName release];
    [data release];
    [pickerView release];
    [cancelButton release];
    [doneButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark Properties

@synthesize dataName, data, delegate;
@synthesize pickerView, cancelButton, doneButton;

#pragma mark -
#pragma mark Picker View Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView 
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
    return 40 - 4;
}

#pragma mark -
#pragma mark Picker View Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView 
             titleForRow:(NSInteger)row 
            forComponent:(NSInteger)component 
{
    NSString *title;
    if (component == 0) {
        title = [NSString stringWithFormat:@"%d", row + 4];
    } else {
        title = [NSString stringWithFormat:@"%d", row];
    }
    return title;
}

#pragma mark -
#pragma mark UI Actions

- (IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    double bodyFat = [self.pickerView selectedRowInComponent:0] + 4;
    double frac = [self.pickerView selectedRowInComponent:1] / 10.0;
    bodyFat += frac;
    
    self.data = [NSNumber numberWithDouble:bodyFat];
    [delegate athleteDataInputDone:self withDataNamed:self.dataName withDataValue:data];
}

@end
