//
//  CHAuthoriserAppDelegate.m
//  Authoriser
//
//  Created by Matt Connolly on 8/05/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import "CHAuthoriserAppDelegate.h"
#import "CHCrypto.h"
#import "CHPlistItem.h"

@implementation CHAuthoriserAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    self.window.delegate = self;
    
    SecIdentityRef identity = [CHCrypto identityWithName:@"Brisbane CocoaHeads"];
    _crypto = [[CHCrypto alloc] initWithIdentity:identity];
    _plistItems = [[NSMutableArray alloc] init];
    
    self.arrayController.content = self.plistItems;
    self.arrayController.filterPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        CHPlistItem* item = (CHPlistItem*)evaluatedObject;
        id value = item.value;
        return [value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSData class]];
    }];
    self.arrayController.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"key" ascending:YES]];
    
    self.pathToPlistFile = [[NSUserDefaults standardUserDefaults] objectForKey:@"plist-path"];
    if (self.pathToPlistFile.length > 0) {
        [self openPlist:self];
    }
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)windowShouldClose:(id)sender
{
    [[NSApplication sharedApplication] terminate:self];
    return YES;
}


- (IBAction)openPlist:(id)sender;
{
    if (self.pathToPlistFile)
    {
        NSData* data = [NSData dataWithContentsOfFile:self.pathToPlistFile];
        NSPropertyListFormat format = 0;
        NSString* errorDescription = nil;
        NSMutableDictionary* dict = [NSPropertyListSerialization propertyListFromData:data
                                                                     mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                                               format:&format
                                                                     errorDescription:&errorDescription];
        if (dict)
        {
            _plistData = dict;
            
            self.plistPathLabel.stringValue = self.pathToPlistFile;
            
            [[NSUserDefaults standardUserDefaults] setObject:self.pathToPlistFile
                                                      forKey:@"plist-path"];
            
            [self.plistItems removeAllObjects];
            for (NSString* key in self.plistData) {
                CHPlistItem* item = [[CHPlistItem alloc] initWithKey:key inDictionary:self.plistData];
                item.crypto = self.crypto;
                [self.plistItems addObject:item];
            }
            self.arrayController.content = self.plistItems;
        }
    }
}

- (IBAction)savePlist:(id)sender;
{
    NSString* errorDescription = nil;
    NSData* data = [NSPropertyListSerialization dataFromPropertyList:self.plistData
                                                              format:NSPropertyListXMLFormat_v1_0
                                                    errorDescription:&errorDescription];
    [data writeToFile:self.pathToPlistFile atomically:YES];
}

- (IBAction)openDocument:(id)sender
{
    NSLog(@"open document!");
    
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    
    panel.allowedFileTypes = @[@"plist"];
    NSInteger result = [panel runModal];
    NSLog(@"result = %ld, url = %@", (long)result, panel.URL);
    
    if (result == NSFileHandlingPanelOKButton)
    {
        self.pathToPlistFile = panel.URL.path;
        [self openPlist:self];
    }
}

- (IBAction)revertDocumentToSaved:(id)sender
{
    [self openPlist:sender];
}

- (IBAction)saveDocument:(id)sender
{
    [self savePlist:sender];
}

@end
