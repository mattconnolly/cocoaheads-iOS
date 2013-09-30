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
#import "CHCertificatePassword.h"
#import <MeetupOAuth2Client/MUAPIRequest.h>
#import <MeetupOAuth2Client/MUOAuth2Client.h>

static CHAppDelegate* _sharedInstance = nil;


@interface MUOAuth2Credential(CHAppDelegate) <NSCoding>
@property (copy, nonatomic) NSString *clientID;
@property (copy, nonatomic) NSString *clientSecret;
@property (copy, nonatomic, readwrite) NSString *accessToken;
@property (copy, nonatomic) NSString *refreshToken;
@property (strong, nonatomic) NSDate *expiry;
@end


@implementation CHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _sharedInstance = self;
    
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
                                 password:[CHCertificatePassword string]];
    if (_crypto == nil)
    {
        NSLog(@"Failed to create crypto object!");
    }
    
    
    NSString* credentialsPath = [[NSBundle mainBundle] pathForResource:@"credentials"
                                                                ofType:@"plist"];
    NSData* credentialsData = [NSData dataWithContentsOfFile:credentialsPath];
    NSString* errorDescription = nil;
    NSPropertyListFormat format = 0;
    _credentials = [NSPropertyListSerialization propertyListFromData:credentialsData
                                                    mutabilityOption:0
                                                              format:&format
                                                    errorDescription:&errorDescription];
    
    NSLog(@"meetup_consumer_key    = %@", [self credentialForKey:@"meetup_consumer_key"]);
    NSLog(@"meetup_consumer_secret = %@", [self credentialForKey:@"meetup_consumer_secret"]);
    
    return YES;
}

+ (CHAppDelegate*)sharedInstance;
{
    return _sharedInstance;
}

NSString* REDIRECT = @"cocoaheadsbne://oauth2";

- (IBAction)testMeetup:(id)sender;
{
    MUOAuth2Client* client = [MUOAuth2Client sharedClient];
    
    NSString* clientID = [self credentialForKey:@"meetup_consumer_key"];
    NSString* secret = [self credentialForKey:@"meetup_consumer_secret"];
    
    if (clientID == nil || secret == nil)
    {
        UIAlertView* alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Configuration error"
                                           message:@"Meetup API consumer key or secret missing!"
                                          delegate:nil
                                 cancelButtonTitle:@"Oh"
                                 otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    MUOAuth2Credential *credential = [client credentialWithClientID:clientID];
    
    NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
    NSData* data = [store objectForKey:@"meetup-user-credential"];
    if (data)
    {
        credential = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    else
    {
        // use Mr Anonymous refresh token
        credential = [[MUOAuth2Credential alloc] init];
        credential.clientID = clientID;
        credential.clientSecret = secret;
        credential.refreshToken = [self credentialForKey:@"meetup_anonymous_refresh_token"];
        credential.accessToken = nil;
        credential.expiry = [NSDate dateWithTimeIntervalSince1970:1];
    }
    
    void (^login)() = ^()
    {
        [client authorizeClientWithID:clientID
                               secret:secret
                          redirectURI:REDIRECT
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
    [MUAPIRequest getRequestWithURL:@"https://api.meetup.com/2/event/139400932.json"
                         parameters:@{}
                      andCredential:credential
                         completion:completion];
    
    // make an API request
    [MUAPIRequest getRequestWithURL:@"https://api.meetup.com/2/member/self.json"
                         parameters:@{}
                      andCredential:credential
                         completion:completion];
    
    NSString* refresh = [credential performSelector:@selector(refreshToken) withObject:nil];
    NSString* accessToken = [credential performSelector:@selector(accessToken) withObject:nil];
    NSDate* expiry = [credential performSelector:@selector(expiry) withObject:nil];
    NSLog(@"refresh: %@", refresh);
    NSLog(@"accessToken: %@", accessToken);
    NSLog(@"expiry: %@", expiry);
}

- (IBAction)meetupLogOut:(id)sender;
{
    MUOAuth2Client* client = [MUOAuth2Client sharedClient];
    NSString* clientID = [self credentialForKey:@"meetup_consumer_key"];
    
    UIAlertView* alert;
    if (clientID == nil)
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Configuration Error"
                                           message:@"Client ID is not present in credentials file!"
                                          delegate:nil
                                 cancelButtonTitle:@"Oh"
                                 otherButtonTitles:nil];
        [alert show];
        return;
    }

    [client forgetCredentialWithClientID:clientID];
    alert = [[UIAlertView alloc] initWithTitle:@"Meetup API Logged out"
                                       message:nil
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [alert show];
}

- (IBAction)meetupLogIn:(id)sender
{
    MUOAuth2Client* client = [MUOAuth2Client sharedClient];
    NSString* clientID = [self credentialForKey:@"meetup_consumer_key"];
    NSString* secret = [self credentialForKey:@"meetup_consumer_secret"];
    MUOAuth2Credential* credential = [client credentialWithClientID:clientID];
    
    void (^login)() = ^()
    {
        [client authorizeClientWithID:clientID
                               secret:secret
                          redirectURI:REDIRECT
                              success:^(MUOAuth2Credential *credential) {
                                  NSLog(@"yay! successfully logged in!");
                                  
                                  UIAlertView* alert;
                                  alert = [[UIAlertView alloc] initWithTitle:@"Logged in"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:nil
                                                           otherButtonTitles:@"Ok", nil];
                                  [alert show];
                                  
                                  [self testMeetup2:credential];
                              }
                              failure:^(NSError *error) {
                                  NSLog(@"Error = %@", error.localizedDescription);
                                  NSLog(@"broken");
                              }];
    };
    
    if (credential)
    {
        // refresh.
        [client refreshCredential:credential
                          success:^(MUOAuth2Credential *credential) {
                              //
                              NSLog(@"yay! successfully refreshed token!");
                              
                              UIAlertView* alert;
                              alert = [[UIAlertView alloc] initWithTitle:@"Logged in"
                                                                 message:@"Refreshed token"
                                                                delegate:nil
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"Ok", nil];
                              [alert show];
                              
                              [self testMeetup2:credential];
                          } failure:^(NSError *error) {
                              NSLog(@"Error refreshing authentication token: %@", error.localizedDescription);
                              login();
                          }];

    }
    else
    {
        // sign in.
        login();
    }
    
    
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


- (NSString*)credentialForKey:(NSString*)key;
{
    id value = _credentials[key];
    if ([value isKindOfClass:[NSData class]])
    {
        // decrypt:
        return [_crypto decodeData:value];
    }
    else
    {
        // string / as is:
        return value;
    }
}

@end
