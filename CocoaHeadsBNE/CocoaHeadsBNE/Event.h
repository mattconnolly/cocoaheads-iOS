//
//  Event.h
//  CocoaHeadsBNE
//
//  Created by Roger Stephen on 13/04/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Venue;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSString * eventUrl;
@property (nonatomic, retain) NSNumber * headCount;
@property (nonatomic, retain) NSString * howToFindUs;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * maybeRsvpCount;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * ratingAverage;
@property (nonatomic, retain) NSNumber * ratingCount;
@property (nonatomic, retain) NSNumber * rsvpLimit;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSNumber * utcOffset;
@property (nonatomic, retain) NSString * visibility;
@property (nonatomic, retain) NSNumber * waitlistCount;
@property (nonatomic, retain) NSNumber * yesRsvpCount;
@property (nonatomic, retain) Venue *venue;

@end
