//
//  HeightPickerViewController.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "HeightPickerViewController.h"
#import "AthleteHeight.h"

@implementation HeightPickerViewController

- (BOOL) isInches
{
    return (self.unitsControl.selectedSegmentIndex == 0);
}

- (AthleteHeight *)getHeightUsingUnits:(HeightUnits)units
{
    AthleteHeight *athleteHeight = nil;
    
    if (units == Inches) {
        int feet = [self.pickerView selectedRowInComponent:0] + 4;
        int inches = [self.pickerView selectedRowInComponent:1];
        NSNumber *aHeight = [NSNumber numberWithInt:inches + (feet * 12)];
        athleteHeight = [[[AthleteHeight alloc] initWithHeight:aHeight usingUnits:Inches] 
                         autorelease];
    } else {
        int cm = [self.pickerView selectedRowInComponent:0] + 120;
        NSNumber *aHeight = [NSNumber numberWithFloat:(double)cm];
        athleteHeight = [[[AthleteHeight alloc] initWithHeight:aHeight usingUnits:Centimeters]
                         autorelease];
    }
    
    return athleteHeight;
}

- (void)selectRowsFromHeight:(AthleteHeight *)height
{
    if (height.units == Inches) {
        int feet = [height.height intValue] / 12;
        int inches = [height.height intValue] % 12;
        [self.pickerView selectRow:feet - 4 inComponent:0 animated:YES];
        [self.pickerView selectRow:inches inComponent:1 animated:YES];
    } else {
        int row0 = (int)[height.height doubleValue] - 120;
        [self.pickerView selectRow:row0 inComponent:0 animated:YES];
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
    
    self.title = @"Athlete Height";
    
    int height = [self isInches] ? 66 : 168; // 5'6" or 168cm
    HeightUnits units = Inches;
    if (self.data) {
        height = [self.data.height intValue];
        units = self.data.units;
    }
    self.unitsControl.selectedSegmentIndex = (units == Inches) ? 0 : 1;
    [self selectRowsFromHeight:[[[AthleteHeight alloc] initWithHeight:[NSNumber numberWithInt:height]
                                                           usingUnits:[self isInches] ? Inches : Centimeters]
                                autorelease]];

    [self.unitsControl addTarget:self 
                          action:@selector(changeUnits:)
                forControlEvents:UIControlEventValueChanged];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations.
    return YES;
}
*/

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
    
    self.dataName = nil;
    self.data = nil;
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
#pragma mark Properties

@synthesize data, dataName, delegate;
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

    AthleteHeight *athleteHeight = [self getHeightUsingUnits:[self isInches] ? Inches : Centimeters];
    self.data = athleteHeight;
    
    [delegate athleteDataInputDone:self withDataNamed:dataName withDataValue:self.data];
}

- (IBAction)changeUnits:(id)sender
{
    BOOL isInches = ![self isInches];
    
    // Get the height using the previous units
    AthleteHeight *athleteHeight = [self getHeightUsingUnits:isInches ? Inches: Centimeters];
    NSLog(@"previousHeight=%@\n", athleteHeight);
    
    // Now change the selected rows using the new units
    AthleteHeight *newAthleteHeight;
    if (athleteHeight.units == Inches) {
        newAthleteHeight = [[[AthleteHeight alloc] initWithHeight:[athleteHeight heightAsCentimeters]
                                                                   usingUnits:Centimeters] autorelease];
    } else {
        newAthleteHeight = [[[AthleteHeight alloc] initWithHeight:[athleteHeight heightAsInches]
                                                                   usingUnits:Inches] autorelease];
    }
    NSLog(@"newAthleteHeight=%@", newAthleteHeight);
    
    [self.pickerView reloadAllComponents];
    [self selectRowsFromHeight:newAthleteHeight];
}

#pragma mark -
#pragma mark Picker View Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView 
{
    NSInteger components = 1;

    if ([self isInches]) {
        components = 2;
    }

    return components;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
    int rows = 0;

    if ([self isInches]) {
        rows = (component == 0) ? 4 : 12; // allow for 4' through 7' and 12" 
    } else {
        rows = 120; // allow for 120cm to 240cm
    }

    return rows;
}

#pragma mark -
#pragma mark Picker View Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView 
             titleForRow:(NSInteger)row 
            forComponent:(NSInteger)component 
{
    NSString *title = nil;

    if ([self isInches]) {
        if (component == 0) {
            title = [NSString stringWithFormat:@"%u'", row + 4];
        } else {
            title = [NSString stringWithFormat:@"%u\"", row];
        }
    } else {
        title = [NSString stringWithFormat:@"%u", row + 120];
    }
    
    return title;
}

@end
