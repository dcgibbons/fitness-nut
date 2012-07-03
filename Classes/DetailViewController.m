//
//  DetailViewController.m
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/28/2011.
//  Copyright 2011-2012 Nuclear Bunny Studios, LLC. All rights reserved.
//

#import "DetailViewController.h"
#import "AthleteDataProtocol.h"
#import "SecondaryDetailViewController.h"
#import "GANTracker.h"

@implementation DetailViewController
@synthesize userData, popoverController, tableView, sections, adBannerView, bannerIsVisible;

- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation 
{
    if (adBannerView) {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierLandscape];
        } else {
            [adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
        }          
        
        CGFloat fullViewHeight = self.view.frame.size.height;
        
        CGSize adBannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:adBannerView.currentContentSizeIdentifier];
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        
        if (bannerIsVisible) {
            CGRect adBannerViewFrame = adBannerView.frame;
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = fullViewHeight - adBannerViewFrame.size.height;
            adBannerView.frame = adBannerViewFrame;
            
            CGRect tableViewFrame = tableView.frame;
            tableViewFrame.size.height = fullViewHeight - adBannerSize.height;
            tableView.frame = tableViewFrame;
        } else {
            CGRect adBannerViewFrame = adBannerView.frame;
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = fullViewHeight - adBannerSize.height;
            adBannerView.frame = adBannerViewFrame;
            
            CGRect tableViewFrame = tableView.frame;
            tableViewFrame.size.height = fullViewHeight - tableViewFrame.origin.y;
            tableView.frame = tableViewFrame;
        }
        
        [UIView commitAnimations];
    } 
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#ifndef PRO_VERSION
    if (NSClassFromString(@"ADBannerView")) {
        // Create an ad banner just off the bottom of the view (i.e. not visible).
        self.bannerIsVisible=NO;    
        adBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0,
                                                                      self.view.frame.size.height,
                                                                      0, 0)];
        // TODO: use new identifier once we stop supporting old releases
        adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:
                                                       ADBannerContentSizeIdentifierLandscape,
                                                       ADBannerContentSizeIdentifierPortrait,
                                                       nil];
        adBannerView.delegate=self;
        [self.view addSubview:adBannerView];
    }
#endif

//#ifdef PRO_VERSION
    self.navigationController.toolbarHidden = YES;
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                               target:self
                                                                               action:@selector(share:)];
    self.toolbarItems = [NSArray arrayWithObjects:shareItem, nil];
    [shareItem release];
    
//#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [self fixupAdView:[UIDevice currentDevice].orientation];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
    self.adBannerView.delegate = nil;
    self.adBannerView = nil;
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

- (void)dealloc 
{
    adBannerView.delegate = nil;
    [adBannerView release];
    [super dealloc];
}

- (void)splitViewController:(UISplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem*)barButtonItem 
       forPopoverController:(UIPopoverController*)pc
{  
    [barButtonItem setTitle:@"Root List"];
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
    self.popoverController = pc;
}


- (void)splitViewController:(UISplitViewController*)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [[self navigationItem] setLeftBarButtonItem:nil];
    self.popoverController = nil;
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
    return [[[sections objectAtIndex:section] objectForKey:@"rows"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return [[sections objectAtIndex:section] objectForKey:@"sectionTitle"];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    int section = [indexPath section];
    int row = [indexPath row];
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *rowDict = [[[sections objectAtIndex:section] objectForKey:@"rows"] 
                             objectAtIndex:row];
    
    cell.textLabel.text = [rowDict objectForKey:@"title"];
    
    NSString *dataKey = [rowDict objectForKey:@"dataName"];
    if (dataKey) {
        NSString *desc = [[userData objectForKey:dataKey] description];
        cell.detailTextLabel.text = desc;
    } else {
        NSString *selector = [rowDict objectForKey:@"selector"];
        if (selector) {
            cell.detailTextLabel.text = [self performSelector:NSSelectorFromString(selector)];
        }
    }
    
    NSString *detailDisclosureKey = [rowDict objectForKey:@"detailDisclosureView"];
    if (detailDisclosureKey && cell.detailTextLabel.text) {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    NSString *viewClassName = [rowDict objectForKey:@"viewController"];
    if (viewClassName) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // NO-OP - be lazy and let the subclasses deal with this
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Navigation logic may go here. Create and push another view controller.
    
    int section = [indexPath section];
    int row = [indexPath row];
    
    NSDictionary *rowDict = [[[sections objectAtIndex:section] objectForKey:@"rows"] 
                             objectAtIndex:row];
    
    NSString *viewClassName = [rowDict objectForKey:@"viewController"];
    if (!viewClassName) return;
    
#ifndef DEBUG
    NSError *error;
    NSString *path = [NSString stringWithFormat:@"/%@/%@",
                      NSStringFromClass([self class]),
                      viewClassName];
    if (![[GANTracker sharedTracker] trackPageview:path withError:&error]) {
        NSLog(@"Unable to track page view for %@, %@", viewClassName, 
              error);
    }
#endif
    
    NSString *nibName = viewClassName;
        
    SecondaryDetailViewController *detailViewController = [[NSClassFromString(viewClassName) alloc]
                                                           initWithNibName:nibName bundle:nil];
    
    detailViewController.inputDelegate = self;
    
    // TODO: BOGUS design, use a datasource instead?
    NSString *dataName = [rowDict objectForKey:@"dataName"];
    if ([detailViewController conformsToProtocol:@protocol(AthleteDataProtocol)]) {
        id <AthleteDataProtocol> p = (id<AthleteDataProtocol>)detailViewController;
        [p setDataName:dataName];
        [p setData:[userData objectForKey:dataName]];
    }
    [detailViewController performSelector:@selector(setDelegate:) withObject:self];
    
    // Pass the selected object to the new view controller.
    // TODO: delegate this stuff to the contentcontroller for consistency?
    if (IS_PAD_DEVICE() && [detailViewController shouldShowInPopover]) {
        // Create a navigation controller to contain the recent searches controller, and create the popover controller to contain the navigation controller.
        UINavigationController *navigationController = [[UINavigationController alloc] 
                                                        initWithRootViewController:detailViewController];
        
        if (!popoverController) {
            UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:navigationController];
            self.popoverController = pc;
            [pc release];
        } else {
            self.popoverController.popoverContentSize = CGSizeZero;
            self.popoverController.contentViewController = navigationController;
        }
        
        navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.popoverController.delegate = self;
        
        CGRect rect = [aTableView rectForRowAtIndexPath:indexPath];
        [popoverController presentPopoverFromRect:rect 
                                           inView:self.view 
                         permittedArrowDirections:UIPopoverArrowDirectionAny 
                                         animated:YES];
    } else {
#ifdef PRO_VERSION
        self.navigationController.toolbarHidden = YES;
#endif    
        [self.navigationController pushViewController:detailViewController 
                                             animated:YES];
    }
    
    [detailViewController release];
}

#pragma mark -
#pragma mark UIPopoverControllerDelegate methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)aPopoverController
{
    UIViewController *contentViewController = aPopoverController.contentViewController;
    if ([contentViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)contentViewController;
        contentViewController = navController.visibleViewController;
    }
    
    if ([contentViewController isKindOfClass:[SecondaryDetailViewController class]]) {
        SecondaryDetailViewController *vc = (SecondaryDetailViewController *)contentViewController;
        [vc done:self];
    }
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return YES;
}

#pragma mark -
#pragma mark SecondaryDetailInputDelegate methods

- (void)didDismissInputView:(SecondaryDetailViewController *)aViewController
{
    if (IS_PAD_DEVICE() && [aViewController shouldShowInPopover]) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
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
    if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Grow the tableview to occupy space left by banner
        CGFloat fullViewHeight = self.view.frame.size.height;
        CGRect tableFrame = self.tableView.frame;
        tableFrame.size.height = fullViewHeight;
        
        // Move the banner view offscreen
        CGRect bannerFrame = self.adBannerView.frame;
        bannerFrame.origin.y = fullViewHeight;
        
        self.tableView.frame = tableFrame;
        self.adBannerView.frame = bannerFrame;
        
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

#pragma mark -
#pragma mark Athlete Data delegate

- (void)athleteDataInputDone:(UIViewController *)viewController
               withDataNamed:(NSString *)dataName
               withDataValue:(id)data
{
    [userData setObject:data forKey:dataName];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UI Actions

- (void)share:(id)sender
{
#ifndef DEBUG
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"calculate"
                                         action:@"share"
                                          label:NSStringFromClass([self class])
                                          value:-1
                                      withError:&error]) {
        NSLog(@"Unable to track calculate event for share, %@",
              error);
    }
#endif
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Email", 
                                  //                                  @"Facebook", 
                                  @"Twitter", 
                                  nil];
    
    [actionSheet showFromToolbar:self.navigationController.toolbar];
    [actionSheet release];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: { // email
#ifndef DEBUG
            NSError *error;
            if (![[GANTracker sharedTracker] trackEvent:@"calculate"
                                                 action:@"share_via_email"
                                                  label:NSStringFromClass([self class])
                                                  value:-1
                                              withError:&error]) {
                NSLog(@"Unable to track calculate event for share, %@",
                      error);
            }
#endif
            [self shareViaEmail];
            break;
        }
//        case 1: { // facebook
//#ifndef DEBUG
//            NSError *error;
//            if (![[GANTracker sharedTracker] trackEvent:@"calculate"
//                                                 action:@"share_via_facebook"
//                                                  label:NSStringFromClass([self class])
//                                                  value:-1
//                                              withError:&error]) {
//                NSLog(@"Unable to track calculate event for share, %@",
//                      error);
//            }
//#endif
//            [self shareViaFacebook];
//            break;
//        }
        case 1: { // twitter
#ifndef DEBUG
            NSError *error;
            if (![[GANTracker sharedTracker] trackEvent:@"calculate"
                                                 action:@"share_via_twitter"
                                                  label:NSStringFromClass([self class])
                                                  value:-1
                                              withError:&error]) {
                NSLog(@"Unable to track calculate event for share, %@",
                      error);
            }
#endif
            [self shareViaTwitter];
            break;
        }
        default: // cancel
            break;
    }
}

#pragma mark -
#pragma mark Sharing

- (void)shareViaEmail 
{
    // NO-OP
}

//- (void)shareViaFacebook
//{
//    // NO-OP
//}

- (void)shareViaTwitter
{    
    // NO-OP
}

@end
