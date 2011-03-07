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
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];

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

//- (void)viewWillAppear:(BOOL)animated
//{
//    [self.tableView reloadData];
//}

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
}

- (void)dealloc 
{
    [super dealloc];
}

@end

