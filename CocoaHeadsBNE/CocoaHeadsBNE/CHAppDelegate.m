//
//  CHAppDelegate.m
//  CocoaHeadsBNE
//
//  Created by Matt Connolly on 16/03/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import "CHAppDelegate.h"
#import <ECSlidingViewController/ECSlidingViewController.h>
#import <MeetupOAuth2Client/MUOAuth2Client.h>
#import <MeetupOAuth2Client/MUAPIRequest.h>

@implementation CHAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Sets the main view controller as the top contoller of the sliding view controller.
    ECSlidingViewController *slidingViewController = (ECSlidingViewController *)self.window.rootViewController;
    if ([slidingViewController isKindOfClass:[ECSlidingViewController class]]) {
        slidingViewController.underLeftViewController = [slidingViewController.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    } else {
        NSLog(@"The root view controller is not a ECSlidingViewController!");
    }
    
    dispatch_async(dispatch_get_main_queue(), ^()
                   {
                       [self testMeetup];
                   });
    return YES;
}

- (void)testMeetup
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"oauth"
                                                     ofType:@"plist"];
    NSData* plistData = [NSData dataWithContentsOfFile:path];
    NSPropertyListFormat format = 0;
    NSError* error = nil;
    NSDictionary* oauthSettings = (NSDictionary*)[NSPropertyListSerialization propertyListWithData:plistData
                                                                                           options:0
                                                                                            format:&format
                                                                                             error:&error];
    MUOAuth2Client* client = [MUOAuth2Client sharedClient];
    
    NSString* clientID = oauthSettings[@"key"];
    MUOAuth2Credential *credential = [client credentialWithClientID:clientID];
    
    void (^login)() = ^()
    {
        [client authorizeClientWithID:clientID
                               secret:oauthSettings[@"secret"]
                          redirectURI:oauthSettings[@"redirect"]
                              success:^(MUOAuth2Credential *credential) {
                                  NSLog(@"yay!");
                                  [self testMeetup2:credential];
                              }
                              failure:^(NSError *error) {
                                  NSLog(@"Error = %@", error.localizedDescription);
                                  NSLog(@"broken");
                              }];
    };
    
    if (credential)
    {
        if (!credential.isExpired)
        {
            [self testMeetup2:credential];
        }
        else
        {
            [client refreshCredential:credential
                              success:^(MUOAuth2Credential *credential) {
                                  //
                                  [self testMeetup2:credential];
                              } failure:^(NSError *error) {
                                  NSLog(@"Error refreshing authentication token: %@", error.localizedDescription);
                                  login();
                              }];
        }
    }
    else
    {
        login();
    }
}


- (void)testMeetup2:(MUOAuth2Credential*)credential
{
    __block int count = 0;
    
    void (^completion)(MUAPIRequest*request) = ^(MUAPIRequest*request)
    {
        NSLog(@"Request completed: %@", request.request);
        NSLog(@"Got error: %@", request.error);
        [request.data writeToFile:[NSString stringWithFormat:@"/tmp/meetup-%02d.json", ++count]
                       atomically:YES];
        NSLog(@"Got response: %@", request.responseBody);
    };
    
    // make an API request
    [MUAPIRequest getRequestWithURL:@"https://api.meetup.com/2/event/106662252.json"
                         parameters:@{}
                      andCredential:credential
                         completion:completion];
    
    // make an API request
    [MUAPIRequest getRequestWithURL:@"https://api.meetup.com/2/member/self.json"
                         parameters:@{}
                      andCredential:credential
                         completion:completion];
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CocoaHeadsBNE" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CocoaHeadsBNE.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}


// create a new clean managed object context:
- (NSManagedObjectContext*)newManagedObjectContext;
{
    NSManagedObjectContext* context = nil;
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:coordinator];
    }
    return context;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
