//
//  WeightPredictorViewController.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/24/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

#import "WeightPredictorViewController.h"
#import "AthleteBodyFat.h"
#import "AthleteWeight.h"
#import "Conversions.h"
#import "AthleteDataProtocol.h"

#import "WeightPredictionDetailViewController.h"

#import "AthleteType.h"
#import "Macronutrients.h"
#import "FitnessCalculations.h"

#import "GANTracker.h"

@implementation WeightPredictorViewController

- (NSNumber *)calculatePredictedMass
{
    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    if (!weight) return nil;
    
    AthleteBodyFat *bodyFat = [userData objectForKey:@"athleteBodyFat"];
    if (!bodyFat) return nil;
    
    AthleteBodyFat *desiredBodyFat = [userData objectForKey:@"desiredBodyFat"];
    if (!desiredBodyFat) return nil;
    
    //#ifdef PRO_VERSION
    [self.navigationController setToolbarHidden:NO animated:YES];
    //#endif
    
    double leanMass = [[weight weightAsKilograms] doubleValue] * (1.0 - [bodyFat.bodyFat doubleValue] / 100.0);
    double predictedMass = leanMass / (1.0 - [desiredBodyFat.bodyFat doubleValue] / 100.0);

    return [NSNumber numberWithDouble:predictedMass];
}

- (NSString *)calculatePredictedWeight
{
//#ifdef PRO_VERSION
    [self.navigationController setToolbarHidden:NO animated:YES];
//#endif

    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    if (!weight) return nil;

    NSNumber *predictedMass = [self calculatePredictedMass];
    if (!predictedMass) return nil;
    
    NSString *format = @"%.2f %@";
    NSString *suffix = @"kg";
    
    if (weight.units == Pounds) {
        double m = [predictedMass doubleValue] * KILOGRAMS_PER_POUND;
        predictedMass = [NSNumber numberWithDouble:m];
        format = @"%.0f %@";
        suffix = @"lb.";
    }
    
    return [NSString stringWithFormat:format,
            [predictedMass doubleValue],
            suffix];
}

- (void)calculateWeightChangeGoodies
{
    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    if (!weight) return;

    NSNumber *predictedMass = [self calculatePredictedMass];
    if (!predictedMass) return;
    
    double c = [[weight weightAsKilograms] doubleValue];
    double p = [predictedMass doubleValue];

    double weeks = 0.0;
    double calorieDiff = 0.0;
    if (p > c) {
        double d = p - c;
        NSLog(@"Predicted weight is an increase. %.2f kg difference", d);
        double increasePerWeek = 0.5;
        calorieDiff = 500;
        weeks = ceil(d / increasePerWeek);
        NSLog(@"%0.0f weeks to get there", weeks);
    } else if (p < c) {
        double d = c - p;
        NSLog(@"Predicted weight is an decrease. %.2f kg difference", d);
        double decreasePerWeek = 0.5;
        calorieDiff = -500;
        weeks = ceil(d / decreasePerWeek);
        NSLog(@"%0.0f weeks to get there", weeks);
    }
    
    NSTimeInterval secondsPerWeek = 24 * 60 * 60 * 7 * weeks;
    NSDate *finished = [[NSDate alloc]
                        initWithTimeIntervalSinceNow:secondsPerWeek];
    NSLog(@"Finished at %@", finished);
    
    
    NSNumber *hours = [userData objectForKey:@"athleteHours"];
    AthleteType *type = [userData objectForKey:@"athleteType"];
    
    Macronutrients *macronutrients = [FitnessCalculations macronutrientNeedsUsingMassInKilograms:[[weight weightAsKilograms] doubleValue] 
                                                                                      usingHours:[hours unsignedIntValue]
                                                                                  andAthleteType:type];
    
    double calories = macronutrients.calories;
    NSLog(@"Eat %f calories a day instead of %f to get there", (calories + calorieDiff), calories
          );
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
#ifdef PRO_VERSION
                             @"WeightPredictionDetailViewController", @"detailDisclosureView",
#endif
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
#pragma mark Table View Delegate

#ifdef PRO_VERSION
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
#ifndef DEBUG
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"calculate"
                                         action:@"view_bmr_graph"
                                          label:@""
                                          value:-1
                                      withError:&error]) {
        NSLog(@"Unable to track calculate event for view_bmr_graph, %@",
              error);
    }
#endif
    
    int section = [indexPath section];
    int row = [indexPath row];
    
    NSDictionary *rowDict = [[[sections objectAtIndex:section] objectForKey:@"rows"] 
                             objectAtIndex:row];
    
    // TODO: this isn't generic here, so fix it when you need it to be
    NSString *viewClassName = [rowDict objectForKey:@"detailDisclosureView"];
    if (!viewClassName) return;
    
    NSString *nibName = viewClassName;
    
    WeightPredictionDetailViewController *vc = [[WeightPredictionDetailViewController alloc] initWithNibName:nibName 
                                                                                                      bundle:nil];
    vc.userData = userData;
    
    [self calculateWeightChangeGoodies];
    
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    
    // TODO: use a popup on the iPad
}

#endif // PRO_VERSION

#pragma mark -
#pragma Sharing

- (void)shareViaEmail
{
    
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
    
	[picker setSubject:@"Fitness Nut Pro: Weight Predictor"];
    
	// Fill out the email body text
    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    AthleteBodyFat *bodyFat = [userData objectForKey:@"athleteBodyFat"];
    AthleteBodyFat *desiredBodyFat = [userData objectForKey:@"desiredBodyFat"];
    
    NSString *predictedMass = [self calculatePredictedWeight];
    
    if (predictedMass) {
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
        
        [picker setMessageBody:emailBody isHTML:YES];
        
        [self presentModalViewController:picker animated:YES];
    }
    
    [picker release];

}
- (void)shareViaFacebook
{
//    NSURL *url = [NSURL URLWithString:kFITNESS_NUT_PRO_AFFILIATE_URL];
//    AthleteBodyFat *bodyFat = [userData objectForKey:@"athleteBodyFat"];
//    AthleteBodyFat *desiredBodyFat = [userData objectForKey:@"desiredBodyFat"];
//    NSString *predictedMass = [self calculatePredictedWeight];
//    
//    NSString *text = [NSString stringWithFormat:@"I just predicted my weight as %@ if I change my body fat to %@ from %@", 
//                      predictedMass, desiredBodyFat, bodyFat];
//    text = [text stringByAppendingString:@" with Fitness Nut!"];
//    SHKItem *item = [SHKItem URL:url title:text];
//    [SHKFacebook shareItem:item];
}

- (void)shareViaTwitter
{
    // Set up the built-in twitter composition view controller.
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    NSURL *url = [NSURL URLWithString:kFITNESS_NUT_PRO_AFFILIATE_URL];
    AthleteBodyFat *bodyFat = [userData objectForKey:@"athleteBodyFat"];
    AthleteBodyFat *desiredBodyFat = [userData objectForKey:@"desiredBodyFat"];
    NSString *predictedMass = [self calculatePredictedWeight];
        
    NSString *text = [NSString stringWithFormat:@"I just predicted my weight as %@ if I change my body fat to %@ from %@", 
                          predictedMass, desiredBodyFat, bodyFat];
    text = [text stringByAppendingString:@" with #FitnessNut"];   
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    [tweetViewController setInitialText:text];
    [tweetViewController addURL:url];
    
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        NSString *output;
        
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                // The cancel button was tapped.
                output = @"Tweet cancelled.";
                break;
            case TWTweetComposeViewControllerResultDone:
                // The tweet was sent.
                output = @"Tweet done.";
                break;
            default:
                break;
        }
        
        NSLog(@"%@", output);
        
        // Dismiss the tweet composition view controller.
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    // Present the tweet composition view controller modally.
    [self presentModalViewController:tweetViewController animated:YES];
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

