//
//  BodyFatPickerViewController.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/24/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import "BodyFatPickerViewController.h"


@implementation BodyFatPickerViewController

@synthesize dataName, data, delegate, pickerView;


#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    // Only iOS 3.2.x or iOS 4.2.x and newer supports popovers
    if (NSClassFromString(@"UIPopoverController")) {
        self.contentSizeForViewInPopover = CGSizeMake(320, 240);
    }
    
    self.title = @"Athlete Body Fat";
    
    // pick the selected row based upon a default or the user's existing value
    double bodyFat = 18;
    if (self.data) {
        bodyFat = [self.data.bodyFat doubleValue];
    }
    [self.pickerView selectRow:(int)bodyFat - 4 inComponent:0 animated:NO];
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
}

- (void)dealloc 
{
    [dataName release];
    [data release];
    [pickerView release];
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
    }
    return title;
}

#pragma mark -
#pragma mark UI Actions

- (IBAction)done:(id)sender
{
    [super done:sender];
    
    double bodyFat = [self.pickerView selectedRowInComponent:0] + 4;
    
    self.data = [[[AthleteBodyFat alloc] initWithBodyFat:[NSNumber numberWithDouble:bodyFat]] autorelease];
    [delegate athleteDataInputDone:self withDataNamed:self.dataName withDataValue:data];
}

@end
