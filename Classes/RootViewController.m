//
//  RootViewController.m
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/01/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "RootViewController.h"
#import "ContentController.h"
#import "UpgradeBannerView.h"
#import "GANTracker.h"

@implementation RootViewController

- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation 
{
    if (adBannerView) {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierLandscape];
        } else {
            [adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
        }          

        CGFloat fullViewHeight = self.view.frame.size.height;
//        NSLog(@"fullViewHeight=%f", fullViewHeight);
        
        CGSize adBannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:adBannerView.currentContentSizeIdentifier];        
//        NSLog(@"adBannerSize=%f,%f", adBannerSize.width, adBannerSize.height);

        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];

        if (bannerIsVisible) {
            CGRect adBannerViewFrame = adBannerView.frame;
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = fullViewHeight - adBannerViewFrame.size.height;
            adBannerView.frame = adBannerViewFrame;
            
            CGRect tableViewFrame = menuTableView.frame;
            tableViewFrame.size.height = fullViewHeight - upgradeBannerView.frame.size.height - adBannerSize.height;
            menuTableView.frame = tableViewFrame;
        } else {
            // Move the banner view offscreen
            CGRect bannerFrame = self.adBannerView.frame;
            bannerFrame.origin.y = fullViewHeight;
            
            CGRect tableViewFrame = menuTableView.frame;
            tableViewFrame.size.height = fullViewHeight - upgradeBannerView.frame.size.height;
            menuTableView.frame = tableViewFrame;
        }
        
//        NSLog(@"menuTableView.frame=%f,%f,%f,%f", menuTableView.frame.origin.x,menuTableView.frame.origin.y,
//              menuTableView.frame.size.width,menuTableView.frame.size.height);
//        NSLog(@"adBannerView.frame=%f,%f,%f,%f", adBannerView.frame.origin.x,adBannerView.frame.origin.y,
//              adBannerView.frame.size.width,adBannerView.frame.size.height);
//        
        [UIView commitAnimations];
    } 
}

#pragma mark -
#pragma mark Properties

@synthesize userData, groups, menuTableView, adBannerView, bannerIsVisible, contentController;
@synthesize upgradeBannerView;

#pragma mark -
#pragma mark View Lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);

    self.title = @"Fitness Nut";

#ifndef PRO_VERSION
    // Create an ad banner just off the bottom of the view (i.e. not visible).
    self.bannerIsVisible = NO;
    adBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0,
                                                                  self.view.frame.size.height,
                                                                  0, 0)];
    adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    adBannerView.delegate=self;
    [self.view addSubview:adBannerView];
    
    UIView *v = [[UpgradeBannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.upgradeBannerView = [v retain];
    [v release];
    [self.view addSubview:upgradeBannerView];
    
    CGFloat fullViewHeight = self.view.frame.size.height;
    CGRect tableFrame = self.menuTableView.frame;
    CGRect bannerFrame = self.upgradeBannerView.frame;
    
    // Shrink the tableview to create space for banner
    tableFrame.size.height = fullViewHeight - bannerFrame.size.height;
    tableFrame.origin.y = bannerFrame.size.height;
    
    self.menuTableView.frame = tableFrame;
    self.upgradeBannerView.frame = bannerFrame;        
#endif

    NSArray *nutritionMenuItems = [NSArray arrayWithObjects:
                                   
                                   [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"BMR & TDEE", @"title",
                                    @"basic daily calorie needs", @"subtitle",
                                    @"BMRViewController", @"viewClass",
                                    nil],
                                   
                                   [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"Macronutrients", @"title",
                                    @"carbohydrate, protein and fat requirements based upon training load", @"subtitle",
                                    @"MacronutrientNeedsViewController", @"viewClass",
                                    nil],
                                   
                                   nil];
    
    NSArray *bodyCompMenuItems = [NSArray arrayWithObjects:
                                  
                                  [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"Body Fat Estimation", @"title",
                                   @"estimate body fat based on body dimensions", @"subtitle",
                                   @"BodyFatEstimatorViewController", @"viewClass",
                                   nil],
                                  
                                  [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"Weight Predictor", @"title",
                                   @"predict weight based on body fat changes", @"subtitle",
                                   @"WeightPredictorViewController", @"viewClass",
                                   nil],
                                  
                                  nil];
    
    NSArray *a = [NSArray arrayWithObjects:nutritionMenuItems, bodyCompMenuItems, nil];
    self.groups = a;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations.
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self fixupAdView:[UIDevice currentDevice].orientation];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear!!");

    if (!IS_PAD_DEVICE()) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }

#ifndef PRO_VERSION
    NSNumber *seenUpgradeNotice = [userData objectForKey:@"seenUpgradeNotice"];
    if (!seenUpgradeNotice) {
        NSString *msg = @"For additional features, such as the ability to e-mail your calculations, "
        "full-screen iPad support, and no advertisements, check out Fitness Nut Pro!";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fitness Nut Pro" 
                                                            message:msg 
                                                           delegate:self 
                                                  cancelButtonTitle:@"Not yet." 
                                                  otherButtonTitles:@"Yes!", nil
                                  ];
        [alertView show];
        [alertView release];
        [userData setObject:[NSNumber numberWithUnsignedInt:1] forKey:@"seenUpgradeNotice"];
    }
#endif
}

- (void)viewDidAppear:(BOOL)animated
{
#ifndef PRO_VERSION
    [self fixupAdView:[UIDevice currentDevice].orientation];
#endif
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
#ifndef PRO_VERSION
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/us/app/fitness-nut-pro/id424734288?mt=8&ls=1"];
        [[UIApplication sharedApplication] openURL:url];        
    }
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (!IS_PAD_DEVICE()) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.userData = nil;
    self.menuTableView = nil;
    self.adBannerView.delegate = nil;
    self.adBannerView = nil;
    self.upgradeBannerView = nil;
}

- (void)dealloc
{
    adBannerView.delegate=nil;
    [adBannerView release];
    [upgradeBannerView release];
    [userData release];
    [menuTableView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table View DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    int section = [indexPath section];
    int row = [indexPath row];
    NSArray *group = [self.groups objectAtIndex:section];
    NSDictionary *d = [group objectAtIndex:row];
    
    cell.textLabel.text = [d objectForKey:@"title"];
    cell.detailTextLabel.text = [d objectForKey:@"subtitle"];
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.detailTextLabel.numberOfLines = 0;    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (IS_PAD_DEVICE()) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: do this better. I hate this. I hate it! I hate me. You wrote shit! Don't write shit.
    // On the other hand, it works and I haven't had to think about it since.
    NSString *cellText = @"Go get some text for your cell.";
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize 
                                lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height + 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.groups objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.groups count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    switch (section) {
        case 0:
            title = @"Nutrition";
            break;
        case 1:
            title = @"Body Composition";
            break;
    }
    return title;
}


#pragma mark -
#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    int section = [indexPath section];
    int row = [indexPath row];
    
    NSDictionary *d = [[self.groups objectAtIndex:section] objectAtIndex:row];
    NSString *viewClassName = [d objectForKey:@"viewClass"];
    
    if (viewClassName) {
        NSError *error;
        if (![[GANTracker sharedTracker] 
              trackPageview:[NSString stringWithFormat:@"/%@", viewClassName]
                                             withError:&error]) {
            NSLog(@"Unable to track page view for %@, %@", viewClassName, 
                  error);
        }
        
        DetailViewController *controller = [[NSClassFromString(viewClassName) alloc] 
                                            initWithNibName:viewClassName bundle:nil];
        [controller performSelector:@selector(setUserData:) withObject:self.userData];
        
        self.contentController.detailViewController = controller;
        [controller release];
    }
}

#pragma mark -
#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!bannerIsVisible) {
        bannerIsVisible = YES;
        [self fixupAdView:[UIDevice currentDevice].orientation];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"adBanner didFailToReceiveAdWithError, error=%@\n", error);
    
    if (bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Grow the tableview to occupy space left by banner
        CGFloat fullViewHeight = self.view.frame.size.height;
        CGRect tableFrame = self.menuTableView.frame;
        tableFrame.size.height = fullViewHeight - upgradeBannerView.frame.size.height;
        
        // Move the banner view offscreen
        CGRect bannerFrame = self.adBannerView.frame;
        bannerFrame.origin.y = fullViewHeight;
        
        self.menuTableView.frame = tableFrame;
        self.adBannerView.frame = bannerFrame;
        
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

@end

