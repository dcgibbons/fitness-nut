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

#ifdef PRO_VERSION
    [self.navigationController setToolbarHidden:NO animated:YES];
#endif
    
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

#ifdef PRO_VERSION
    [self.navigationController setToolbarHidden:NO animated:YES];
#endif
    
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

#ifdef PRO_VERSION
    [self.navigationController setToolbarHidden:NO animated:YES];
#endif

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

#ifdef PRO_VERSION
    [self.navigationController setToolbarHidden:NO animated:YES];
#endif

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
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
}

- (void)dealloc 
{
    [super dealloc];
}

#pragma mark -
#pragma mark UI Actions

- (void)emailResults:(id)sender
{
    [super emailResults:sender];
    
    if (![MFMailComposeViewController canSendMail]) {
        NSLog(@"Device cannot send mail.");
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Unable to Send Mail"
                                                        message:@"Your device has not yet been configured to send mail."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }

	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    
	[picker setSubject:@"Fitness Nut Pro: Daily Macronutrient Needs"];
    
	// Fill out the email body text
    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    NSNumber *hours = [userData objectForKey:@"athleteHours"];
    AthleteType *type = [userData objectForKey:@"athleteType"];
    
    Macronutrients *macronutrients = [FitnessCalculations macronutrientNeedsUsingMassInKilograms:[[weight weightAsKilograms] doubleValue] 
                                                                                      usingHours:[hours unsignedIntValue]
                                                                                  andAthleteType:type];
    if (macronutrients) {
        NSString *emailBody = [NSString stringWithFormat:@"<html>"
                               "<body>"
                               "<table>"
                               "<tbody>"
                               "<tr>"
                               "<th>Weight</th><td>%@</td>"
                               "</tr><tr>"
                               "<th>Weekly Training Hours</th><td>%u</td>"
                               "</tr><tr>"
                               "<th>Athlete Type</th><td>%@</td>"
                               "</tr><tr>"
                               "<th>Cabrohydrates</th><td>%u gm</td>"
                               "</tr><tr>"
                               "<th>Protein</th><td>%u gm</td>"
                               "</tr><tr>"
                               "<th>Fat</th><td>%u gm</td>"
                               "</tr><tr>"
                               "<th>Calories</th><td>%u</td>"
                               "</tr>",
                               weight, [hours unsignedIntValue], type, 
                               macronutrients.carbohydrates, 
                               macronutrients.protein,
                               macronutrients.fat,
                               macronutrients.calories
                               ];
        
        emailBody = [emailBody stringByAppendingString:@"</tbody></table><p>"
                     "Use <a href=\"http://itunes.apple.com/us/app/fitness-nut-pro/id424734288?mt=8\">Fitness Nut Pro</a> "
                     "for quick answers to your sports nutrition questions!"
                     "</p></body></html>"
                     ];
        
        [picker setMessageBody:emailBody isHTML:YES];
        
        [self presentModalViewController:picker animated:YES];
    }
    
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

