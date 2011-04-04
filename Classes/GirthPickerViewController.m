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
@synthesize pickerView, unitsControl, infoButton;

#pragma mark -
#pragma mark View Lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];

    // Only iOS 3.2.x or iOS 4.2.x and newer supports popovers
    if (NSClassFromString(@"UIPopoverController")) {
        self.contentSizeForViewInPopover = CGSizeMake(320, 300);
    }
    
    self.title = @"Girth";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

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

// Use frame of containing view to work out the correct origin and size
// of the UIDatePicker.
- (void)layoutView:(UIInterfaceOrientation)orientation 
{
    if (IS_PAD_DEVICE()) {
        self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.pickerView.frame = CGRectMake(0, 0, 320, 216);
        self.unitsControl.frame = CGRectMake(56, 224, 207, 44);
        self.infoButton.frame = CGRectMake(282, 224+44+8, 18, 19);
    } else {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            self.unitsControl.frame = CGRectMake(253, 86, 207, 44);
            self.pickerView.frame = CGRectMake(0, 0, 245, 216);
            self.infoButton.frame = CGRectMake(442, 217, 18, 19);
        } else {
            self.unitsControl.frame = CGRectMake(56, 353, 207, 44);
            self.pickerView.frame = CGRectMake(0, 0, 320, 216);
            self.infoButton.frame = CGRectMake(282, 377, 18, 19);
        }
    }
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
}

- (void)dealloc 
{
    [dataName release];
    [data release];
    [pickerView release];
    [unitsControl release];
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

- (IBAction)done:(id)sender
{
    [super done:sender];
    
    int row = [self.pickerView selectedRowInComponent:0];
    NSNumber *m = [NSNumber numberWithInt:row];

    MeasurementUnits units = [self isInches] ? MeasurementInches : MeasurementCentimeters;
    self.data = [[[AthleteMeasurement alloc] initWithMeasurement:m usingUnits:units] autorelease];
    
    [delegate athleteDataInputDone:self withDataNamed:dataName withDataValue:data];
}

- (IBAction)info:(id)sender
{
    NSString *nibName = [NSString stringWithFormat:@"%@_ViewController", self.dataName];
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
    
    [self.pickerView reloadAllComponents];
    [self selectRowsFromMeasurement:newMeasurement];
}

#pragma mark -
#pragma mark InfoViewControllerDelegate methods

- (void)infoViewControllerDidFinish:(InfoViewController *)controller 
{
	[self dismissModalViewControllerAnimated:YES];
}


@end
