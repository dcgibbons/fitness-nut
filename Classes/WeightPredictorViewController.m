//
//  WeightPredictorViewController.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/24/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "WeightPredictorViewController.h"
#import "AthleteBodyFat.h"
#import "AthleteWeight.h"
#import "Conversions.h"
#import "AthleteDataProtocol.h"

@implementation WeightPredictorViewController

- (NSString *)calculatePredictedWeight
{
    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    if (!weight) return nil;
    
    AthleteBodyFat *bodyFat = [userData objectForKey:@"athleteBodyFat"];
    if (!bodyFat) return nil;

    AthleteBodyFat *desiredBodyFat = [userData objectForKey:@"desiredBodyFat"];
    if (!desiredBodyFat) return nil;
    
    double leanMass = [[weight weightAsKilograms] doubleValue] * (1.0 - [bodyFat.bodyFat doubleValue] / 100.0);
    double predictedMass = leanMass / (1.0 - [desiredBodyFat.bodyFat doubleValue] / 100.0);

    NSString *format = @"%.2f %@";
    NSString *suffix = @"kg";
    if (weight.units == Pounds) {
        predictedMass *= KILOGRAMS_PER_POUND;
        format = @"%.0f %@";
        suffix = @"lbs";
    }
    return [NSString stringWithFormat:format, predictedMass, suffix];
}

#pragma mark -
#pragma mark Properties

@synthesize sections, userData, tableView, adBannerView, bannerIsVisible;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
#ifndef PRO_VERSION
    // Create an ad banner just off the bottom of the view (i.e. not visible).
    self.bannerIsVisible = NO;    
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
    
    self.title = @"Weight Predictor";
    
    NSArray *athleteDetailsItems = [NSArray arrayWithObjects:
                                    
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"current weight", @"title",
                                     @"WeightPickerViewController", @"viewController",
                                     @"athleteWeight", @"dataName",
                                     nil
                                     ],
                                    
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"current body fat", @"title",
                                     @"BodyFatPickerViewController", @"viewController",
                                     @"athleteBodyFat", @"dataName",
                                     nil
                                     ],

                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"desired body fat", @"title",
                                     @"BodyFatPickerViewController", @"viewController",
                                     @"desiredBodyFat", @"dataName",
                                     nil
                                     ],
                                    
                                    nil];
    
    NSArray *resultItems = [NSArray arrayWithObjects:
                            
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"predicted weight", @"title",
                             @"calculatePredictedWeight", @"selector",
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
                      @"Results", @"sectionTitle",
                      resultItems, @"rows",
                      nil
                      ],
                     
                     nil];
}

 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations.
    return YES;
}

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
    self.adBannerView.delegate = nil;
    self.adBannerView = nil;
}

- (void)dealloc 
{
    adBannerView.delegate = nil;
    [adBannerView release];
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

