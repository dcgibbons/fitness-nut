//
//  HoursPickerViewController.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/20/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import "HoursPickerViewController.h"


@implementation HoursPickerViewController

@synthesize data, dataName, delegate, pickerView;

#pragma mark -
#pragma mark View Lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];

    // Only iOS 3.2.x or iOS 4.2.x and newer supports popovers
    if (NSClassFromString(@"UIPopoverController")) {
        self.contentSizeForViewInPopover = CGSizeMake(320, 240);
    }
    
    self.title = @"Training Hours";
    
    NSUInteger hours = 6;
    if (data) {
        hours = [data intValue];
    }
    [self.pickerView selectRow:hours - 4 inComponent:0 animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    // TODO: this had the pickerView select code in
//    
//    [super viewDidAppear:animated];
//    
//    NSLog(@"HoursPickerViewControler::viewDidAppear: picker.frame.size=%f,%f", 
//          self.pickerView.frame.size.height,
//          self.pickerView.frame.size.width);
//}
//
//- (void)layoutView:(UIInterfaceOrientation)orientation
//{
//    if (IS_PAD_DEVICE()) {
//        self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        self.pickerView.frame = CGRectMake(0, 0, 320, 216);
//    } else {
//        self.pickerView.autoresizingMask = UIViewAutoresizingNone;
//        
//        if (UIInterfaceOrientationIsLandscape(orientation)) {
//            self.pickerView.frame = CGRectMake(0, 0, 245, 216);
//        } else {
//            self.pickerView.frame = CGRectMake(0, 0, 320, 216);
//        }
//    }    
//    
//    NSLog(@"HoursPickerViewControler::layoutView: picker.frame.size=%f,%f", 
//          self.pickerView.frame.size.height,
//          self.pickerView.frame.size.width);
//    
//}

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
}

- (void)dealloc 
{
    [pickerView release];
    [dataName release];
    [data release];
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
    return 24 - 4;
}

#pragma mark -
#pragma mark Picker View Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView 
             titleForRow:(NSInteger)row 
            forComponent:(NSInteger)component 
{
    return [NSString stringWithFormat:@"%u hours", row + 4];
}

#pragma mark -
#pragma mark UI Actions

- (IBAction)done:(id)sender
{
    [super done:sender];

    int row = [self.pickerView selectedRowInComponent:0];
    NSUInteger hours = row + 4;

    self.data = [NSNumber numberWithUnsignedInteger:hours];
    [delegate athleteDataInputDone:self withDataNamed:dataName withDataValue:data];
}

@end
