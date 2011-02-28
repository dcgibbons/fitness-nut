//
//  BMRViewController.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "BMRViewController.h"
#import "AthleteActivityLevel.h"
#import "AthleteAge.h"
#import "AthleteHeight.h"
#import "AthleteWeight.h"
#import "AthleteGender.h"
#import "FitnessCalculations.h"
#import "AthleteDataProtocol.h"

@implementation BMRViewController

- (NSNumber *)calculateBMRAsNumber
{
    AthleteAge *age = [userData objectForKey:@"athleteAge"];
    if (!age) return nil;
    
    AthleteHeight *height = [userData objectForKey:@"athleteHeight"];
    if (!height) return nil;
    
    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    if (!weight) return nil;
    
    AthleteGender *gender = [userData objectForKey:@"athleteGender"];
    if (!gender) return nil;
    
    int bmr = [FitnessCalculations bmrUsingMassInKilograms:[[weight weightAsKilograms] doubleValue] 
                                  usingHeightInCentimeters:[[height heightAsCentimeters] doubleValue]
                                           usingAgeInYears:age.age
                                                  usingSex:(gender.gender == Male)];
    return [NSNumber numberWithInt:bmr];
}

- (NSString *)calculateBMR
{
    NSNumber *bmr = [self calculateBMRAsNumber];
    if (!bmr) return nil;
    
    return [NSString stringWithFormat:@"%u kcals", [bmr intValue]];
}

- (NSString *)calculateTDEE
{
    NSNumber *bmr = [self calculateBMRAsNumber];
    if (!bmr) return nil;

    AthleteActivityLevel *activityLevel = [userData objectForKey:@"athleteActivityLevel"];
    if (!activityLevel) return nil;
    
    float multiplier;
    switch (activityLevel.activityLevel) {
        case Sedentary:
            multiplier = 1.2;
            break;
        case LightlyActive:
            multiplier = 1.375;
            break;
        case ModeratelyActive:
            multiplier = 1.550;
            break;
        case VeryActive:
            multiplier = 1.725;
            break;
        case ExtraActive:
            multiplier = 1.9;
            break;
    }
    
    int tdee = ceil((float)([bmr intValue]) * multiplier);
    return [NSString stringWithFormat:@"%u kcals", tdee];
}

#pragma mark -
#pragma mark Properties

@synthesize sections, userData, tableView, infoButton, adBannerView, bannerIsVisible;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
#ifndef PRO_VERSION
    // Create an ad banner just off the bottom of the view (i.e. not visible).
    self.bannerIsVisible=NO;    
    adBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0,
                                                                  self.view.frame.size.height,
                                                                  0, 0)];
    
    adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
    adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    adBannerView.delegate=self;
    [self.view addSubview:adBannerView];
#endif
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"BMR & TDEE";
    
    NSArray *athleteDetailsItems = [NSArray arrayWithObjects:
                                    
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"age", @"title",
                                     @"AgePickerViewController", @"viewController",
                                     @"athleteAge", @"dataName",
                                     nil
                                     ],
                                    
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"height", @"title",
                                     @"HeightPickerViewController", @"viewController",
                                     @"athleteHeight", @"dataName",
                                     nil
                                     ],
                                    
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"weight", @"title",
                                     @"WeightPickerViewController", @"viewController",
                                     @"athleteWeight", @"dataName",
                                     nil
                                     ],
                                    
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"gender", @"title",
                                     @"GenderViewController", @"viewController",
                                     @"athleteGender", @"dataName",
                                     nil
                                     ],
                                    
                                    nil];
    
    NSArray *bmrItems = [NSArray arrayWithObject:
                         
                         [NSDictionary dictionaryWithObjectsAndKeys:
                          @"bmr", @"title",
                          @"calculateBMR", @"selector",
                          nil
                          ]
                         
                         ];
    
    NSArray *tdeeItems = [NSArray arrayWithObjects:
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"activity", @"title",
                           @"ActivityLevelViewController", @"viewController",
                           @"athleteActivityLevel", @"dataName",
                           nil
                           ],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"tdee", @"title",
                           @"calculateTDEE", @"selector",
                           nil
                           ],
                          
                          nil];
    
    self.sections = [NSArray arrayWithObjects:
                     
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      @"Athlete Details", @"sectionTitle",
                      athleteDetailsItems, @"rows",
                      nil
                      ],
                     
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      @"Basal Metabolic Rate", @"sectionTitle",
                      bmrItems, @"rows",
                      nil
                      ],
                     
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      @"Total Daily Energy Expenditure", @"sectionTitle",
                      tdeeItems, @"rows",
                      nil
                      ],
                     
                     nil];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
    return [[[sections objectAtIndex:section] objectForKey:@"rows"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return [[sections objectAtIndex:section] objectForKey:@"sectionTitle"];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    int section = [indexPath section];
    int row = [indexPath row];
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSDictionary *rowDict = [[[sections objectAtIndex:section] objectForKey:@"rows"] 
                             objectAtIndex:row];
    
    cell.textLabel.text = [rowDict objectForKey:@"title"];
    
    NSString *dataKey = [rowDict objectForKey:@"dataName"];
    if (dataKey) {
        NSString *desc = [[userData objectForKey:dataKey] description];
        NSLog(@"description for %@ is %@\n", dataKey, desc);
        cell.detailTextLabel.text = desc;
    } else {
        NSString *selector = [rowDict objectForKey:@"selector"];
        if (selector) {
            cell.detailTextLabel.text = [self performSelector:NSSelectorFromString(selector)];
        }
    }
    
    NSString *viewClassName = [rowDict objectForKey:@"viewController"];
    if (viewClassName) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Navigation logic may go here. Create and push another view controller.

    int section = [indexPath section];
    int row = [indexPath row];
    
    NSDictionary *rowDict = [[[sections objectAtIndex:section] objectForKey:@"rows"] 
                             objectAtIndex:row];
    
    NSString *viewClassName = [rowDict objectForKey:@"viewController"];
    if (!viewClassName) return;

    UIViewController *detailViewController = [[NSClassFromString(viewClassName) alloc]
                                              initWithNibName:viewClassName bundle:nil];
    
    // TODO: BOGUS design, use a datasource instead?
    NSString *dataName = [rowDict objectForKey:@"dataName"];
    if ([detailViewController conformsToProtocol:@protocol(AthleteDataProtocol)]) {
        id <AthleteDataProtocol> p = (id<AthleteDataProtocol>)detailViewController;
        [p setDataName:dataName];
        [p setData:[userData objectForKey:dataName]];
    }
    [detailViewController performSelector:@selector(setDelegate:) withObject:self];

    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

#pragma mark -
#pragma mark Athlete Data delegate

- (void)athleteDataInputDone:(UIViewController *)viewController
               withDataNamed:(NSString *)dataName
               withDataValue:(id)data
{
    NSLog(@"received athlete data: %@=%@\n", dataName, data);
    [userData setObject:data forKey:dataName];
    [self.tableView reloadData];
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
    
    self.sections = nil;
    self.userData = nil;
    self.tableView = nil;
    self.infoButton = nil;
    self.adBannerView.delegate = nil;
    self.adBannerView = nil;
}

- (void)dealloc 
{
    adBannerView.delegate = nil;
    [adBannerView release];
    [infoButton release];
    [tableView release];
    [sections release];
    [userData release];
    [super dealloc];
}

#pragma mark -
#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        
        CGFloat fullViewHeight = self.view.frame.size.height;
        CGRect tableFrame = self.tableView.frame;
        CGRect bannerFrame = self.adBannerView.frame;
        
        // Shrink the tableview to create space for banner
        tableFrame.size.height = fullViewHeight - bannerFrame.size.height;
        
        // Move banner onscreen
        bannerFrame.origin.y = fullViewHeight - bannerFrame.size.height;   
        
        self.tableView.frame = tableFrame;
        self.adBannerView.frame = bannerFrame;        
        
        [UIView commitAnimations];
        
        self.bannerIsVisible = YES;
    }    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"adBanner didFailToReceiveAdWithError, error=%@\n", error);
    
    if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Grow the tableview to occupy space left by banner
        CGFloat fullViewHeight = self.view.frame.size.height;
        CGRect tableFrame = self.tableView.frame;
        tableFrame.size.height = fullViewHeight;
        
        // Move the banner view offscreen
        CGRect bannerFrame = self.adBannerView.frame;
        bannerFrame.origin.y = fullViewHeight;
        
        self.tableView.frame = tableFrame;
        self.adBannerView.frame = bannerFrame;
        
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

@end

