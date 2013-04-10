//
//  NSDictionary+PKExtensions.m
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import "NSDictionary+PKExtensions.h"

@implementation NSDictionary (PKExtensions)

-(NSDictionary*) map:(id(^)(id key, id obj))block
{
    NSMutableDictionary* retval = [[NSMutableDictionary alloc] initWithCapacity:self.count];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop)
     {
         id newobj = block(key, obj);
         
         if (newobj == nil)
         {
             newobj = [NSNull null];
         }
         
         [retval setObject:newobj forKey:key];
     }];
    
    return retval;
}

-(NSDictionary*) select:(BOOL(^)(id key, id obj))block
{
    NSMutableDictionary* retval = [[NSMutableDictionary alloc] initWithCapacity:self.count];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop)
     {
         if (block(key, obj))
         {
             [retval setObject:obj forKey:key];
         }
     }];
    
    return retval;
}

@end
