//
//  NSArray+PKExtensions.m
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import "NSArray+PKExtensions.h"

@implementation NSArray(PKExtensions)

-(NSArray*) map:(id(^)(id obj))block
{
    NSMutableArray* retval = [[NSMutableArray alloc] initWithCapacity:[self count]];
    
    for (id obj in self)
    {
        id newObj = block(obj);
        
        if (newObj == nil)
        {
            newObj = [NSNull null];
        }
        
        [retval addObject:newObj];
    }
    
    return retval;
}

-(void) each:(void(^)(id obj))block
{
    for (id obj in self)
    {
        block(obj);
    }
}

-(NSDictionary*) toDictionaryWithKeySelector:(id(^)(id value))keySelectorBlock andValueSelector:(id(^)(id value))valueSelectorBlock
{
	NSMutableDictionary* retVal = [NSMutableDictionary dictionaryWithCapacity:self.count];
	
	for (id object in self)
	{
		[retVal setObject:valueSelectorBlock(object) forKey:keySelectorBlock(object)];
	}
	
	return retVal;
}

-(NSArray*) select:(BOOL(^)(id obj))block
{
    NSMutableArray* retval = [[NSMutableArray alloc] initWithCapacity:self.count];
    
    for (id obj in self)
    {
        if (block(obj))
        {
            [retval addObject:obj];
        }
    }
    
    return retval;
}

-(NSArray*) reject:(BOOL(^)(id obj))block
{
    NSMutableArray* retval = [[NSMutableArray alloc] initWithCapacity:self.count];
    
    for (id obj in self)
    {
        if (!block(obj))
        {
            [retval addObject:obj];
        }
    }
    
    return retval;
}

-(void) eachSubArrayWithCount:(int)count andBlock:(void(^)(NSArray* subarray))block
{
    int globalIndex = 0;
    
    if (count == 0)
    {
        return;
    }
    
    for (int j = 0; j < (self.count + count) / count; j++)
    {
        NSMutableArray* subArray = [[NSMutableArray alloc] initWithCapacity:count];
        
        for (int i = 0; i < count && globalIndex < self.count; i++, globalIndex++)
        {
            [subArray addObjectUnlessNil:[self objectAtIndex:globalIndex]];
        }
        
        block(subArray);
    }
}

@end
