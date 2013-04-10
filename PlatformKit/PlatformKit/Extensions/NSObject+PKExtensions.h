//
//  NSObject+PKExtensions.h
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(PKExtensions)

+(id) performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay;
+(void)cancelBlock:(id)block;

-(id) performBlock:(void(^)(id sender))block afterDelay:(NSTimeInterval)delay;

@end
