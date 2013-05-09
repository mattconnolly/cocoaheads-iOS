//
//  CHCrypto.m
//  cryptotest
//
//  Created by Matt Connolly on 8/05/13.
//  Copyright (c) 2013 Matt Connolly. All rights reserved.
//

#import "CHCrypto.h"
#import <Security/Security.h>

@implementation CHCrypto

+ (instancetype) newWithPKCS12Data:(NSData*)pkcs12Data password:(NSString*)password;
{
    CHCrypto* result = nil;
    CFArrayRef items = NULL;
    CFMutableDictionaryRef options = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
    CFDictionarySetValue(options, kSecImportExportPassphrase, (__bridge CFStringRef)password);
    OSStatus err = SecPKCS12Import((__bridge_retained CFDataRef)pkcs12Data, options, &items);
    CFRelease(options);
    NSLog(@"err = %ld", (long)err);
    NSLog(@"items[0] = %@", items != NULL && CFArrayGetCount(items) > 0 ? CFArrayGetValueAtIndex(items, 0) : NULL);
    
    if (err == 0 && items != NULL && CFArrayGetCount(items) > 0)
    {
        CFDictionaryRef item = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identity = (SecIdentityRef) CFDictionaryGetValue(item, kSecImportItemIdentity);
        result = [[self alloc] initWithIdentity:identity];
        CFRelease(items);
    }
    return result;
}


- (id)initWithIdentity:(SecIdentityRef)identity;
{
    self = [super init];
    if (self) {
        _identity = identity;
        CFRetain(_identity);
        
        OSStatus err = 0;
        SecCertificateRef certificate = NULL;
        err = SecIdentityCopyCertificate(_identity, &certificate);
        if (err == 0) {
            SecPolicyRef policy = SecPolicyCreateSSL(NO, nil);
            SecTrustRef trust = NULL;
            CFArrayRef certs = CFArrayCreate(NULL, (const void**)&certificate, 1, NULL);
            err = SecTrustCreateWithCertificates(certs, policy, &trust);
            if (err == 0) {
                SecTrustResultType trusted = 0;
                SecTrustEvaluate(trust, &trusted);
                NSLog(@"trust result = %ld", (long)trusted);
                
                _publicKey = SecTrustCopyPublicKey(trust);
                if (_publicKey == NULL) {
                    NSLog(@"failed to get public key from certificate.");
                }
            } else {
                NSLog(@"failed to create trust for certificate.");
            }
            
            CFRelease(certs);
            CFRelease(certificate);
        }
        else {
            NSLog(@"Failed to get certificate from identity.");
        }
        
        err = SecIdentityCopyPrivateKey(_identity, &_privateKey);
        if (err != 0) {
            NSLog(@"Failed to get private key from identity");
        }
    }
    return self;
}

- (void)dealloc
{
    if (_publicKey) {
        CFRelease(_publicKey);
    }
    if (_privateKey) {
        CFRelease(_privateKey);
    }
    if (_identity) {
        CFRelease(_identity);
    }
}

- (NSData*)encodeString:(NSString*)plainString;
{
    NSData* encrypted = nil;
#if ! TARGET_OS_IPHONE
    CFErrorRef error = NULL;
    SecTransformRef encrypt = SecEncryptTransformCreate(_publicKey, &error);
    if (error) {
        if (encrypt) CFRelease(encrypt);
        return nil;
    }
    
    SecTransformSetAttribute(encrypt,
                             kSecPaddingKey,
                             kSecPaddingOAEPKey,
                             &error);
    if (error) {
        if (encrypt) CFRelease(encrypt);
        return nil;
    }
    
    NSData* sourceData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    SecTransformSetAttribute(encrypt, kSecTransformInputAttributeName,
                             (__bridge CFDataRef)sourceData, &error);
    if (error) {
        if (encrypt) CFRelease(encrypt);
        return nil;
    }
    
    /* Encrypt the data. */
    CFDataRef encryptedData = SecTransformExecute(encrypt, &error);
    if (error) {
        if (encrypt) CFRelease(encrypt);
        if (encryptedData) CFRelease(encryptedData);
        return nil;
    }
    encrypted = (__bridge_transfer NSData*)encryptedData;
    CFRelease(encrypt);
#else
    NSData* plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    size_t len = 16284;
    uint8_t buffer[len];
    OSStatus err = 0;
    err = SecKeyEncrypt(_publicKey, kSecPaddingOAEP, plainData.bytes, plainData.length, buffer, &len);
    if (err == 0) {
        encrypted = [NSData dataWithBytes:buffer length:len];
    }
#endif
    return encrypted;
}


- (NSString*)decodeData:(NSData*)encryptedData;
{
    NSString* string = nil;
#if TARGET_OS_IPHONE
    OSStatus err = 0;
    size_t len = encryptedData.length;
    char* buffer = malloc(len);
    memset(buffer, 0, len);
    err = SecKeyDecrypt(_privateKey,
                        kSecPaddingOAEP,
                        encryptedData.bytes,
                        encryptedData.length,
                        (UInt8*) buffer,
                        &len);
    if (err == 0) {
        string = [[NSString alloc] initWithBytes:buffer
                                          length:len
                                        encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    
#else
    // mac 10.7+ implementation
    
    CFErrorRef error = NULL;
    SecTransformRef decrypt = SecDecryptTransformCreate(_privateKey, &error);
    if (error) {
        if (decrypt) CFRelease(decrypt);
        return nil;
    }
    
    SecTransformSetAttribute(decrypt,
                             kSecPaddingKey,
                             kSecPaddingOAEPKey,
                             &error);
    if (error) {
        if (decrypt) CFRelease(decrypt);
        return nil;
    }
    
    SecTransformSetAttribute(decrypt, kSecTransformInputAttributeName,
                             (__bridge CFDataRef)encryptedData, &error);
    if (error) {
        if (decrypt) CFRelease(decrypt);
        return nil;
    }
    
    /* Encrypt the data. */
    CFDataRef decryptedData = SecTransformExecute(decrypt, &error);
    if (error) {
        if (decrypt) CFRelease(decrypt);
        if (decryptedData) CFRelease(decryptedData);
        return nil;
    }
    string = [[NSString alloc] initWithBytes:CFDataGetBytePtr(decryptedData)
                                      length:CFDataGetLength(decryptedData)
                                    encoding:NSUTF8StringEncoding];
    CFRelease(decryptedData);
    CFRelease(decrypt);
#endif
    return string;
}


// helper to look up an identity with the given name
+ (SecIdentityRef)identityWithName:(NSString*)name;
{
    CFMutableDictionaryRef query = CFDictionaryCreateMutable(NULL, 4, NULL, NULL);
    CFDictionaryAddValue(query, kSecClass, kSecClassIdentity);
    CFDictionaryAddValue(query, kSecMatchSubjectContains, (__bridge CFStringRef)name);
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

@end
