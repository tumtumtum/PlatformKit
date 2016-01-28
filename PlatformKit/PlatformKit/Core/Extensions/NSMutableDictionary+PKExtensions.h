//
//  NSMutableDictionary+PKExtensions.h
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (PKExtensions)

-(void) setObject:(id)value forKeyUnlessEitherNil:(id)key;

@end
