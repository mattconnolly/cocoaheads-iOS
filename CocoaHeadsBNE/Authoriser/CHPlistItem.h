//
//  CHPlistItem.h
//  CocoaHeadsBNE
//
//  Created by Matt Connolly on 9/05/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHCrypto;

@interface CHPlistItem : NSObject
{
    NSMutableDictionary* _dictionary;
}

@property (retain) CHCrypto* crypto;
@property (retain) NSString* key;
@property (retain) id value;
@property (assign) BOOL encrypted;

-(id)initWithKey:(NSString*)key inDictionary:(NSMutableDictionary*)dictionary;

@end
