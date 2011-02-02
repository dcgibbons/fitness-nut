//
//  WeightPickerViewController.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "WeightPickerViewController.h"
#import "AthleteWeight.h"

@implementation WeightPickerViewController

- (BOOL) isPounds
{
    return (self.unitsControl.selectedSegmentIndex == 0);
}

- (AthleteWeight *)getWeightUsingUnits:(WeightUnits)units
{
    AthleteWeight *athleteWeight = nil;
    
    if (units == Pounds) {
        int lbs = [self.pickerView selectedRowInComponent:0] + 90;
        NSNumber *aWeight = [NSNumber numberWithInt:lbs];
        athleteWeight = [[[AthleteWeight alloc] initWithWeight:aWeight usingUnits:Pounds] 
                         autorelease];
    } else {
        int cm = [self.pickerView selectedRowInComponent:0] + 40;
        NSNumber *aWeight = [NSNumber numberWithFloat:cm];
        athleteWeight = [[[AthleteWeight alloc] initWithWeight:aWeight usingUnits:Kilograms]
                         autorelease];
    }
    
    return athleteWeight;
}

- (void)selectRowsFromWeight:(AthleteWeight *)weight
{
    if (weight.units == Pounds) {
        [self.pickerView selectRow:[weight.weight intValue] - 90 inComponent:0 animated:YES];
    } else {
        [self.pickerView selectRow:[weight.weight intValue] - 40 inComponent:0 animated:YES];
    }
}

#pragma mark -
#pragma mark View Lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    self.title = @"Athlete Weight";
    
    WeightUnits units = Pounds;
    int weight = 150;
    if (self.data) {
        weight = [self.data.weight intValue];
        units = self.data.units;
    }
    self.unitsControl.selectedSegmentIndex = (units == Pounds) ? 0 : 1;
    [self selectRowsFromWeight:[[[AthleteWeight alloc] initWithWeight:[NSNumber numberWithInt:weight]
                                                           usingUnits:units]
                                autorelease]];

    [self.unitsControl addTarget:self 
                          action:@selector(changeUnits:)
                forControlEvents:UIControlEventValueChanged];
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
    self.unitsControl = nil;
    self.unitsControl = nil;
    self.cancelButton = nil;
    self.doneButton = nil;
}

- (void)dealloc 
{
    [dataName release];
    [data release];
    [pickerView release];
    [unitsControl release];
    [cancelButton release];
    [doneButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark Picker View DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rows = 0;

    switch (self.unitsControl.selectedSegmentIndex) {
        case 0: // lbs
            rows = 400 - 90; // 90 through 400 lbs
            break;
        case 1: // kgs
            rows = 181 - 40; // 40 through 181 kg
            break;
    }

    return rows;
}

#pragma mark -
#pragma mark Picker View Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView 
             titleForRow:(NSInteger)row 
            forComponent:(NSInteger)component
{
    NSString *title;

    switch (self.unitsControl.selectedSegmentIndex) {
        case 0: // lbs
            title = [NSString stringWithFormat:@"%u", row + 90];
            break;
        case 1: // kgs
            title = [NSString stringWithFormat:@"%u", row + 40];
            break;
    }

    return title;
}

#pragma mark -
#pragma mark Properties

@synthesize dataName, data, delegate;
@synthesize pickerView, unitsControl, cancelButton, doneButton;

#pragma mark -
#pragma mark UI Actions

- (IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    switch (self.unitsControl.selectedSegmentIndex) {
        case 0: { // lbs
            int pounds = [self.pickerView selectedRowInComponent:0] + 90;
            NSNumber *aWeight = [NSNumber numberWithInt:pounds];
            NSLog(@"weight (lbs)=%d\n", [aWeight intValue]);
            self.data = [[[AthleteWeight alloc] initWithWeight:aWeight 
                                                    usingUnits:Pounds] autorelease];
            break;
        }
        case 1: { // kgs
            int kg = [self.pickerView selectedRowInComponent:0] + 40;
            NSNumber *aWeight = [NSNumber numberWithFloat:kg];
            NSLog(@"weight (kgs)=%f\n", [aWeight doubleValue]);
            self.data = [[[AthleteWeight alloc] initWithWeight:aWeight
                                                    usingUnits:Kilograms] autorelease];
            break;
        }
    }

    [delegate athleteDataInputDone:self withDataNamed:dataName withDataValue:self.data];
}

- (IBAction)changeUnits:(id)sender
{
    BOOL isPounds = ![self isPounds];
    
    // Get the weight using the previous units
    AthleteWeight *athleteWeight = [self getWeightUsingUnits:isPounds ? Pounds : Kilograms];
    NSLog(@"previousWeight=%@\n", athleteWeight);
    
    // Change the selected row using the new units
    AthleteWeight *newWeight;
    if (athleteWeight.units == Pounds) {
        newWeight = [[[AthleteWeight alloc] initWithWeight:[athleteWeight weightAsKilograms]
                                                usingUnits:Kilograms] autorelease];
    } else {
        newWeight = [[[AthleteWeight alloc] initWithWeight:[athleteWeight weightAsPounds] 
                                                usingUnits:Pounds] autorelease];
    }
    NSLog(@"newAthleteWeight=%@\n", newWeight);

    [self.pickerView reloadAllComponents];
    [self selectRowsFromWeight:newWeight];
}

@end
