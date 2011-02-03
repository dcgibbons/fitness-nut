//
//  GirthPickerViewController.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/26/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "GirthPickerViewController.h"
#import "InfoViewController.h"

@implementation GirthPickerViewController

- (BOOL) isInches
{
    return (self.unitsControl.selectedSegmentIndex == 0);
}

- (AthleteMeasurement *)getMeasurementUsingUnits:(MeasurementUnits)units
{
    int row = [self.pickerView selectedRowInComponent:0];
    NSNumber *m = [NSNumber numberWithInt:row];
    AthleteMeasurement *measurement = [[[AthleteMeasurement alloc] initWithMeasurement:m 
                                                                            usingUnits:units] 
                                       autorelease];
    return measurement;
}

- (void)selectRowsFromMeasurement:(AthleteMeasurement *)measurement
{
    int inches = [measurement.measurement intValue];
    [self.pickerView selectRow:inches inComponent:0 animated:YES];
}

#pragma mark -
#pragma mark Properties

@synthesize data, dataName, delegate;
@synthesize pickerView, unitsControl, cancelButton, doneButton, infoButton;

#pragma mark -
#pragma mark View Lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    self.title = @"Girth";
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)viewDidAppear:(BOOL)animated
{
    NSInteger m = [self isInches] ? 30 : 75;
    MeasurementUnits units = MeasurementInches;
    if (data) {
        m = [data.measurement intValue];
        units = data.units;
    }
    self.unitsControl.selectedSegmentIndex = (units == MeasurementInches) ? 0 : 1;
    [self.pickerView selectRow:m inComponent:0 animated:NO];
    
    [self.unitsControl addTarget:self 
                          action:@selector(changeUnits:)
                forControlEvents:UIControlEventValueChanged];
    
}

#pragma mark -
#pragma mark Memory Management

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
    // e.g. self.myOutlet = nil;
    
    self.data = nil;
    self.dataName = nil;
    self.pickerView = nil;
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
#pragma mark Picker View Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView 
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
    int rows;
    if ([self isInches]) {
        return 50;
    } else {
        return 127;
    }
    return rows;
}

#pragma mark -
#pragma mark Picker View Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView 
             titleForRow:(NSInteger)row 
            forComponent:(NSInteger)component 
{
    NSString *suffix = [self isInches] ? @"\"" : @" cm";
    return [NSString stringWithFormat:@"%u%@", row, suffix];
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
    NSNumber *m = [NSNumber numberWithInt:row];

    MeasurementUnits units = [self isInches] ? MeasurementInches : MeasurementCentimeters;
    self.data = [[[AthleteMeasurement alloc] initWithMeasurement:m usingUnits:units] autorelease];
    
    [delegate athleteDataInputDone:self withDataNamed:dataName withDataValue:data];
}

- (IBAction)info:(id)sender
{
    NSString *nibName = [NSString stringWithFormat:@"%@_ViewController", self.dataName];
    NSLog(@"Looking for InfoViewController with nibName of %@", nibName);
    InfoViewController *controller = [[InfoViewController alloc] initWithNibName:nibName
                                                                          bundle:nil];
    controller.delegate = self;
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];

	[controller release];
}

- (IBAction)changeUnits:(id)sender
{
    BOOL isInches = ![self isInches];
    
    // Get the height using the previous units
    AthleteMeasurement *measurement = [self getMeasurementUsingUnits:isInches ? MeasurementInches: MeasurementCentimeters];
    NSLog(@"previousmeasurement=%@\n", measurement);
    
    // Now change the selected rows using the new units
    AthleteMeasurement *newMeasurement;
    if (measurement.units == MeasurementInches) {
        newMeasurement = [[[AthleteMeasurement alloc] initWithMeasurement:[measurement measurementAsCentimeters]
                                                               usingUnits:MeasurementCentimeters] 
                          autorelease];
    } else {
        newMeasurement = [[[AthleteMeasurement alloc] initWithMeasurement:[measurement measurementAsInches]
                                                               usingUnits:MeasurementInches] 
                          autorelease];
    }
    NSLog(@"newAthleteMeasurement=%@", newMeasurement);
    
    [self.pickerView reloadAllComponents];
    [self selectRowsFromMeasurement:newMeasurement];
}

#pragma mark -
#pragma mark InfoViewControllerDelegate methods

- (void)infoViewControllerDidFinish:(InfoViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


@end
