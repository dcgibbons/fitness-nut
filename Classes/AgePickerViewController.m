//
//  AgePickerViewController.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "AgePickerViewController.h"

@implementation AgePickerViewController

#define AGE_DEFAULT     (30)
#define AGE_OFFSET      (10)
#define AGE_MAX         (100)

#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    self.title = @"Athlete Age";

    // pick the selected row based upon a default or the user's existing value
    int age = AGE_DEFAULT;
    if (self.data) {
        age = self.data.age;
    }
    [self.pickerView selectRow:(age - AGE_OFFSET) inComponent:0 animated:NO];
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

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    self.dataName = nil;
    self.data = nil;
    self.pickerView = nil;
    self.cancelButton = nil;
    self.doneButton = nil;
}

- (void)dealloc {
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
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
    return AGE_MAX - AGE_OFFSET;
}

#pragma mark -
#pragma mark Picker View Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView 
             titleForRow:(NSInteger)row 
            forComponent:(NSInteger)component 
{
    return [NSString stringWithFormat:@"%u years", row + AGE_OFFSET];
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
    
    int row = [self.pickerView selectedRowInComponent:0];
    NSUInteger age = row + AGE_OFFSET;

    if (data) {
        data.age = age;
    } else {
        data = [[AthleteAge alloc] initWithAge:age];
    }

    [delegate athleteDataInputDone:self withDataNamed:dataName withDataValue:data];
}

@end
