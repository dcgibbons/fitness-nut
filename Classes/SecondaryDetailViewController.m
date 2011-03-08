    //
//  SecondaryDetailViewController.m
//  Fitness Nut
//
//  Created by Chad Gibbons on 03/07/2011.
//  Copyright 2011 The Nuclear Bunny. All rights reserved.
//

#import "SecondaryDetailViewController.h"


@implementation SecondaryDetailViewController

@synthesize inputDelegate, cancelButton, doneButton;


- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    // Layout once here to ensure the current orientation is respected.
    [self layoutView:[UIApplication sharedApplication].statusBarOrientation];
    
    if (IS_PAD_DEVICE()) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                         duration:(NSTimeInterval)duration 
{
    [super willAnimateRotationToInterfaceOrientation:orientation duration:duration];
    [self layoutView:orientation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *button = nil;
    
    button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                           target:self
                                                           action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = self.cancelButton = button;
    [button release];
    
    button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                           target:self
                                                           action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = self.doneButton = button;
    [button release];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.cancelButton = nil;
    self.doneButton = nil;
}

- (void)dealloc 
{
    [cancelButton release];
    [doneButton release];
    [super dealloc];
}

- (BOOL)shouldShowInPopover
{
    return YES;
}

// Subclasses should override to customize their view's layout.
- (void)layoutView:(UIInterfaceOrientation)orientation
{
    // NO-OP
}

- (void)cancel:(id)sender
{
    [self.inputDelegate didDismissInputView:self];
}

- (void)done:(id)sender
{
    [self.inputDelegate didDismissInputView:self];
}

@end
