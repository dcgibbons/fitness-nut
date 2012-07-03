//
//  BMRViewController.m
//  Fitness Calculator
//
//  Created by Chad Gibbons on 01/10/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

#import "BMRViewController.h"
#import "AthleteActivityLevel.h"
#import "AthleteAge.h"
#import "AthleteHeight.h"
#import "AthleteWeight.h"
#import "AthleteGender.h"
#import "FitnessCalculations.h"
#import "AthleteDataProtocol.h"
#import "SecondaryDetailViewController.h"
#import "GANTracker.h"

#ifdef PRO_VERSION
#import "BMRGraphViewController.h"
#endif

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
    
//#ifdef PRO_VERSION
    [self.navigationController setToolbarHidden:NO animated:YES];
//#endif

    int bmr = [FitnessCalculations bmrUsingMassInKilograms:[[weight weightAsKilograms] doubleValue] 
                                  usingHeightInCentimeters:[[height heightAsCentimeters] doubleValue]
                                           usingAgeInYears:age.age
                                                  usingSex:(gender.gender == Male)];
    
    NSNumber *bmrNumber = [NSNumber numberWithInt:bmr];
    [userData setObject:bmrNumber forKey:@"athleteBMR"];
    return bmrNumber;
}

- (NSString *)calculateBMR
{
    NSNumber *bmr = [self calculateBMRAsNumber];
    if (!bmr) return nil;
    
    return [NSString stringWithFormat:@"%u calories", [bmr intValue]];
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
    NSNumber *tdeeNumber = [NSNumber numberWithInt:tdee];
    [userData setObject:tdeeNumber forKey:@"athleteTDEE"];
    
    return [NSString stringWithFormat:@"%u calories", tdee];
}

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
#ifdef PRO_VERSION
                           @"BMRGraphViewController", @"detailDisclosureView",
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
}

- (void)dealloc 
{
    [super dealloc];
}

#pragma mark -
#pragma mark UI Actions

- (IBAction)info:(id)sender
{
    NSString *nibName = @"BMRInfoViewController";
    InfoViewController *controller = [[InfoViewController alloc] initWithNibName:nibName
                                                                          bundle:nil];
    controller.delegate = self;
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    
	[controller release];
}

#ifdef PRO_VERSION

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 1;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot 
                     field:(NSUInteger)fieldEnum 
               recordIndex:(NSUInteger)index 
{
    NSUInteger athleteBMR = [[userData objectForKey:@"athleteBMR"] 
                             unsignedIntValue];
    NSUInteger athleteTDEE = [[userData objectForKey:@"athleteTDEE"] 
                              unsignedIntValue];
    NSUInteger lose1lbs = athleteTDEE - 500;
    NSUInteger lose2lbs = athleteTDEE - 1000;
    
    NSDecimalNumber *num = nil;
    
    switch (fieldEnum) {
        case CPTBarPlotFieldBarLocation:
            if ([plot.identifier isEqual:@"bmr"]) {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithInt:1];
            } else if ([plot.identifier isEqual:@"tdee"]) {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithInt:5];
            } else if ([plot.identifier isEqual:@"minus1"]) {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithInt:10];
            } else if ([plot.identifier isEqual:@"minus2"]) {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithInt:15];
            }
            break;
        case CPTBarPlotFieldBarBase:
            //        case CPTBarPlotFieldBarLength:
            if ([plot.identifier isEqual:@"bmr"]) {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInt:athleteBMR];
            } else if ([plot.identifier isEqual:@"tdee"]) {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInt:athleteTDEE];
            } else if ([plot.identifier isEqual:@"minus1"]) {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInt:lose1lbs];
            } else if ([plot.identifier isEqual:@"minus2"]) {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInt:lose2lbs];
            }
            break;
    }
    
    return num;
}

-(CPTFill *) barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSNumber *)index; 
{
	return nil;
}

- (CPTGraph *)createGraph
{
    NSUInteger athleteTDEE = [[userData objectForKey:@"athleteTDEE"] 
                              unsignedIntValue];
    
    NSDecimalNumber *n = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:athleteTDEE];
    NSDecimalNumberHandler *h = [[NSDecimalNumberHandler alloc] 
                                 initWithRoundingMode:NSRoundUp
                                 scale:-2
                                 raiseOnExactness:NO 
                                 raiseOnOverflow:NO 
                                 raiseOnUnderflow:NO 
                                 raiseOnDivideByZero:NO];
    n = [n decimalNumberByRoundingAccordingToBehavior:h];
    
    // Create barChart from theme
    CPTGraph *barChart;
    barChart = [[CPTGraph alloc] initWithFrame:CGRectZero];
	CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [barChart applyTheme:theme];
    
    // Border
    barChart.plotAreaFrame.borderLineStyle = nil;
    barChart.plotAreaFrame.cornerRadius = 0.0f;
	
    // Paddings
    barChart.paddingLeft = 0.0f;
    barChart.paddingRight = 0.0f;
    barChart.paddingTop = 0.0f;
    barChart.paddingBottom = 0.0f;
	
    barChart.plotAreaFrame.paddingLeft = 70.0;
	barChart.plotAreaFrame.paddingTop = 20.0;
	barChart.plotAreaFrame.paddingRight = 20.0;
	barChart.plotAreaFrame.paddingBottom = 80.0;
    
    // Graph title
    barChart.title = @"";
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    textStyle.fontSize = 16.0f;
    barChart.titleTextStyle = textStyle;
    barChart.titleDisplacement = CGPointMake(0.0f, -20.0f);
    barChart.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
	
	// Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(850) 
                                                   length:CPTDecimalFromInt([n unsignedIntValue] - 850)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) 
                                                   length:CPTDecimalFromFloat(16.0f)];
    
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.axisLineStyle = nil;
    x.majorTickLineStyle = nil;
    x.minorTickLineStyle = nil;
    x.majorIntervalLength = CPTDecimalFromString(@"5");
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"850"); // Y position of the label?
	x.title = @"";
    x.titleLocation = CPTDecimalFromFloat(7.5f);
	x.titleOffset = 55.0f;
	
	// Define some custom labels for the data elements
	x.labelRotation = M_PI/4;
	x.labelingPolicy = CPTAxisLabelingPolicyNone;
	NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:1], [NSDecimalNumber numberWithInt:5], [NSDecimalNumber numberWithInt:10], [NSDecimalNumber numberWithInt:15], nil];
	NSArray *xAxisLabels = [NSArray arrayWithObjects:@"BMR", @"TDEE", @"-1 lb./week", @"-2 lb./week", nil];
	NSUInteger labelLocation = 0;
	NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
	for (NSNumber *tickLocation in customTickLocations) {
		CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[xAxisLabels objectAtIndex:labelLocation++] 
                                                        textStyle:x.labelTextStyle];
		newLabel.tickLocation = [tickLocation decimalValue];
		newLabel.offset = x.labelOffset + x.majorTickLength;
		newLabel.rotation = M_PI/4;
		[customLabels addObject:newLabel];
		[newLabel release];
	}
	x.axisLabels =  [NSSet setWithArray:customLabels];
	
	CPTXYAxis *y = axisSet.yAxis;
    y.axisLineStyle = nil;
    
    y.majorTickLineStyle = nil;
    y.minorTickLineStyle = nil;
    y.majorIntervalLength = CPTDecimalFromString(@"250");
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
	y.title = @"average daily calories";
	y.titleOffset = 50.0f;
    y.titleLocation = CPTDecimalFromInt(([n unsignedIntValue] - 850) / 2 + 850);
	
    // First bar plot
    CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor darkGrayColor] horizontalBars:NO];
    barPlot.baseValue = CPTDecimalFromString(@"0");
    barPlot.dataSource = self;
    barPlot.identifier = @"bmr";
    barPlot.barWidth = [[[[NSDecimalNumber alloc] initWithFloat:10.0f] autorelease] decimalValue];
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    
    // Second bar plot
    barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor greenColor] horizontalBars:NO];
    barPlot.dataSource = self;
    barPlot.baseValue = CPTDecimalFromString(@"0");
    barPlot.cornerRadius = 2.0f;
    barPlot.identifier = @"tdee";
    barPlot.barWidth = [[[[NSDecimalNumber alloc] initWithFloat:10.0f] autorelease] decimalValue];
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    
    barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
    barPlot.dataSource = self;
    barPlot.baseValue = CPTDecimalFromString(@"0");
    barPlot.cornerRadius = 2.0f;
    barPlot.identifier = @"minus1";
    barPlot.barWidth = [[[[NSDecimalNumber alloc] initWithFloat:10.0f] autorelease] decimalValue];
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    
    barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO];
    barPlot.dataSource = self;
    barPlot.baseValue = CPTDecimalFromString(@"0");
    barPlot.cornerRadius = 2.0f;
    barPlot.identifier = @"minus2";
    barPlot.barWidth = [[[[NSDecimalNumber alloc] initWithFloat:10.0f] autorelease] decimalValue];
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    
    return barChart;
}

#pragma mark -
#pragma mark Table view delegate

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

    BMRGraphViewController *vc = [[BMRGraphViewController alloc] initWithNibName:nibName 
                                                                          bundle:nil];
    
    vc.graph = [self createGraph];
    vc.userData = userData;
    
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    
    // TODO: use a popup on the iPad
}

#endif // PRO_VERSION

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
    
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] 
                                           init];
    NSLog(@"MFMailComposeViewController=%@", picker);
	picker.mailComposeDelegate = self;
    
	[picker setSubject:@"Fitness Nut: BMR & TDEE results"];
    
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
        
#ifdef PRO_VERSION
        CPTGraph *graph = [self createGraph];
        CGSize size = CGSizeMake(320, 480);
        UIGraphicsBeginImageContext(size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, 480);
        CGContextScaleCTM(context, 1, -1);
        graph.frame = CGRectMake(0, 0, 320, 480);
        [graph layoutAndRenderInContext:context];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        NSData *pngData = UIImagePNGRepresentation(image);
        [picker addAttachmentData:pngData mimeType:@"image/png" 
                         fileName:@"calories.png"];
        
        UIGraphicsEndImageContext();
        [graph release];
#endif
    }
    
    emailBody = [emailBody stringByAppendingFormat:@"</tbody></table><p>"
                 "Use <a href=\"%@\">Fitness Nut Pro</a> "
                 "for quick answers to your sports nutrition questions!"
                 "</p></body></html>",
                 kFITNESS_NUT_PRO_AFFILIATE_URL
                 ];
    
	[picker setMessageBody:emailBody isHTML:YES];
    
	[self presentModalViewController:picker animated:YES];
    [picker release];    
}

- (void)shareViaFacebook
{
//    NSURL *url = [NSURL URLWithString:kFITNESS_NUT_PRO_AFFILIATE_URL];
//    
//    NSString *bmr = [self calculateBMR];
//    NSString *tdee = [self calculateTDEE];
//    
//    NSString *text = [NSString stringWithFormat:@"I just calculated my BMR as %@", bmr];
//    if (tdee) {
//        text = [text stringByAppendingFormat:@" & my TDEE as %@", tdee];
//    }
//    text = [text stringByAppendingString:@" with Fitness Nut!"];
//    SHKItem *item = [SHKItem URL:url title:text];
//    [SHKFacebook shareItem:item];
//    
}

- (void)shareViaTwitter
{
    // Set up the built-in twitter composition view controller.
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    NSURL *url = [NSURL URLWithString:kFITNESS_NUT_PRO_AFFILIATE_URL];
       
    NSString *bmr = [self calculateBMR];
    NSString *tdee = [self calculateTDEE];
       
    NSString *text = [NSString stringWithFormat:@"I just calculated my BMR as %@", bmr];
    if (tdee) {
        text = [text stringByAppendingFormat:@" & my TDEE as %@", tdee];
    }
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

