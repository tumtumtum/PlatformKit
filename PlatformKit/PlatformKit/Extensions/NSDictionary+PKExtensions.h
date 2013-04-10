//
//  NSDictionary+PKExtensions.h
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (PKExtensions)

-(NSDictionary*) map:(id(^)(id key, id obj))block;
-(NSDictionary*) select:(BOOL(^)(id key, id obj))block;

@end
