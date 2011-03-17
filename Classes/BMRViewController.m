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
#import "BMRGraphViewController.h"
#import "GANTracker.h"

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
    
#ifdef PRO_VERSION
    [self.navigationController setToolbarHidden:NO animated:YES];
#endif

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
    NSNumber *tdeeNumber = [NSNumber numberWithInt:tdee];
    [userData setObject:tdeeNumber forKey:@"athleteTDEE"];
    
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
    [super emailResults:sender];
    
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;

	[picker setSubject:@"Fitness Nut Pro: BMR & TDEE results"];
    
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
    
        CPXYGraph *graph = [self createGraph];
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
    }
    
    emailBody = [emailBody stringByAppendingString:@"</tbody></table><p>"
                 "Use <a href=\"http://itunes.apple.com/us/app/fitness-nut-pro/id424734288?mt=8\">Fitness Nut Pro</a> "
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

#ifdef PRO_VERSION

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
    return 1;
}

-(NSNumber *)numberForPlot:(CPPlot *)plot 
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
        case CPBarPlotFieldBarLocation:
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
        case CPBarPlotFieldBarLength:
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

-(CPFill *) barFillForBarPlot:(CPBarPlot *)barPlot recordIndex:(NSNumber *)index; 
{
	return nil;
}

- (CPXYGraph *)createGraph
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
    CPXYGraph *barChart;
    barChart = [[CPXYGraph alloc] initWithFrame:CGRectZero];
	CPTheme *theme = [CPTheme themeNamed:kCPDarkGradientTheme];
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
    CPTextStyle *textStyle = [CPTextStyle textStyle];
    textStyle.color = [CPColor grayColor];
    textStyle.fontSize = 16.0f;
    barChart.titleTextStyle = textStyle;
    barChart.titleDisplacement = CGPointMake(0.0f, -20.0f);
    barChart.titlePlotAreaFrameAnchor = CPRectAnchorTop;
	
	// Add plot space for horizontal bar charts
    CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)barChart.defaultPlotSpace;
    plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromInt(850) 
                                                   length:CPDecimalFromInt([n unsignedIntValue] - 850)];
    plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.0f) 
                                                   length:CPDecimalFromFloat(16.0f)];
    
	CPXYAxisSet *axisSet = (CPXYAxisSet *)barChart.axisSet;
    CPXYAxis *x = axisSet.xAxis;
    x.axisLineStyle = nil;
    x.majorTickLineStyle = nil;
    x.minorTickLineStyle = nil;
    x.majorIntervalLength = CPDecimalFromString(@"5");
    x.orthogonalCoordinateDecimal = CPDecimalFromString(@"850"); // Y position of the label?
	x.title = @"";
    x.titleLocation = CPDecimalFromFloat(7.5f);
	x.titleOffset = 55.0f;
	
	// Define some custom labels for the data elements
	x.labelRotation = M_PI/4;
	x.labelingPolicy = CPAxisLabelingPolicyNone;
	NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:1], [NSDecimalNumber numberWithInt:5], [NSDecimalNumber numberWithInt:10], [NSDecimalNumber numberWithInt:15], nil];
	NSArray *xAxisLabels = [NSArray arrayWithObjects:@"BMR", @"TDEE", @"-1 lbs/week", @"-2 lbs/week", nil];
	NSUInteger labelLocation = 0;
	NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
	for (NSNumber *tickLocation in customTickLocations) {
		CPAxisLabel *newLabel = [[CPAxisLabel alloc] initWithText:[xAxisLabels objectAtIndex:labelLocation++] 
                                                        textStyle:x.labelTextStyle];
		newLabel.tickLocation = [tickLocation decimalValue];
		newLabel.offset = x.labelOffset + x.majorTickLength;
		newLabel.rotation = M_PI/4;
		[customLabels addObject:newLabel];
		[newLabel release];
	}
	x.axisLabels =  [NSSet setWithArray:customLabels];
	
	CPXYAxis *y = axisSet.yAxis;
    y.axisLineStyle = nil;
    
    y.majorTickLineStyle = nil;
    y.minorTickLineStyle = nil;
    y.majorIntervalLength = CPDecimalFromString(@"250");
    y.orthogonalCoordinateDecimal = CPDecimalFromString(@"0");
	y.title = @"average daily calories";
	y.titleOffset = 50.0f;
    y.titleLocation = CPDecimalFromInt(([n unsignedIntValue] - 850) / 2 + 850);
	
    // First bar plot
    CPBarPlot *barPlot = [CPBarPlot tubularBarPlotWithColor:[CPColor darkGrayColor] horizontalBars:NO];
    barPlot.baseValue = CPDecimalFromString(@"0");
    barPlot.dataSource = self;
    barPlot.identifier = @"bmr";
    barPlot.barWidth = 10.0f;
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    
    // Second bar plot
    barPlot = [CPBarPlot tubularBarPlotWithColor:[CPColor greenColor] horizontalBars:NO];
    barPlot.dataSource = self;
    barPlot.baseValue = CPDecimalFromString(@"0");
    barPlot.cornerRadius = 2.0f;
    barPlot.identifier = @"tdee";
    barPlot.barWidth = 10.0f;
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    
    barPlot = [CPBarPlot tubularBarPlotWithColor:[CPColor blueColor] horizontalBars:NO];
    barPlot.dataSource = self;
    barPlot.baseValue = CPDecimalFromString(@"0");
    barPlot.cornerRadius = 2.0f;
    barPlot.identifier = @"minus1";
    barPlot.barWidth = 10.0f;
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    
    barPlot = [CPBarPlot tubularBarPlotWithColor:[CPColor redColor] horizontalBars:NO];
    barPlot.dataSource = self;
    barPlot.baseValue = CPDecimalFromString(@"0");
    barPlot.cornerRadius = 2.0f;
    barPlot.identifier = @"minus2";
    barPlot.barWidth = 10.0f;
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    
    return barChart;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"calculate"
                                         action:@"view_bmr_graph"
                                          label:@""
                                          value:-1
                                      withError:&error]) {
        NSLog(@"Unable to track calculate event for view_bmr_graph, %@",
              error);
    }
    
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
#endif

@end

