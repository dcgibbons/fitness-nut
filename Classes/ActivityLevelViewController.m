//
//  ActivityLevelViewController.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/12/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "ActivityLevelViewController.h"
#import "AthleteActivityLevel.h"


@implementation ActivityLevelViewController


- (void)updateActivityLevel
{
    if (!self.data) {
        self.data = [[[AthleteActivityLevel alloc] init] autorelease];
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    int row = [indexPath row];
    self.data.activityLevel = row;    
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    self.title = @"Activity Level";
    
    self.activityLevels = [NSArray arrayWithObjects:
                           @"Sedentary",
                           @"Lightly Active",
                           @"Moderately Active",
                           @"Very Active",
                           @"Extra Active",
                           nil
                           ];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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
    return [activityLevels count];
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
    int row = [indexPath row];
    cell.textLabel.text = [activityLevels objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([data activityLevel] == row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [self updateActivityLevel];
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
    // For example: self.myOutlet = nil;
    
    self.dataName = nil;
    self.data = nil;
    self.activityLevels = nil;
    self.cancelButton = nil;
    self.doneButton = nil;
}

- (void)dealloc 
{
    [dataName release];
    [data release];
    [activityLevels release];
    [cancelButton release];
    [doneButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark Properties

@synthesize delegate, dataName, data, activityLevels;
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
        [self updateActivityLevel];
    }

    [delegate athleteDataInputDone:self
                     withDataNamed:dataName
                     withDataValue:self.data];
}

@end

