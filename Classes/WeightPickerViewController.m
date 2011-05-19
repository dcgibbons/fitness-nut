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

@synthesize dataName, data, delegate, pickerView, unitsControl;

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

- (void)selectRowsFromWeight:(AthleteWeight *)weight animated:(BOOL)animated
{
    NSInteger row = 0;
    
    if (weight.units == Pounds) {
        row = [weight.weight intValue] - 90;
    } else {
        row = [weight.weight intValue] - 40;
    }

    [self.pickerView selectRow:row inComponent:0 animated:animated];
}

#pragma mark -
#pragma mark View Lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];

    // TODO: document the magic numbers before you forget, fool!
    // Only iOS 3.2.x or iOS 4.2.x and newer supports popovers
    if (NSClassFromString(@"UIPopoverController")) {
        self.contentSizeForViewInPopover = CGSizeMake(320, 224 + 44 + 19);
    }
    
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
                                                            
                                autorelease] animated:NO];

    [self.unitsControl addTarget:self 
                          action:@selector(changeUnits:)
                forControlEvents:UIControlEventValueChanged];
}

- (void)layoutView:(UIInterfaceOrientation)orientation
{
    if (IS_PAD_DEVICE()) {
        self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.pickerView.frame = CGRectMake(0, 0, 320, 216);
        self.unitsControl.frame = CGRectMake(56, 224, 207, 44);
    } else {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            self.unitsControl.frame = CGRectMake(253, 86, 207, 44);
            self.pickerView.frame = CGRectMake(0, 0, 245, 216);
        } else {
            self.unitsControl.frame = CGRectMake(56, 353, 207, 44);
            self.pickerView.frame = CGRectMake(0, 0, 320, 216);
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

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
#pragma mark Picker View DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rows = 0;

    switch (self.unitsControl.selectedSegmentIndex) {
        case 0: // lb.
            rows = 400 - 90; // 90 through 400 lb.
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
        case 0: // lb.
            title = [NSString stringWithFormat:@"%u", row + 90];
            break;
        case 1: // kgs
            title = [NSString stringWithFormat:@"%u", row + 40];
            break;
    }

    return title;
}

#pragma mark -
#pragma mark UI Actions

- (IBAction)done:(id)sender
{
    [super done:sender];
    
    switch (self.unitsControl.selectedSegmentIndex) {
        case 0: { // lb.
            int pounds = [self.pickerView selectedRowInComponent:0] + 90;
            NSNumber *aWeight = [NSNumber numberWithInt:pounds];
            self.data = [[[AthleteWeight alloc] initWithWeight:aWeight 
                                                    usingUnits:Pounds] autorelease];
            break;
        }
        case 1: { // kgs
            int kg = [self.pickerView selectedRowInComponent:0] + 40;
            NSNumber *aWeight = [NSNumber numberWithFloat:kg];
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
    
    // Change the selected row using the new units
    AthleteWeight *newWeight;
    if (athleteWeight.units == Pounds) {
        newWeight = [[[AthleteWeight alloc] initWithWeight:[athleteWeight weightAsKilograms]
                                                usingUnits:Kilograms] autorelease];
    } else {
        newWeight = [[[AthleteWeight alloc] initWithWeight:[athleteWeight weightAsPounds] 
                                                usingUnits:Pounds] autorelease];
    }

    [self.pickerView reloadAllComponents];
    [self selectRowsFromWeight:newWeight animated:YES];
}

@end
