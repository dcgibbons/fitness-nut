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
#import "SHK.h"
#import "SHKFacebook.h"
#import "SHKTwitter.h"
#import "SHKMail.h"

@implementation WeightPredictorViewController

- (NSString *)calculatePredictedWeight
{
    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    if (!weight) return nil;
    
    AthleteBodyFat *bodyFat = [userData objectForKey:@"athleteBodyFat"];
    if (!bodyFat) return nil;

    AthleteBodyFat *desiredBodyFat = [userData objectForKey:@"desiredBodyFat"];
    if (!desiredBodyFat) return nil;
    
#ifdef PRO_VERSION
    [self.navigationController setToolbarHidden:NO animated:YES];
#endif

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIButtonType buttonType = UIButtonTypeInfoLight;
    if (IS_PAD_DEVICE() && self.navigationController.navigationBar.barStyle == UIBarStyleDefault) {
        buttonType = UIButtonTypeInfoDark;
    }
    UIButton* infoButton = [UIButton buttonWithType:buttonType];
    [infoButton addTarget:self 
                   action:@selector(info:) 
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] 
                                    initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItem = modalButton;
    [modalButton release];    
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

- (IBAction)info:(id)sender
{
    NSString *nibName = @"WeightPredictorInfoViewController";
    InfoViewController *controller = [[InfoViewController alloc] initWithNibName:nibName
                                                                          bundle:nil];
    controller.delegate = self;
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    
	[controller release];
}

#pragma mark -
#pragma mark InfoViewControllerDelegate methods

-(void)infoViewControllerDidFinish:(InfoViewController *)controller
{
 	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma Sharing

- (void)shareViaEmail
{
	// Fill out the email body text
    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    AthleteBodyFat *bodyFat = [userData objectForKey:@"athleteBodyFat"];
    AthleteBodyFat *desiredBodyFat = [userData objectForKey:@"desiredBodyFat"];
    
    NSString *predictedMass = [self calculatePredictedWeight];
    
    NSString *emailBody = [NSString stringWithFormat:@"<html>"
                           "<body>"
                           "<table>"
                           "<tbody>"
                           "<tr>"
                           "<th>Current Weight</th><td>%@</td>"
                           "</tr><tr>"
                           "<th>Current Body Fat</th><td>%@</td>"
                           "</tr><tr>"
                           "<th>Desired Body Fat</th><td>%@</td>"
                           "</tr><tr>"
                           "<th>Predicted Weight</th><td>%@</td>"
                           "</tr>",
                           weight,
                           bodyFat,
                           desiredBodyFat,
                           predictedMass
                           ];
    
    emailBody = [emailBody stringByAppendingFormat:@"</tbody></table><p>"
                 "Use <a href=\"%@\">Fitness Nut Pro</a> "
                 "for quick answers to your sports nutrition questions!"
                 "</p></body></html>",
                 kFITNESS_NUT_PRO_AFFILIATE_URL
                 ];
    
    SHKItem *item = [SHKItem text:emailBody];
    item.title = @"Fitness Nut Pro: Daily Macronutrient Needs";
    
    [SHKMail shareItem:item];
}
- (void)shareViaFacebook
{
    NSURL *url = [NSURL URLWithString:kFITNESS_NUT_PRO_AFFILIATE_URL];
    AthleteBodyFat *bodyFat = [userData objectForKey:@"athleteBodyFat"];
    AthleteBodyFat *desiredBodyFat = [userData objectForKey:@"desiredBodyFat"];
    NSString *predictedMass = [self calculatePredictedWeight];
    
    NSString *text = [NSString stringWithFormat:@"I just predicted my weight as %@ if I change my body fat to %@ from %@", 
                      predictedMass, desiredBodyFat, bodyFat];
    text = [text stringByAppendingString:@" with Fitness Nut!"];
    SHKItem *item = [SHKItem URL:url title:text];
    [SHKFacebook shareItem:item];
}

- (void)shareViaTwitter
{
    NSURL *url = [NSURL URLWithString:kFITNESS_NUT_PRO_AFFILIATE_URL];
    AthleteBodyFat *bodyFat = [userData objectForKey:@"athleteBodyFat"];
    AthleteBodyFat *desiredBodyFat = [userData objectForKey:@"desiredBodyFat"];
    NSString *predictedMass = [self calculatePredictedWeight];
    
    NSString *text = [NSString stringWithFormat:@"I just predicted my weight as %@ if I change my body fat to %@ from %@", 
                      predictedMass, desiredBodyFat, bodyFat];
    text = [text stringByAppendingString:@" with #FitnessNut"];
    SHKItem *item = [SHKItem URL:url title:text];
    [SHKTwitter shareItem:item];
}

@end

