//
//  CHCocoaHeadsBrisbaneAPI.h
//  CocoaHeadsBNE
//
//  Created by Darrin Mison on 26/06/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCoreData.h"
#import "CHDataModels.h"

@interface CHCocoaHeadsBrisbaneAPI : NSObject

+ (CHCocoaHeadsBrisbaneAPI *)sharedInstance;


-(Venue*)getVenueFromJSON:(NSDictionary *)json
              withContext:(NSManagedObjectContext*)context;

//-(Event*)getEventFromJSON:(NSString *)json;

//-(Group*)getGroupFromJSON:(NSString *)json;


@end
