//
//  Group.h
//  CocoaHeadsBNE
//
//  Created by Roger Stephen on 13/04/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSNumber * groupLat;
@property (nonatomic, retain) NSNumber * groupLon;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * joinMode;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * urlName;
@property (nonatomic, retain) NSString * who;
@property (nonatomic, retain) Event *event;

@end
