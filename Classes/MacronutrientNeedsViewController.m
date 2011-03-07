//
//  MacronutrientNeedsViewController.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/14/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "MacronutrientNeedsViewController.h"
#import "AthleteType.h"
#import "AthleteWeight.h"
#import "FitnessCalculations.h"
#import "AthleteDataProtocol.h"

@implementation MacronutrientNeedsViewController


- (NSString *)calculateCarbIntake
{
    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    if (!weight) return nil;

    NSNumber *hours = [userData objectForKey:@"athleteHours"];
    if (!hours) return nil;

    AthleteType *type = [userData objectForKey:@"athleteType"];
    if (!type) return nil;

    Macronutrients *macronutrients = [FitnessCalculations macronutrientNeedsUsingMassInKilograms:[[weight weightAsKilograms] doubleValue] 
                                                                                      usingHours:[hours unsignedIntValue]
                                                                                  andAthleteType:type];
    return [NSString stringWithFormat:@"%u gm", macronutrients.carbohydrates];
}

- (NSString *)calculateProteinIntake
{
    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    if (!weight) return nil;
    
    NSNumber *hours = [userData objectForKey:@"athleteHours"];
    if (!hours) return nil;
    
    AthleteType *type = [userData objectForKey:@"athleteType"];
    if (!type) return nil;
    
    Macronutrients *macronutrients = [FitnessCalculations macronutrientNeedsUsingMassInKilograms:[[weight weightAsKilograms] doubleValue] 
                                                                                      usingHours:[hours unsignedIntValue]
                                                                                  andAthleteType:type];
    return [NSString stringWithFormat:@"%u gm", macronutrients.protein];
}

- (NSString *)calculateFatIntake
{
    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    if (!weight) return nil;
    
    NSNumber *hours = [userData objectForKey:@"athleteHours"];
    if (!hours) return nil;
    
    AthleteType *type = [userData objectForKey:@"athleteType"];
    if (!type) return nil;
    
    Macronutrients *macronutrients = [FitnessCalculations macronutrientNeedsUsingMassInKilograms:[[weight weightAsKilograms] doubleValue] 
                                                                                      usingHours:[hours unsignedIntValue]
                                                                                  andAthleteType:type];
    return [NSString stringWithFormat:@"%u gm", macronutrients.fat];
}

- (NSString *)calculateDailyCalories
{
    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    if (!weight) return nil;
    
    NSNumber *hours = [userData objectForKey:@"athleteHours"];
    if (!hours) return nil;
    
    AthleteType *type = [userData objectForKey:@"athleteType"];
    if (!type) return nil;
    
    Macronutrients *macronutrients = [FitnessCalculations macronutrientNeedsUsingMassInKilograms:[[weight weightAsKilograms] doubleValue] 
                                                                                      usingHours:[hours unsignedIntValue]
                                                                                  andAthleteType:type];
    return [NSString stringWithFormat:@"%u kilocalories", macronutrients.calories];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Macronutrient Needs";
    
    NSArray *athleteDetailsItems = [NSArray arrayWithObjects:
                                    
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"weight", @"title",
                                     @"WeightPickerViewController", @"viewController",
                                     @"athleteWeight", @"dataName",
                                     nil
                                     ],
                                    
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"athlete type", @"title",
                                     @"AthleteTypeViewController", @"viewController",
                                     @"athleteType", @"dataName",
                                     nil
                                     ],

                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"weekly training hours", @"title",
                                     @"HoursPickerViewController", @"viewController",
                                     @"athleteHours", @"dataName",
                                     nil
                                     ],
                                    
                                    nil];
    
    NSArray *resultItems = [NSArray arrayWithObjects:
                            
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"carbohydrate", @"title",
                             @"calculateCarbIntake", @"selector",
                             nil
                             ],
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"protein", @"title",
                             @"calculateProteinIntake", @"selector",
                             nil
                             ],
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"fat", @"title",
                             @"calculateFatIntake", @"selector",
                             nil
                             ],
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"calories", @"title",
                             @"calculateDailyCalories", @"selector",
                             nil
                             ],
                            nil
                            
                            
                            ];
    
    self.sections = [NSArray arrayWithObjects:
                     
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      @"Athlete Details", @"sectionTitle",
                      athleteDetailsItems, @"rows",
                      nil
                      ],
                     
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      @"Recommended Daily Intake", @"sectionTitle",
                      resultItems, @"rows",
                      nil
                      ],
                     nil];
    
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

