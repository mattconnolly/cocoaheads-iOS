//
//  CHPlistItem.m
//  CocoaHeadsBNE
//
//  Created by Matt Connolly on 9/05/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import "CHPlistItem.h"
#import "CHCrypto.h"

@implementation CHPlistItem

-(id)initWithKey:(NSString*)key inDictionary:(NSMutableDictionary*)dictionary;
{
    self = [super init];
    if (self) {
        _dictionary = dictionary;
        _key = key;
    }
    return self;
}

-(id)value
{
    if (self.encrypted)
    {
        // decode:
        return [self.crypto decodeData:_dictionary[_key]];
    }
    else
    {
        // plain string
        return _dictionary[_key];
    }
}

-(void)setValue:(id)value
{
    [self willChangeValueForKey:@"value"];
    if (self.encrypted)
    {
        // encrypt new value
        _dictionary[_key] = [self.crypto encodeString:value];
    }
    else
    {
        // string value straigh tin
        _dictionary[_key] = value;
    }
    [self didChangeValueForKey:@"value"];
}

- (BOOL)encrypted
{
    return [_dictionary[_key] isKindOfClass:[NSData class]];
}

- (void)setEncrypted:(BOOL)encrypted
{
    NSLog(@"Changing encrypted: %d", encrypted);
    [self willChangeValueForKey:@"encrypted"];
    if (encrypted)
    {
        _dictionary[_key] = [self.crypto encodeString:_dictionary[_key]];
    }
    else
    {
        _dictionary[_key] = [self.crypto decodeData:_dictionary[_key]];
    }
    [self didChangeValueForKey:@"encrypted"];
}

@end
