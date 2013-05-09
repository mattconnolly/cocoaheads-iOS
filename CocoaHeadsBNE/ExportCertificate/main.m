//
//  main.m
//  ExportCertificate
//
//  Created by Matt Connolly on 9/05/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCrypto.h"
#import <Security/Security.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        int err;
        
        if (argc < 1) {
            NSLog(@"Required argument 1: path to dir where to save .p12 file.");
            exit(1);
        }
    
        // move to output directory
        err = chdir(argv[1]);
        if (err != 0) {
            NSLog(@"Failed to change to directory: %s", argv[1]);
            exit(1);
        }
        
        // only output if the file isn't there... avoids Keychain access dialogs.
        NSString* path = @"cocoaheads.p12";
        path = [path stringByStandardizingPath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            SecIdentityRef identity = [CHCrypto identityWithName:@"Brisbane CocoaHeads"];
            
            // extract private key to copy into the app.
            SecItemImportExportKeyParameters keyParams;
            keyParams.version = SEC_KEY_IMPORT_EXPORT_PARAMS_VERSION;
            keyParams.flags = 0;
            keyParams.passphrase = CFSTR("qwertyuiop");
            keyParams.alertTitle = CFSTR("alert title");
            keyParams.alertPrompt = CFSTR("alert prompt");
            keyParams.accessRef = NULL;
            keyParams.keyUsage = NULL;
            keyParams.keyAttributes = NULL;

            CFDataRef keyData = NULL;

            err = SecItemExport(identity, kSecFormatPKCS12, 0, &keyParams, &keyData);
            if (err) {
                NSLog(@"SecItemExport failed with code %d", err);
                exit(-1);
            }
            
            // write the .p12 file into it.
            NSData* key2 = (__bridge NSData*)keyData;
            [key2 writeToFile:path atomically:YES];
            NSLog(@"Wrote identity to file: %@", path);
            CFRelease(keyData);
        }
        else {
            NSLog(@"Identity file already exists: %@", path);
        }
    }
    return 0;
}

