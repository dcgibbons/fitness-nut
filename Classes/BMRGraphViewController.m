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


    // Create barChart from theme
    barChart = [[CPXYGraph alloc] initWithFrame:CGRectZero];
	CPTheme *theme = [CPTheme themeNamed:kCPDarkGradientTheme];
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
    plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1000.0f) length:CPDecimalFromFloat(2000.0f)];
    plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.0f) length:CPDecimalFromFloat(16.0f)];
    	
	CPXYAxisSet *axisSet = (CPXYAxisSet *)barChart.axisSet;
    CPXYAxis *x = axisSet.xAxis;
    x.axisLineStyle = nil;
    x.majorTickLineStyle = nil;
    x.minorTickLineStyle = nil;
    x.majorIntervalLength = CPDecimalFromString(@"5");
    x.orthogonalCoordinateDecimal = CPDecimalFromString(@"1000"); // Y position of the label?
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
		CPAxisLabel *newLabel = [[CPAxisLabel alloc] initWithText: [xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
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
    y.titleLocation = CPDecimalFromFloat(1850.0f);// in coordinates of the yRange? 
	
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
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInt:1727]; // BMR
            } else if ([plot.identifier isEqual:@"tdee"]) {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInt:2980]; // TDEE
            } else if ([plot.identifier isEqual:@"minus1"]) {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInt:2980-500]; // -1 lbs/week
            } else if ([plot.identifier isEqual:@"minus2"]) {
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInt:2980-1000]; // -2 lbs/week
            }
            break;
    }
    
    return num;
}

-(CPFill *) barFillForBarPlot:(CPBarPlot *)barPlot recordIndex:(NSNumber *)index; 
{
	return nil;
}

@end
