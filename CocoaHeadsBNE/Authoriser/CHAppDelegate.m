//
//  CHAppDelegate.m
//  Authoriser
//
//  Created by Matt Connolly on 8/05/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import "CHAppDelegate.h"

@implementation CHAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    self.window.delegate = self;
}

- (BOOL)windowShouldClose:(id)sender
{
    [[NSApplication sharedApplication] terminate:self];
    return YES;
}

@end
