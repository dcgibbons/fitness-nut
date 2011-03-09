//
//  UpgradeBannerView.m
//  Fitness Nut
//
//  Created by Chad Gibbons on 03/09/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

// This is required in order to access the CALayer properties
#import <QuartzCore/QuartzCore.h>

#import "UpgradeBannerView.h"


@implementation UpgradeBannerView
@synthesize label;

- (void)setupView
{
	// Redraw our content always, instead of scaling.
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.autoresizesSubviews = YES;
	self.contentMode = UIViewContentModeRedraw;

    self.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
    label.center = self.center;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    CALayer *layer = [label layer];
    // Round corners using CALayer property
    [layer setCornerRadius:10];
    [self setClipsToBounds:YES];
    
    // Create colored border using CALayer property
    [layer setBorderColor:[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1] CGColor]];
    [layer setBorderWidth:2.75];
    
    label.adjustsFontSizeToFitWidth = YES;
    label.font = [UIFont systemFontOfSize:18];
    label.text = @"Tap to Upgrade to Fitness Nut Pro!";
    label.textAlignment = UITextAlignmentCenter;

    [self addSubview:label];

	// Watch for tapping
	UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                            action:@selector(tap:)];
	tapgr.numberOfTapsRequired = 1;
	[self addGestureRecognizer:tapgr];
	[tapgr release];
    
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib 
{
	[self setupView];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code.
    label.center = self.center;
    [super drawRect:rect];
}

- (void)tap:(UITapGestureRecognizer *)gestureRecognizer 
{
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/us/app/fitness-nut-pro/id424734288?mt=8&ls=1"];
    [[UIApplication sharedApplication] openURL:url];        
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload 
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    self.label = nil;
}

- (void)dealloc
{
    [label release];
    [super dealloc];
}

@end
