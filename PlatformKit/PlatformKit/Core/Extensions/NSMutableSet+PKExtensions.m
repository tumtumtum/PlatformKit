//
//  NSMutableSet+PKExtensions.m
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import "NSMutableSet+PKExtensions.h"

@implementation NSMutableSet (PKExtensions)

-(id) initWithArray:(NSArray*)array map:(id(^)(id obj))block
{
    if (array == nil)
    {
        return [self init];
    }
    
    if (self = [self initWithCapacity:array.count])
    {
        for (id obj in array)
        {
            [self addObject:block(obj)];
        }
    }
    
    return self;
}

-(void) addObjectUnlessNil:(id)object
{
    if (object)
    {
        [self addObject:object];
    }
}

@end
