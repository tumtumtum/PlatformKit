//
//  NSMutableArray+PKExtensions.m
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import "NSMutableArray+PKExtensions.h"

@implementation NSMutableArray (PKExtensions)

-(void) addObjectUnlessNil:(id)value
{
    if (value)
    {
        [self addObject:value];
    }
}

@end
