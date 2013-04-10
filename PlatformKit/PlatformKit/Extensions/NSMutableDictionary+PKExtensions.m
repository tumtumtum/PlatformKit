//
//  NSMutableDictionary+PKExtensions.m
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import "NSMutableDictionary+PKExtensions.h"

@implementation NSMutableDictionary (PKExtensions)

-(void) setObject:(id)value forKeyUnlessEitherNil:(id)key
{   
    if (value && key)
    {
        [self setObject:value forKey:key];
    }
}

@end
