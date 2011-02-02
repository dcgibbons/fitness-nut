//
//  RootViewController.m
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/01/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

#pragma mark -
#pragma mark Properties

@synthesize userData, groups, menuTableView;

#pragma mark -
#pragma mark View Lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    NSArray *nutritionMenuItems = [NSArray arrayWithObjects:
                                   
                                   [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"BMR & TDEE", @"title",
                                    @"daily calorie needs", @"subtitle",
                                    @"BMRViewController", @"viewClass",
                                    nil],
                                   
                                   [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"Macronutrients", @"title",
                                    @"carbohydrate, protein and fat requirements based upon training load", @"subtitle",
                                    @"MacronutrientNeedsViewController", @"viewClass",
                                    nil],
                                   
                                   nil];
    
    NSArray *bodyCompMenuItems = [NSArray arrayWithObjects:
                                  
                                  [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"Body Fat Estimation", @"title",
                                   @"estimate body fat based on body dimensions", @"subtitle",
                                   @"BodyFatEstimatorViewController", @"viewClass",
                                   nil],
                                  
                                  [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"Weight Predictor", @"title",
                                   @"predict weight based on body fat changes", @"subtitle",
                                   @"WeightPredictorViewController", @"viewClass",
                                   nil],
                                  
                                  nil];
    
    NSArray *a = [NSArray arrayWithObjects:nutritionMenuItems, bodyCompMenuItems, nil];
    self.groups = a;
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
    
    self.userData = nil;
    self.menuTableView = nil;
}

- (void)dealloc
{
    [userData release];
    [menuTableView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table View DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    int section = [indexPath section];
    int row = [indexPath row];
    NSArray *group = [self.groups objectAtIndex:section];
    NSDictionary *d = [group objectAtIndex:row];
    
    cell.textLabel.text = [d objectForKey:@"title"];
    cell.detailTextLabel.text = [d objectForKey:@"subtitle"];
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.detailTextLabel.numberOfLines = 0;    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: do this better.
    NSString *cellText = @"Go get some text for your cell.";
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize 
                                lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height + 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.groups objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.groups count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    switch (section) {
        case 0:
            title = @"Nutrition";
            break;
        case 1:
            title = @"Body Composition";
            break;
    }
    return title;
}


#pragma mark -
#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    int section = [indexPath section];
    int row = [indexPath row];
    
    NSDictionary *d = [[self.groups objectAtIndex:section] objectAtIndex:row];
    NSString *viewClassName = [d objectForKey:@"viewClass"];
    
    if (viewClassName) {
        UIViewController *controller = [[NSClassFromString(viewClassName) alloc]
                                        initWithStyle:UITableViewStyleGrouped];
        [controller performSelector:@selector(setUserData:) withObject:self.userData];
        
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

@end

