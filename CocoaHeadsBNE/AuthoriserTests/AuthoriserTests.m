//
//  AuthoriserTests.m
//  AuthoriserTests
//
//  Created by Matt Connolly on 8/05/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import "AuthoriserTests.h"
#import "CHCrypto.h"
#import "CHPlistItem.h"

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

- (void)testCHPlistItem
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dict[@"key"] = @"Hello world!";
    CHPlistItem* item = [[CHPlistItem alloc] initWithKey:@"key"
                                            inDictionary:dict];
    item.crypto = crypto;
    
    XCTAssertNotNil(item, @"item is not nil");
    XCTAssertFalse(item.encrypted, @"item is not encrypted");
    XCTAssertTrue([dict[@"key"] isKindOfClass:[NSString class]], @"item is a string");
    XCTAssertTrue([item.value isKindOfClass:[NSString class]], @"item.value is a string");
    item.encrypted = YES;
    XCTAssertTrue(item.encrypted, @"item is encrypted");
    XCTAssertTrue([dict[@"key"] isKindOfClass:[NSData class]], @"item is data");
    XCTAssertTrue([item.value isKindOfClass:[NSString class]], @"item.value is a string");
    item.encrypted = NO;
    XCTAssertFalse(item.encrypted, @"item is not encrypted");
    XCTAssertTrue([dict[@"key"] isKindOfClass:[NSString class]], @"item is a string");
    XCTAssertTrue([item.value isKindOfClass:[NSString class]], @"item.value is a string");
}

@end
