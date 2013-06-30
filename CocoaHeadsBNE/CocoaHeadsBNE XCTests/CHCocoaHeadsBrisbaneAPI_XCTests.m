//
//  CocoaHeadsBNE_XCTests.m
//  CocoaHeadsBNE XCTests
//
//  Created by Darrin Mison on 26/06/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CHCocoaHeadsBrisbaneAPI.h"

@interface CHCocoaHeadsBrisbaneAPI_XCTests : XCTestCase

@end

@implementation CHCocoaHeadsBrisbaneAPI_XCTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(NSDictionary*)loadSampleEventJSON
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *url = [bundle pathForResource:@"meetup-event" ofType:@"json"];
    
    NSInputStream *is = [NSInputStream inputStreamWithFileAtPath:url];

    [is open];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithStream:is options:0 error:nil];
    [is close];
    return dict;
}

- (void)testGetVenueFromJSON
{
    CHCocoaHeadsBrisbaneAPI *api = [CHCocoaHeadsBrisbaneAPI sharedInstance];
    CHCoreData *cd = [CHCoreData sharedInstance];
    NSManagedObjectContext *context = [cd newManagedObjectContext];
    
    NSDictionary *json = [self loadSampleEventJSON];
    
    NSDictionary *venue = [json objectForKey:@"venue"];
    Venue *v = (Venue*)[api getVenueFromJSON:venue withContext:context];
    
    XCTAssertNotNil(v, @"venue was nil");
    XCTAssertTrue([v.name isEqualToString:@"River City Labs"], @"bad name: %@", v.name);
    
}

@end
