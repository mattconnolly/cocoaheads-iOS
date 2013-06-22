//
//  Venue.h
//  CocoaHeadsBNE
//
//  Created by Roger Stephen on 13/04/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Venue : NSManagedObject

@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * repinned;
@property (nonatomic, retain) NSSet *event;
@end

@interface Venue (CoreDataGeneratedAccessors)

- (void)addEventObject:(NSManagedObject *)value;
- (void)removeEventObject:(NSManagedObject *)value;
- (void)addEvent:(NSSet *)values;
- (void)removeEvent:(NSSet *)values;

@end
