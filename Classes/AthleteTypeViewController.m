//
//  AthleteTypeViewController.m
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/09/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "AthleteTypeViewController.h"


@implementation AthleteTypeViewController

@synthesize dataName, data, athleteTypes, delegate, tableView;

- (void)updateAthleteType
{
    if (!self.data) {
        self.data = [[[AthleteType alloc] init] autorelease];
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    int row = [indexPath row];
    self.data.athleteType = row;    
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    // Only iOS 3.2.x or iOS 4.2.x and newer supports popovers
    if (NSClassFromString(@"UIPopoverController")) {
        self.contentSizeForViewInPopover = CGSizeMake(320, 240);
    }

    self.title = @"Athlete Type";

    self.athleteTypes = [NSArray arrayWithObjects:
                         @"General Fitness",
                         @"Body Builder",
                         @"Endurance - Transition",
                         @"Endurance - Preparation",
                         @"Endurance - Competitive",
                         nil
                         ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

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
    self.athleteTypes = nil;
    self.tableView = tableView;
}

- (void)dealloc 
{
    [dataName release];
    [data release];
    [athleteTypes release];
    [tableView release];
    [super dealloc];
}

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
    return [athleteTypes count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    int row = [indexPath row];
    cell.textLabel.text = [athleteTypes objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([data athleteType] == row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [self updateAthleteType];
    [aTableView reloadData];
}

#pragma mark -
#pragma mark UI Actions

- (IBAction)done:(id)sender
{
    [super done:sender];
    
    if (!self.data) {
        [self updateAthleteType];
    }
    
    [delegate athleteDataInputDone:self
                     withDataNamed:dataName
                     withDataValue:self.data];
}

@end
