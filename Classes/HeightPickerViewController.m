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

    // TODO: document the magic numbers before you forget, fool!
    // Only iOS 3.2.x or iOS 4.2.x and newer supports popovers
    if (NSClassFromString(@"UIPopoverController")) {
        self.contentSizeForViewInPopover = CGSizeMake(320, 224 + 44 + 19);
    }
    
    self.title = @"Athlete Height";
    self.navigationItem.title = @"Athlete Height";
    
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

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    // Layout once here to ensure the current orientation is respected.
    [self layoutPicker:[UIApplication sharedApplication].statusBarOrientation];

    if (IS_PAD_DEVICE()) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations.
    return YES;
}

// Use frame of containing view to work out the correct origin and size
// of the UIDatePicker.
- (void)layoutPicker:(UIInterfaceOrientation)orientation 
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

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                         duration:(NSTimeInterval)duration 
{
    [super willAnimateRotationToInterfaceOrientation:orientation duration:duration];
    [self layoutPicker:orientation];
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
#pragma mark Properties

@synthesize data, dataName, delegate;
@synthesize pickerView, unitsControl;

#pragma mark -
#pragma mark UI Actions

- (IBAction)done:(id)sender
{
    [super done:sender];

    AthleteHeight *athleteHeight = [self getHeightUsingUnits:[self isInches] ? Inches : Centimeters];
    self.data = athleteHeight;
    
    [delegate athleteDataInputDone:self withDataNamed:dataName withDataValue:self.data];
}

- (IBAction)changeUnits:(id)sender
{
    BOOL isInches = ![self isInches];
    
    // Get the height using the previous units
    AthleteHeight *athleteHeight = [self getHeightUsingUnits:isInches ? Inches: Centimeters];
    
    // Now change the selected rows using the new units
    AthleteHeight *newAthleteHeight;
    if (athleteHeight.units == Inches) {
        newAthleteHeight = [[[AthleteHeight alloc] initWithHeight:[athleteHeight heightAsCentimeters]
                                                                   usingUnits:Centimeters] autorelease];
    } else {
        newAthleteHeight = [[[AthleteHeight alloc] initWithHeight:[athleteHeight heightAsInches]
                                                                   usingUnits:Inches] autorelease];
    }
    
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
