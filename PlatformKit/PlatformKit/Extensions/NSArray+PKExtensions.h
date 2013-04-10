//
//  NSArray+PKExtensions.h
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(PKExtensions)

-(NSArray*) map:(id(^)(id obj))block;
-(void) each:(void(^)(id obj))block;
-(void) eachSubArrayWithCount:(int)count andBlock:(void(^)(NSArray* subarray))block;
-(NSArray*) select:(BOOL(^)(id obj))block;
-(NSArray*) reject:(BOOL(^)(id obj))block;
-(NSDictionary*) toDictionaryWithKeySelector:(id(^)(id obj))keySelectorBlock andValueSelector:(id(^)(id obj))valueSelectorBlock;

@end
