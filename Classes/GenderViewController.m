//
//  GenderViewController.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "GenderViewController.h"
#import "AthleteGender.h"

@implementation GenderViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    self.title = @"Athlete Gender";    
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
    return 2;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    switch ([indexPath row]) {
        case 0:
            cell.textLabel.text = @"Male";
            if (!data || data.gender == Male) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        case 1:
            cell.textLabel.text = @"Female";
            if (data.gender == Female) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
    }
    
    return cell;
}

- (void)updateGender
{
    if (!self.data) {
        self.data = [[[AthleteGender alloc] init] autorelease];
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    switch ([indexPath row]) {
        case 0:
            self.data.gender = Male;
            break;
        case 1:
            self.data.gender = Female;
            break;
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [self updateGender];
    [tableView reloadData];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    self.dataName = nil;
    self.data = nil;
    self.cancelButton = nil;
    self.doneButton = nil;
}

- (void)dealloc 
{
    [dataName release];
    [data release];
    [cancelButton release];
    [doneButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark Properties

@synthesize dataName, data, delegate;
@synthesize cancelButton, doneButton;

#pragma mark -
#pragma mark UI Actions

- (IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

    if (!self.data) {
        [self updateGender];
    }

    [delegate athleteDataInputDone:self
                     withDataNamed:dataName
                     withDataValue:self.data];
}

@end

