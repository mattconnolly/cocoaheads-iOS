//
//  CHAppDelegate.m
//  Authoriser
//
//  Created by Matt Connolly on 8/05/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import "CHAppDelegate.h"
#import "CHCrypto.h"

SecIdentityRef getIdentity()
{
    CFMutableDictionaryRef query = CFDictionaryCreateMutable(NULL, 4, NULL, NULL);
    CFDictionaryAddValue(query, kSecClass, kSecClassIdentity);
    CFDictionaryAddValue(query, kSecMatchSubjectContains, @"Brisbane CocoaHeads");
    CFDictionaryAddValue(query, kSecReturnRef, kCFBooleanTrue);
    CFTypeRef result;
    OSStatus err;
    
    err = SecItemCopyMatching(query, &result);
    CFRelease(query);
    if (err == 0 && result != NULL && CFGetTypeID(result) == SecIdentityGetTypeID()) {
        return (SecIdentityRef)result;
    }
    return NULL;
}

@implementation CHAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    self.window.delegate = self;
    
    _crypto = [[CHCrypto alloc] initWithIdentity:getIdentity()];
    
    self.pathToPlistFile = [[NSUserDefaults standardUserDefaults] objectForKey:@"plist-path"];
    if (self.pathToPlistFile.length > 0) {
        [self openPlist:self];
    }
    
    self.dictionaryController.filterPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        id value = [evaluatedObject valueForKeyPath:@"value"];
        return [value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSData class]];
    }];
    self.dictionaryController.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"key" ascending:YES]];
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
            
            self.dictionaryController.content = self.plistData;
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

@end
