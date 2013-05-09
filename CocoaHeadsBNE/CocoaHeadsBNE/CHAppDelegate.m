//
//  CHAppDelegate.m
//  CocoaHeadsBNE
//
//  Created by Matt Connolly on 16/03/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import "CHAppDelegate.h"
#import "ECSlidingViewController.h"
#import "CHCrypto.h"

@implementation CHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Sets the main view controller as the top contoller of the sliding view controller.
    ECSlidingViewController *slidingViewController = (ECSlidingViewController *)self.window.rootViewController;
    if ([slidingViewController isKindOfClass:[ECSlidingViewController class]]) {
        slidingViewController.underLeftViewController = [slidingViewController.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    } else {
        NSLog(@"The root view controller is not a ECSlidingViewController!");
    }
    
    NSString* p12path = [[NSBundle mainBundle] pathForResource:@"cocoaheads" ofType:@"p12"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:p12path]) {
        NSLog(@"ERROR: missing cocoaheads.p12 file!");
    }
    _crypto = [CHCrypto newWithPKCS12Data:[NSData dataWithContentsOfFile:p12path]
                                 password:@"qwertyuiop"];
    if (_crypto == nil)
    {
        NSLog(@"Failed to create crypto object!");
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // 
}



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
