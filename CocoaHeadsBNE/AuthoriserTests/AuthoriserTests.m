//
//  AuthoriserTests.m
//  AuthoriserTests
//
//  Created by Matt Connolly on 8/05/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import "AuthoriserTests.h"
#import "CHCrypto.h"

@implementation AuthoriserTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    SecIdentityRef identity = [CHCrypto identityWithName:@"Brisbane CocoaHeads"];
    crypto = [[CHCrypto alloc] initWithIdentity:identity];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testEncryptAndDecrypt
{
    XCTAssertNotNil(crypto, @"crypto is not nil");
    
    NSString* source = @"Hello World!";
    NSData* encrypted = [crypto encodeString:source];
    XCTAssertNotNil(encrypted, @"encrypted data is not nil");
    NSString* decrypted = [crypto decodeData:encrypted];
    XCTAssertNotNil(decrypted, @"decrypted data is not nil");
    XCTAssertEqualObjects(source, decrypted, @"decrypted string matches source string");
}

@end
