//
//  CHAppDelegate.h
//  Authoriser
//
//  Created by Matt Connolly on 8/05/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CHCrypto;
@class CHPlistItem;

@interface CHAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField* plistPathLabel;
@property (assign) IBOutlet NSArrayController* arrayController;

@property (readonly) CHCrypto* crypto;
@property (retain) NSString* pathToPlistFile;
@property (readonly) NSMutableDictionary* plistData;
@property (readonly) NSMutableArray * plistItems; // array of CHPlistItem objects

- (IBAction)openPlist:(id)sender;
- (IBAction)savePlist:(id)sender;

@end
