//
//  NSObject+PKExtensions.m
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import "NSObject+PKExtensions.h"

@implementation NSObject(PKExtensions)

+(id) performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay
{
	NSParameterAssert(block != nil);
	
	__block BOOL cancelled = NO;
	
	void(^wrapper)(BOOL) = ^(BOOL cancel)
    {
		if (cancel)
        {
			cancelled = YES;
			return;
		}
        
		if (!cancelled)
        {
            block();
        }
	};
	
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * (double)NSEC_PER_SEC);
    
	dispatch_after(time, dispatch_get_main_queue(), ^{ wrapper(NO); });
	
	return wrapper;
}

-(id) performBlock:(void(^)(id sender))block afterDelay:(NSTimeInterval)delay
{
	NSParameterAssert(block != nil);
	
	__block BOOL cancelled = NO;
	
	void(^wrapper)(BOOL) = ^(BOOL cancel)
    {
		if (cancel)
        {
			cancelled = YES;
			return;
		}
        
		if (!cancelled)
        {
            block(self);
        }
	};
	
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * (double)NSEC_PER_SEC);
    
	dispatch_after(time, dispatch_get_main_queue(), ^{ wrapper(NO); });
	
	return wrapper;
}

+(void)cancelBlock:(id)block
{
	NSParameterAssert(block != nil);
    
	void(^wrapper)(BOOL) = block;
    
	wrapper(YES);
}

@end
