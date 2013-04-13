//
//  CHTopViewController.m
//  CocoaHeadsBNE
//
//  Created by Yann Bodson on 28/03/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import "CHAboutViewController.h"
#import "CHMenuViewController.h"
#import <ECSlidingViewController.h>

@interface CHAboutViewController ()

- (IBAction)showMenu:(id)sender;

@end


@implementation CHAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"About View loaded");
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];

    self.view.layer.shadowOpacity = 0.70;
    self.view.layer.shadowRadius = 8.0;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (void)dealloc
{
    NSLog(@"About View Controller gone.");
}

- (IBAction)showMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
