//
//  CHMainViewController.m
//  CocoaHeadsBNE
//
//  Created by Yann Bodson on 18/03/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import "CHMainViewController.h"
#import "ECSlidingViewController.h"
#import "CHAppDelegate.h"

@interface CHMainViewController ()

- (IBAction)showMenu:(id)sender;

@end


@implementation CHMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *titlebarBg = [[UIImage imageNamed:@"titlebar-bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 3, 0, 3)];
    [self.navigationController.navigationBar setBackgroundImage:titlebarBg forBarMetrics:UIBarMetricsDefault];
}

- (void)showMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)testMeetup:(id)sender;
{
    [CHAppDelegate.sharedInstance testMeetup:sender];
}

- (IBAction)meetupLogOut:(id)sender;
{
    [CHAppDelegate.sharedInstance meetupLogOut:sender];
}

- (IBAction)meetupLogIn:(id)sender;
{
    [CHAppDelegate.sharedInstance meetupLogIn:sender];
}

@end
