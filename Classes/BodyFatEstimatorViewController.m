//
//  BodyFatEstimatorViewController.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/26/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "BodyFatEstimatorViewController.h"
#import "AthleteBodyFat.h"
#import "AthleteHeight.h"
#import "AthleteWeight.h"
#import "AthleteGender.h"
#import "AthleteMeasurement.h"
#import "AthleteDataProtocol.h"

@implementation BodyFatEstimatorViewController

- (BOOL)isFemale
{
    AthleteGender *gender = [userData objectForKey:@"athleteGender"];
    return gender != nil && gender.gender == Female;
}

- (NSString *)calculatePredictedBodyFat
{
    AthleteHeight *height = [userData objectForKey:@"athleteHeight"];
    if (!height) return nil;
    
    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    if (!weight) return nil;
    
    AthleteGender *gender = [userData objectForKey:@"athleteGender"];
    if (!gender) return nil;
    
    AthleteMeasurement *neckGirth = [userData objectForKey:@"athleteNeckGirth"];
    if (!neckGirth) return nil;
    
    AthleteMeasurement *waistGirth = [userData objectForKey:@"athleteWaistGirth"];
    if (!waistGirth) return nil;
    
    AthleteMeasurement *hipsGirth = [userData objectForKey:@"athleteHipsGirth"];
    if (gender.gender == Female && !hipsGirth) return nil;
    
#ifdef PRO_VERSION
    [self.navigationController setToolbarHidden:NO animated:YES];
#endif

    double bodyFat;
    if (gender.gender == Male) {
        bodyFat = 86.010 * log10([[waistGirth measurementAsInches] doubleValue] -
                                 [[neckGirth measurementAsInches] doubleValue])
        - 74.041 * log10([[height heightAsInches] doubleValue])
        + 36.76;
    } else {
        bodyFat = 163.205 * log10([[waistGirth measurementAsInches] doubleValue] +
                                  [[hipsGirth measurementAsInches] doubleValue] -
                                  [[neckGirth measurementAsInches] doubleValue])
        - 97.684 * log10([[height heightAsInches] doubleValue]) 
        - 78.387;
    }

    // Sometimes, it is awesome to just hack and not care.
    bodyFat = ceil(bodyFat);
    [userData setObject:[[[AthleteBodyFat alloc] initWithBodyFat:[NSNumber numberWithDouble:bodyFat]] autorelease]
                 forKey:@"athleteBodyFat"];
    
    return [NSString stringWithFormat:@"%.0f%%", bodyFat];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Body Fat Estimator";
    
    NSArray *athleteDetailsItems = [NSArray arrayWithObjects:
                                    
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"height", @"title",
                                     @"HeightPickerViewController", @"viewController",
                                     @"athleteHeight", @"dataName",
                                     nil, @"visibilitySelector",
                                     nil
                                     ],
                                    
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"weight", @"title",
                                     @"WeightPickerViewController", @"viewController",
                                     @"athleteWeight", @"dataName",
                                     nil, @"visibilitySelector",
                                     nil
                                     ],
                                    
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"gender", @"title",
                                     @"GenderViewController", @"viewController",
                                     @"athleteGender", @"dataName",
                                     nil, @"visibilitySelector",
                                     nil
                                     ],

                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"neck girth", @"title",
                                     @"GirthPickerViewController", @"viewController",
                                     @"athleteNeckGirth", @"dataName",
                                     nil, @"visibilitySelector",
                                     nil
                                     ],
                                    
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"waist girth", @"title",
                                     @"GirthPickerViewController", @"viewController",
                                     @"athleteWaistGirth", @"dataName",
                                     nil, @"visibilitySelector",
                                     nil
                                     ],
                                    
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"hips girth", @"title",
                                     @"GirthPickerViewController", @"viewController",
                                     @"athleteHipsGirth", @"dataName",
                                     @"isFemale", @"visibilitySelector",
                                     nil
                                     ],
                                    
                                    nil];
    
    NSArray *resultItems = [NSArray arrayWithObjects:
                            
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"body fat", @"title",
                             @"calculatePredictedBodyFat", @"selector",
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
    int rows = [super tableView:aTableView numberOfRowsInSection:section];
    
    // If in the data section and we're male, then don't show the last row - the hips girth
    if (section == 0 && ![self isFemale]) {
        rows--;
    }

    return rows;
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
    
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    
	[picker setSubject:@"Fitness Nut Pro: Body Fat Estimation"];
    
	// Fill out the email body text
    AthleteHeight *height = [userData objectForKey:@"athleteHeight"];
    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    AthleteGender *gender = [userData objectForKey:@"athleteGender"];
    AthleteMeasurement *neckGirth = [userData objectForKey:@"athleteNeckGirth"];
    AthleteMeasurement *waistGirth = [userData objectForKey:@"athleteWaistGirth"];
    AthleteMeasurement *hipsGirth = [userData objectForKey:@"athleteHipsGirth"];

    NSString *bodyFat = [self calculatePredictedBodyFat];
    
    if (bodyFat) {
        NSString *emailBody = [NSString stringWithFormat:@"<html>"
                               "<body>"
                               "<table>"
                               "<tbody>"
                               "<tr>"
                               "<th>Height</th><td>%@</td>"
                               "</tr><tr>"
                               "<th>Weight</th><td>%@</td>"
                               "</tr><tr>"
                               "<th>Gender</th><td>%@</td>"
                               "</tr><tr>"
                               "<th>Neck Girth</th><td>%@</td>"
                               "</tr><tr>"
                               "<th>Waist Girth</th><td>%@</td>"
                               "</tr>",
                               weight, 
                               height,
                               gender,
                               neckGirth,
                               waistGirth
                               ];

        if (gender.gender == Female) {
            emailBody = [emailBody stringByAppendingFormat:@"<tr>"
                         "<th>Hips Girth</th><td>%@</td>"
                         "</tr>",
                         hipsGirth
                         ];
        }

        emailBody = [emailBody stringByAppendingFormat:@"<tr>"
                     "<th>Estimated Body Fat</th><td>%@</td>",
                     bodyFat
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

