//
//  CHMainViewController.m
//  CocoaHeadsBNE
//
//  Created by Yann Bodson on 18/03/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import "CHMainViewController.h"
#import "ECSlidingViewController.h"

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

@end
