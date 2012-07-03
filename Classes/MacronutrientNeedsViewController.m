//
//  MacronutrientNeedsViewController.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/14/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

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

//#ifdef PRO_VERSION
    [self.navigationController setToolbarHidden:NO animated:YES];
//#endif
    
    Macronutrients *macronutrients = [FitnessCalculations macronutrientNeedsUsingMassInKilograms:[[weight weightAsKilograms] doubleValue] 
                                                                                      usingHours:[hours unsignedIntValue]
                                                                                  andAthleteType:type];
    return [NSString stringWithFormat:@"%u g", macronutrients.carbohydrates];
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
    return [NSString stringWithFormat:@"%u g", macronutrients.protein];
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
    return [NSString stringWithFormat:@"%u g", macronutrients.fat];
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
    return [NSString stringWithFormat:@"%u calories", macronutrients.calories];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.title = @"Macronutrients";
    
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
    NSString *nibName = @"MacronutrientNeedsInfoViewController";
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
#pragma mark Sharing

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
    
	[picker setSubject:@"Fitness Nut: Daily Macronutrient Needs"];
    
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
//    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
//    NSNumber *hours = [userData objectForKey:@"athleteHours"];
//    AthleteType *type = [userData objectForKey:@"athleteType"];
//    
//    Macronutrients *macronutrients = [FitnessCalculations macronutrientNeedsUsingMassInKilograms:[[weight weightAsKilograms] doubleValue] 
//                                                                                      usingHours:[hours unsignedIntValue]
//                                                                                  andAthleteType:type];
//    
//    NSString *text = [NSString stringWithFormat:@"I just calculated my daily macronutrient needs as %u g carbohydrate, %u g protein, %u g fat for %u weekly training hours", 
//                      macronutrients.carbohydrates, 
//                      macronutrients.protein,
//                      macronutrients.fat, 
//                      [hours unsignedIntValue]];
//    text = [text stringByAppendingString:@" with Fitness Nut!"];
//    SHKItem *item = [SHKItem URL:url title:text];
//    [SHKFacebook shareItem:item];
}

- (void)shareViaTwitter
{
    // Set up the built-in twitter composition view controller.
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    NSURL *url = [NSURL URLWithString:kFITNESS_NUT_PRO_AFFILIATE_URL];
    
    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    NSNumber *hours = [userData objectForKey:@"athleteHours"];
    AthleteType *type = [userData objectForKey:@"athleteType"];
        
    Macronutrients *macronutrients = [FitnessCalculations macronutrientNeedsUsingMassInKilograms:[[weight weightAsKilograms] doubleValue] 
                                                                                          usingHours:[hours unsignedIntValue]
                                                                                      andAthleteType:type];
        
        
    NSString *text = [NSString stringWithFormat:@"I just calculated my daily macronutrient needs as %ug carbohydrate, %ug protein, %ug fat", 
                      macronutrients.carbohydrates, macronutrients.protein,
                      macronutrients.fat];
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

