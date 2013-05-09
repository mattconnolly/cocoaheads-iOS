//
//  CHCrypto.h
//  cryptotest
//
//  Created by Matt Connolly on 8/05/13.
//  Copyright (c) 2013 Matt Connolly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface CHCrypto : NSObject
{
    SecIdentityRef _identity;
    SecKeyRef _publicKey;
    SecKeyRef _privateKey;
}

+ (instancetype) newWithPKCS12Data:(NSData*)pkcs12Data password:(NSString*)password;
- (id) initWithIdentity:(SecIdentityRef)identity;

- (NSData*)encodeString:(NSString*)plainString;
- (NSString*)decodeData:(NSData*)encryptedData;

// helper to look up an identity with the given name
+ (SecIdentityRef)identityWithName:(NSString*)name;

@end
