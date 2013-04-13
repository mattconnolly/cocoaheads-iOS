//
//  CocoaHeadsBNETests.m
//  CocoaHeadsBNETests
//
//  Created by Matt Connolly on 16/03/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import "CocoaHeadsBNETests.h"
#import "CHCoreData.h"
#import "Group.h"

@implementation CocoaHeadsBNETests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    _testContext = [[CHCoreData sharedInstance] newManagedObjectContext];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    NSFetchRequest* fetch = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    NSError* error = nil;
    NSArray* results = [_testContext executeFetchRequest:fetch
                                                   error:&error];
    STAssertTrue(results.count == 0, @"no results in test database");
    STAssertNotNil(results, @"results returned an array");
    STAssertNil(error, @"no error in fetch request");
}

@end
