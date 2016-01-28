//
//  NSTimer+PKExtensions.h
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer(PKExtensions)

+(id) timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void(^)(NSTimeInterval time))block repeats:(BOOL)inRepeats;
+(id) scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void(^)(NSTimeInterval time))block repeats:(BOOL)inRepeats;

@end
