//
//  NSTimer+PKExtensions.m
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import "NSTimer+PKExtensions.h"

@implementation NSTimer(PKExtensions)

+(id) scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void(^)(NSTimeInterval time))block repeats:(BOOL)inRepeats
{
	NSParameterAssert(block);
    
	return [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(privateExecuteBlockFromTimer:) userInfo:[block copy] repeats:inRepeats];
}

+(id) timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void(^)(NSTimeInterval time))block repeats:(BOOL)inRepeats
{
	NSParameterAssert(block);
    
	return [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(privateExecuteBlockFromTimer:) userInfo:[block copy] repeats:inRepeats];
}

+(void) privateExecuteBlockFromTimer:(NSTimer*)timer
{
	NSTimeInterval time = [timer timeInterval];
    
    void(^block)(NSTimeInterval) = timer.userInfo;
    
    block(time);
}

@end
