//
//  CHCocoaHeadsBrisbaneAPI.m
//  CocoaHeadsBNE
//
//  Created by Darrin Mison on 26/06/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import "CHCocoaHeadsBrisbaneAPI.h"

@implementation CHCocoaHeadsBrisbaneAPI

// Get the shared instance. Create it if required
+ (CHCocoaHeadsBrisbaneAPI *)sharedInstance {
    static CHCocoaHeadsBrisbaneAPI *sharedInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(Venue*)getVenueFromJSON:(NSDictionary *)json withContext:(NSManagedObjectContext*)context
{
    // ready to return
    Venue *v = nil;
    NSNumber *json_id = (NSNumber*)[json objectForKey:@"id"];
    
    // lets see if the json passed in has an id that we already have stored
    NSEntityDescription *venueDescription = [NSEntityDescription entityForName:@"Venue"
                                                        inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:venueDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", json_id ];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([results count] == 0)
    {
        // better make one then
        v = (Venue *)[NSEntityDescription insertNewObjectForEntityForName:@"Venue"
                                                          inManagedObjectContext:context];
    }
    else
    {
        // we already got one!
        v = (Venue*)[results objectAtIndex:0];
    }

    v.name = (NSString*)[json objectForKey:@"name"];
    v.id = json_id;
    v.address1 = (NSString*)[json objectForKey:@"address1"];
    v.city = (NSString*)[json objectForKey:@"city"];
    v.country = (NSString*)[json objectForKey:@"country"];
    v.lat = (NSNumber*)[json objectForKey:@"lat"];
    v.lon = (NSNumber*)[json objectForKey:@"lon"];
    v.repinned = [NSNumber numberWithBool:(BOOL)[json objectForKey:@"repinned"]];
    
    if (![context save:&error])
    {
        NSLog(@"failed to save new venue: %@", error);
    }

    return v;
}

@end
