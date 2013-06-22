//
//  CHCoreData.h
//  CocoaHeadsBNE
//
//  Created by Roger Stephen on 13/04/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHCoreData : NSObject


+ (CHCoreData *)sharedInstance;

@property (readonly,strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly,strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSManagedObjectContext*)newManagedObjectContext;

@end
