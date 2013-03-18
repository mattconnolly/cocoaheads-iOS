//
//  CHMainViewController.m
//  CocoaHeadsBNE
//
//  Created by Yann Bodson on 18/03/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import "CHMainViewController.h"
#import "CHMenuViewController.h"
#import "ECSlidingViewController.h"

@interface CHMainViewController () <CHMenuViewControllerDelegate>

- (IBAction)menuButtonPressed:(id)sender;
- (void)createLeftMenu;

@end


@implementation CHMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *titlebarBg = [[UIImage imageNamed:@"titlebar-bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 3, 0, 3)];
    [self.navigationController.navigationBar setBackgroundImage:titlebarBg forBarMetrics:UIBarMetricsDefault];
    [self createLeftMenu];
}

- (void)menuButtonPressed:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)createLeftMenu
{
    CHMenuViewController *menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    menuViewController.delegate = self;
    self.slidingViewController.underLeftViewController = menuViewController;
    self.slidingViewController.anchorRightRevealAmount = 280.0;
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];

    // Drop shadow
    self.navigationController.view.layer.shadowOpacity = 0.70;
    self.navigationController.view.layer.shadowRadius = 8.0;
    self.navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
}

#pragma mark - CHMenuViewControllerDelegate

- (void)menuViewController:(CHMenuViewController *)menuViewController didSelectRowAtIndex:(int)index
{
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        [self.slidingViewController resetTopView];
    }];
}

@end
