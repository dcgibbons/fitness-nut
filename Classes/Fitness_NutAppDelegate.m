//
//  Fitness_NutAppDelegate.m
//  Fitness Nut
//
//  Created by Chad Gibbons on 02/01/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "Fitness_NutAppDelegate.h"
#import "AthleteAge.h"
#import "AthleteBodyFat.h"
#import "AthleteHeight.h"
#import "AthleteWeight.h"
#import "AthleteGender.h"
#import "AthleteActivityLevel.h"
#import "AthleteMeasurement.h"
#import "AthleteType.h"

#import "GANTracker.h"
#import "ReviewRequest.h"

@implementation Fitness_NutAppDelegate

// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 10;

@synthesize userData;
@synthesize window;
@synthesize contentController;

- (BOOL)isPadDevice 
{
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

- (void)loadUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *seenUpgradeNotice = [defaults objectForKey:@"seenUpgradeNotice"];
    if (seenUpgradeNotice) {
        [userData setObject:seenUpgradeNotice forKey:@"seenUpgradeNotice"];
    }
    
    NSNumber *age = [defaults objectForKey:@"athleteAge"];
    if (age) {
        AthleteAge *athleteAge = [[[AthleteAge alloc] initWithAge:[age intValue]] autorelease];
        [userData setObject:athleteAge forKey:@"athleteAge"];
    }
    
    NSNumber *height = [defaults objectForKey:@"athleteHeight"];
    NSNumber *heightUnits = [defaults objectForKey:@"athleteHeightUnits"];
    if (height && heightUnits) {
        AthleteHeight *athleteHeight = [[[AthleteHeight alloc] initWithHeight:height 
                                                                   usingUnits:[heightUnits intValue]] 
                                        autorelease];
        [userData setObject:athleteHeight forKey:@"athleteHeight"];
    }
    
    NSNumber *weight = [defaults objectForKey:@"athleteWeight"];
    NSNumber *weightUnits = [defaults objectForKey:@"athleteWeightUnits"];
    if (weight && weightUnits) {
        AthleteWeight *athleteWeight = [[[AthleteWeight alloc] initWithWeight:weight 
                                                                   usingUnits:[weightUnits intValue]] 
                                        autorelease];
        [userData setObject:athleteWeight forKey:@"athleteWeight"];
    }
    
    NSNumber *gender = [defaults objectForKey:@"athleteGender"];
    if (gender) {
        AthleteGender *athleteGender = [[[AthleteGender alloc] init] autorelease];
        athleteGender.gender = [gender intValue];
        [userData setObject:athleteGender forKey:@"athleteGender"];
    }
    
    NSNumber *activityLevel = [defaults objectForKey:@"athleteActivityLevel"];
    if (activityLevel) {
        AthleteActivityLevel *athleteActivityLevel = [[[AthleteActivityLevel alloc] init] autorelease];
        athleteActivityLevel.activityLevel = [activityLevel intValue];
        [userData setObject:athleteActivityLevel forKey:@"athleteActivityLevel"];
    }
    
    NSNumber *type = [defaults objectForKey:@"athleteType"];
    if (type) {
        AthleteType *athleteType = [[AthleteType alloc] init];
        athleteType.athleteType = [type intValue];
        [userData setObject:athleteType forKey:@"athleteType"];
    }
    
    NSNumber *athleteHours = [defaults objectForKey:@"athleteHours"];
    if (athleteHours) {
        [userData setObject:athleteHours forKey:@"athleteHours"];
    }
    
    NSNumber *neckGirth = [defaults objectForKey:@"athleteNeckGirth"];
    NSNumber *neckGirthUnits = [defaults objectForKey:@"athleteNeckGirthUnits"];
    if (neckGirth && neckGirthUnits) {
        AthleteMeasurement *athleteNeckGirth = [[[AthleteMeasurement alloc] 
                                                 initWithMeasurement:neckGirth 
                                                 usingUnits:[neckGirthUnits intValue]] 
                                                autorelease];
        [userData setObject:athleteNeckGirth forKey:@"athleteNeckGirth"];
    }
    
    NSNumber *waistGirth = [defaults objectForKey:@"athleteWaistGirth"];
    NSNumber *waistGirthUnits = [defaults objectForKey:@"athleteWaistGirthUnits"];
    if (waistGirth && waistGirthUnits) {
        AthleteMeasurement *athleteWaistGirth = [[[AthleteMeasurement alloc] 
                                                  initWithMeasurement:waistGirth 
                                                  usingUnits:[waistGirthUnits intValue]] 
                                                 autorelease];
        [userData setObject:athleteWaistGirth forKey:@"athleteWaistGirth"];
    }
    
    NSNumber *hipsGirth = [defaults objectForKey:@"athleteHipsGirth"];
    NSNumber *hipsGirthUnits = [defaults objectForKey:@"athleteHipsGirthUnits"];
    if (hipsGirth && hipsGirthUnits) {
        AthleteMeasurement *athleteHipsGirth = [[[AthleteMeasurement alloc] 
                                                 initWithMeasurement:hipsGirth 
                                                 usingUnits:[hipsGirthUnits intValue]] 
                                                autorelease];
        [userData setObject:athleteHipsGirth forKey:@"athleteHipsGirth"];
    }
    
    NSNumber *athleteBodyFat = [defaults objectForKey:@"athleteBodyFat"];
    if (athleteBodyFat) {
        AthleteBodyFat *bodyFat = [[[AthleteBodyFat alloc] initWithBodyFat:athleteBodyFat] autorelease];
        [userData setObject:bodyFat forKey:@"athleteBodyFat"];
    }
    
    NSNumber *desiredBodyFat = [defaults objectForKey:@"desiredBodyFat"];
    if (desiredBodyFat) {
        AthleteBodyFat *bodyFat = [[[AthleteBodyFat alloc] initWithBodyFat:desiredBodyFat] autorelease];
        [userData setObject:bodyFat forKey:@"desiredBodyFat"];
    }
}

- (void)saveUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *seenUpgradeNotice = [userData objectForKey:@"seenUpgradeNotice"];
    if (seenUpgradeNotice) {
        [defaults setObject:seenUpgradeNotice forKey:@"seenUpgradeNotice"];
    }
    
    AthleteAge *age = [userData objectForKey:@"athleteAge"];
    if (age) {
        [defaults setObject:[NSNumber numberWithInt:age.age] forKey:@"athleteAge"];
    }
    
    AthleteHeight *height = [userData objectForKey:@"athleteHeight"];
    if (height) {
        [defaults setObject:height.height forKey:@"athleteHeight"];
        [defaults setObject:[NSNumber numberWithInt:height.units] forKey:@"athleteHeightUnits"];
    }
    
    AthleteWeight *weight = [userData objectForKey:@"athleteWeight"];
    if (weight) {
        [defaults setObject:weight.weight forKey:@"athleteWeight"];
        [defaults setObject:[NSNumber numberWithInt:weight.units] forKey:@"athleteWeightUnits"];
    }
    
    AthleteGender *gender = [userData objectForKey:@"athleteGender"];
    if (gender) {
        [defaults setObject:[NSNumber numberWithInt:gender.gender] forKey:@"athleteGender"];
    }
    
    AthleteActivityLevel *activityLevel = [userData objectForKey:@"athleteActivityLevel"];
    if (activityLevel) {
        [defaults setObject:[NSNumber numberWithInt:activityLevel.activityLevel]
                     forKey:@"athleteActivityLevel"];
    }
    
    AthleteType *athleteType = [userData objectForKey:@"athleteType"];
    if (athleteType) {
        [defaults setObject:[NSNumber numberWithInt:athleteType.athleteType] 
                                             forKey:@"athleteType"];
    }
         
    NSNumber *athleteHours = [userData objectForKey:@"athleteHours"];
    if (athleteHours) {
        [defaults setObject:athleteHours forKey:@"athleteHours"];
    }
    
    AthleteMeasurement *neckGirth = [userData objectForKey:@"athleteNeckGirth"];
    if (neckGirth) {
        [defaults setObject:neckGirth.measurement forKey:@"athleteNeckGirth"];
        [defaults setObject:[NSNumber numberWithInt:neckGirth.units] 
                     forKey:@"athleteNeckGirthUnits"];
    }
    
    AthleteMeasurement *waistGirth = [userData objectForKey:@"athleteWaistGirth"];
    if (waistGirth) {
        [defaults setObject:waistGirth.measurement forKey:@"athleteWaistGirth"];
        [defaults setObject:[NSNumber numberWithInt:waistGirth.units] 
                     forKey:@"athleteWaistGirthUnits"];
    }
    
    AthleteMeasurement *hipsGirth = [userData objectForKey:@"athleteHipsGirth"];
    if (hipsGirth) {
        [defaults setObject:hipsGirth.measurement forKey:@"athleteHipsGirth"];
        [defaults setObject:[NSNumber numberWithInt:hipsGirth.units] 
                     forKey:@"athleteHipsGirthUnits"];
    }
    
    AthleteBodyFat *athleteBodyFat = [userData objectForKey:@"athleteBodyFat"];
    if (athleteBodyFat) {
        [defaults setObject:athleteBodyFat.bodyFat forKey:@"athleteBodyFat"];
    }
    
    AthleteBodyFat *desiredBodyFat = [userData objectForKey:@"desiredBodyFat"];
    if (desiredBodyFat) {
        [defaults setObject:desiredBodyFat.bodyFat forKey:@"desiredBodyFat"];
    }
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    // Override point for customization after application launch.
    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-2943120-3"
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:nil];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"app_status"
                                         action:@"app_launched"
                                          label:@""
                                          value:-1
                                      withError:&error]) {
        NSLog(@"Unable to track app_launched event with GANTracker, %@", error);
    }
    
    self.userData = [[[NSMutableDictionary alloc] init] autorelease];
    [self loadUserDefaults];
    
    self.contentController.userData = self.userData;
    
    [self.window addSubview:self.contentController.view];
	[self.window makeKeyAndVisible];
    
    if (ShouldAskForReviewAtLaunch()) {
        AskForReview();
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application 
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application 
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    
    [self saveUserDefaults];
}

- (void)applicationWillEnterForeground:(UIApplication *)application 
{
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application 
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    if (ShouldAskForReviewAtLaunch()) {
        AskForReview();
    }
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
    [self saveUserDefaults];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc 
{
    [[GANTracker sharedTracker] stopTracker];
    [window release];
    [super dealloc];
}

@end
