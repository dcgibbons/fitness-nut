#include "ReviewRequest.h"


NSString *KeyReviewed = @"ReviewRequestReviewedForVersion";
NSString *KeyDontAsk = @"ReviewRequestDontAsk";
NSString *KeyNextTimeToAsk = @"ReviewRequestNextTimeToAsk";
NSString *KeySessionCountSinceLastAsked = @"ReviewRequestSessionCountSinceLastAsked";


@interface ReviewRequestDelegate : NSObject < UIAlertViewDelegate >
{
}

@end

@implementation ReviewRequestDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	switch (buttonIndex)
	{
	case 0: // remind me later
	{
		const double nextTime = CFAbsoluteTimeGetCurrent() + 60*60*23; // check again in 23 hours
		[defaults setDouble:nextTime forKey:KeyNextTimeToAsk];
		break;
	}
	
	case 1: // rate it now
	{
        ReviewApp();
        break;
	}
	
	case 2: // don't ask again
		[defaults setBool:true forKey:KeyDontAsk];
		break;
	default:
		break;
	}

	[defaults setInteger:0 forKey:KeySessionCountSinceLastAsked];
    
	[self release];
}


@end


BOOL ShouldAskForReview()
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

	if ([defaults boolForKey:KeyDontAsk])
		return false;

	NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	NSString* reviewedVersion = [defaults stringForKey:KeyReviewed];
	if ([reviewedVersion isEqualToString:version])
		return NO;

	const double currentTime = CFAbsoluteTimeGetCurrent();
	if ([defaults objectForKey:KeyNextTimeToAsk] == nil)
	{
		const double nextTime = currentTime + 60*60*23*2;  // 2 days (minus 2 hours)
		[defaults setDouble:nextTime forKey:KeyNextTimeToAsk];
		return NO;
	}
	
	const double nextTime = [defaults doubleForKey:KeyNextTimeToAsk];
	if (currentTime < nextTime)
		return NO;

	return YES;
}


BOOL ShouldAskForReviewAtLaunch()
{
	if (!ShouldAskForReview())
		return NO;
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	const int count = [defaults integerForKey:KeySessionCountSinceLastAsked];
	[defaults setInteger:count+1 forKey:KeySessionCountSinceLastAsked];
	
	if (count < 12)
		return NO;

	return YES;
}



void AskForReview()
{
	ReviewRequestDelegate* delegate = [[ReviewRequestDelegate alloc] init];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Enjoying Fitness Nut?" 
					message:@"If so, please rate this update with 5 stars on the App Store so we can keep the free updates coming."
					delegate:delegate cancelButtonTitle:@"Remind me later" otherButtonTitles:@"Yes, rate it!", @"Don't ask again", nil];
	[alert show];
	[alert release];
}

void ReviewApp()
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [defaults setValue:version forKey:KeyReviewed];
    // http://creativealgorithms.com/blog/content/review-app-links-sorted-out
    // http://bjango.com/articles/ituneslinks/
    
#ifdef PRO_VERSION
    NSString *appId = @"424734288";
#else
    NSString *appId = @"420480042";
#endif
    
    NSString *iTunesLink = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId];
    NSLog(@"Opening review link: %@", iTunesLink);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}



