//
//  CHNavigationController.m
//  CocoaHeadsBNE
//
//  Created by Yann Bodson on 30/03/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import "CHNavigationController.h"
#import <ECSlidingViewController.h>

@interface CHNavigationController ()

@end

@implementation CHNavigationController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.view addGestureRecognizer:self.slidingViewController.panGesture];

    self.view.layer.shadowOpacity = 0.70;
    self.view.layer.shadowRadius = 8.0;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (void)dealloc
{
    NSLog(@"Navigation View Controller Gone");
}

@end
