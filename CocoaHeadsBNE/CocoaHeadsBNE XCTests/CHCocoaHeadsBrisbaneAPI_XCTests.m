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
{
    NSManagedObjectContext *_context;
    CHCocoaHeadsBrisbaneAPI *_api;
    
    NSDictionary *_eventJSON;
}

@end

@implementation CHCocoaHeadsBrisbaneAPI_XCTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    _context = [[CHCoreData sharedInstance] newManagedObjectContext];
    _api = [CHCocoaHeadsBrisbaneAPI sharedInstance];
    
    _eventJSON = [self loadSampleJSONFile:@"meetup-event.json"];
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(NSDictionary*)loadSampleJSONFile:(NSString*)filename
{
    filename = [filename stringByDeletingPathExtension];

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *url = [bundle pathForResource:filename ofType:@"json"];
    
    NSInputStream *is = [NSInputStream inputStreamWithFileAtPath:url];
    [is open];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithStream:is options:0 error:nil];
    [is close];
    
    return dict;
}

#pragma mark - self tests
- (void)testLoadSampleJSONFile
{
    //"created": 1320183473000,
    //"time": 1364889600000,
    //"visibility": "public",

    NSDictionary *testData = [self loadSampleJSONFile:@"meetup-event.json"];
    
    NSNumber *created = (NSNumber*)[testData objectForKey:@"created"];
    NSNumber *time = (NSNumber*)[testData objectForKey:@"time"];
    NSString *visibility = (NSString*)[testData objectForKey:@"visibility"];
    
    XCTAssertTrue([created isEqualToNumber:[NSNumber numberWithDouble:1320183473000]], @"created value doesn't match");
    XCTAssertTrue([time isEqualToNumber:[NSNumber numberWithDouble:1364889600000]], @"time value doesn't match");
    XCTAssertTrue([visibility isEqualToString:@"public"], @"visibility value doesn't match");
}

#pragma mark - actual tests

- (void)testGetVenueFromJSON
{
    NSDictionary *venue = [_eventJSON objectForKey:@"venue"];
    Venue *v = (Venue*)[_api getVenueFromJSON:venue withContext:_context];
    
    XCTAssertNotNil(v, @"venue was nil");
    XCTAssertTrue([v.name isEqualToString:@"River City Labs"], @"bad name: %@", v.name);
    //TODO: add the remaining values to match
    
}

@end
