//
//  CHAppDelegate.h
//  CocoaHeadsBNE
//
//  Created by Matt Connolly on 16/03/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCrypto.h"

@interface CHAppDelegate : UIResponder <UIApplicationDelegate>
{
    NSDictionary* _credentials;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly) CHCrypto* crypto;

+ (CHAppDelegate*)sharedInstance;

- (NSURL *)applicationDocumentsDirectory;

- (NSString*)credentialForKey:(NSString*)key;

- (IBAction)testMeetup:(id)sender;
- (IBAction)meetupLogOut:(id)sender;
- (IBAction)meetupLogIn:(id)sender;

@end
