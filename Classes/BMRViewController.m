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
#import "SecondaryDetailViewController.h"

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
    
    [self.navigationController setToolbarHidden:NO animated:YES];

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

@synthesize infoButton;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];

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
    
    self.infoButton = nil;
}

- (void)dealloc 
{
    [infoButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark UI Actions

- (void)emailResults:(id)sender
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;

	[picker setSubject:@"FitnessNutPro: BMR & TDEE results"];
    
	// Fill out the email body text
    AthleteAge *age = [userData objectForKey:@"athleteAge"];
    AthleteHeight *height = [userData objectForKey:@"athleteHeight"];
    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    AthleteGender *gender = [userData objectForKey:@"athleteGender"];
    NSString *bmr = [self calculateBMR];
    
    AthleteActivityLevel *activityLevel = [userData objectForKey:@"athleteActivityLevel"];
    NSString *tdee = [self calculateTDEE];
    
    NSString *emailBody = 
        [NSString stringWithFormat:
        @"<html>"
         "<body>"
            "<table>"
                "<tbody>"
                    "<tr>"
                        "<th>Age</th><td>%@</td>"
                    "</tr><tr>"
                        "<th>Height</th><td>%@</td>"
                    "</tr><tr>"
                        "<th>Weight</th><td>%@</td>"
                    "</tr><tr>"
                        "<th>Gender</th><td>%@</td>"
                    "</tr><tr>"
                        "<th>BMR</th><td>%@</td>"
                    "</tr>",
         age, height, weight, gender, bmr
         ];
    
    if (tdee) {
        emailBody = [emailBody stringByAppendingFormat:
            @"<tr>"
                "<th>Activity</th><td>%@</td>"
            "</tr><tr>"
                "<th>TDEE</th><td>%@</td>"
            "</tr>",
            activityLevel, tdee
            ];
    }
    
    emailBody = [emailBody stringByAppendingString:
                 @"</tbody></table><p>"
                 "Use <a href=\"http://itunes.apple.com/us/app/fitness-nut/id420480042?mt=8\">Fitness Nut</a> "
                 "for quick answers to your sports nutrition questions!"
                 "</p></body></html>"
                 ];
    
	[picker setMessageBody:emailBody isHTML:YES];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];    
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate methods

// Dismisses the email composition interface when users tap Cancel or Send.
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error 
{	
	[self dismissModalViewControllerAnimated:YES];
}

@end

