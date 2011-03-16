//
//  BMRGraphViewController.m
//  Fitness Nut
//
//  Created by Chad Gibbons on 03/13/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BMRGraphViewController.h"


@implementation BMRGraphViewController
@synthesize userData, graph;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)dealloc
{
    [graph release];
    [userData release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView
//{
//}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create barChart from theme
    CPXYGraph *barChart;

    barChart = [[CPXYGraph alloc] initWithFrame:CGRectZero];
	CPTheme *theme = [CPTheme themeNamed:kCPDarkGradientTheme];
//	CPTheme *theme = [CPTheme themeNamed:kCPSlateTheme];
    [barChart applyTheme:theme];
    
	CPGraphHostingView *hostingView = (CPGraphHostingView *)self.view;
    hostingView.hostedGraph = barChart;
    
    // Border
    barChart.plotAreaFrame.borderLineStyle = nil;
    barChart.plotAreaFrame.cornerRadius = 0.0f;
	
    // Paddings
    barChart.paddingLeft = 0.0f;
    barChart.paddingRight = 0.0f;
    barChart.paddingTop = 0.0f;
    barChart.paddingBottom = 0.0f;

    barChart.plotAreaFrame.paddingLeft = 70.0;
	barChart.plotAreaFrame.paddingTop = 25.0;
	barChart.plotAreaFrame.paddingRight = 20.0;
	barChart.plotAreaFrame.paddingBottom = 80.0;

    // Chart Title
    barChart.title = @"Daily Calorie Ranges";
    CPTextStyle *textStyle = [CPTextStyle textStyle];
    textStyle.color = [CPColor grayColor];
    textStyle.fontSize = 16.0f;
    barChart.titleTextStyle = textStyle;
    barChart.titleDisplacement = CGPointMake(0.0f, -20.0f);
    barChart.titlePlotAreaFrameAnchor = CPRectAnchorTop;
    
	// Plot Space - X,Y coordinate system for the plots
    CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)barChart.defaultPlotSpace;
    plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.0f)
                                                   length:CPDecimalFromFloat(16.0f)];
    
    plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1000.0f)
                                                   length:CPDecimalFromFloat(2000.0f)];
    
    
    // Plot Axis
    CPXYAxisSet *axisSet = (CPXYAxisSet *)barChart.axisSet;
    
    CPXYAxis *x = axisSet.xAxis;
//    x.axisLineStyle = nil;
//    x.majorTickLineStyle = nil;
//    x.minorTickLineStyle = nil;
//    x.majorIntervalLength = CPDecimalFromString(@"1");
//    x.orthogonalCoordinateDecimal = CPDecimalFromString(@"0");
//    x.titleLocation = CPDecimalFromFloat(2.5f);
	x.titleOffset = 20.0f;
	x.title = @"X Axis";
    x.majorIntervalLength = CPDecimalFromInt(1);
    x.labelingPolicy = CPAxisLabelingPolicyAutomatic;
    x.orthogonalCoordinateDecimal = CPDecimalFromFloat(25.0f);
	// Define some custom labels for the data elements
//	x.labelRotation = M_PI/4;
//	x.labelingPolicy = CPAxisLabelingPolicyNone;
//	NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:1], [NSDecimalNumber numberWithInt:5], nil];
//	NSArray *xAxisLabels = [NSArray arrayWithObjects:@"BMR", @"TDEE", nil];
//	NSUInteger labelLocation = 0;
//	NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
//	for (NSNumber *tickLocation in customTickLocations) {
//		CPAxisLabel *newLabel = [[CPAxisLabel alloc] initWithText:[xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
//		newLabel.tickLocation = [tickLocation decimalValue];
//		newLabel.offset = x.labelOffset + x.majorTickLength;
//		newLabel.rotation = M_PI/4;
//		[customLabels addObject:newLabel];
//		[newLabel release];
//	}    
//    x.axisLabels = [NSSet setWithArray:customLabels];

    CPXYAxis *y = axisSet.yAxis;
    y.axisLineStyle = nil;
    y.majorTickLineStyle = nil;
    y.minorTickLineStyle = nil;
    y.majorIntervalLength = CPDecimalFromString(@"250");
    y.orthogonalCoordinateDecimal = CPDecimalFromString(@"0");
	y.title = @"calories";
	y.titleOffset = 45.0f;
    y.titleLocation = CPDecimalFromFloat(150.0f);  

    CPBarPlot *barPlot = [[CPBarPlot alloc] init];
    barPlot.identifier = @"bmr";
    barPlot.baseValue = CPDecimalFromString(@"0");
    barPlot.dataSource = self;
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    [barPlot release];

    barPlot = [[CPBarPlot alloc] init];
    barPlot.identifier = @"tdee";
    barPlot.baseValue = CPDecimalFromString(@"0");
    barPlot.dataSource = self;
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    [barPlot release];
    
    self.graph = barChart;
    [barChart release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.userData = nil;
    self.graph = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark - CPPDataSource methods


#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
    return 1;
}

-(NSNumber *)numberForPlot:(CPPlot *)plot 
                     field:(NSUInteger)fieldEnum 
               recordIndex:(NSUInteger)index 
{
    NSDecimalNumber *num = nil;
    
    switch (fieldEnum)
    {
        case CPBarPlotFieldBarLocation:
//            num = (NSDecimalNumber *)[NSDecimalNumber numberWithFloat:0.5];
            if ([plot.identifier isEqual:@"bmr"]) {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithInt:1];
            } else if ([plot.identifier isEqual:@"tdee"]) {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithInt:5];
            }
            break;
        case CPBarPlotFieldBarLength:
            if ([plot.identifier isEqual:@"bmr"]) {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInt:1727]; // BMR
            } else if ([plot.identifier isEqual:@"tdee"]) {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInt:2980]; // TDEE
            }
            break;
//
//            switch (index) {
//                case 0:
//                case 1:
//                    num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInt:1500]; // Daily minimum for sex
//                    break;
//                case 2:
//                    num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInt:2980]; // TDEE
//                    break;
//                case 3:
//                    num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInt:2480]; // -1 lbs
//                    break;
//                case 4:
//                    num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInt:1980]; // -2 lbs
//                    break;
//                case 5:
//                    num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInt:3480]; // +1 lbs
//                    break;
//                case 6:
//                    num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInt:3980]; // +2 lbs
//                    break;
//            }
//            break;
    }
    
    return num;
}

-(CPFill *) barFillForBarPlot:(CPBarPlot *)barPlot recordIndex:(NSNumber *)index; 
{
	return nil;
}

@end
