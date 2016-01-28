//
//  NSMutableSet+PKExtensions.h
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableSet (PKExtensions)

-(id) initWithArray:(NSArray*)array map:(id(^)(id obj))block;
-(void) addObjectUnlessNil:(id)object;

@end
