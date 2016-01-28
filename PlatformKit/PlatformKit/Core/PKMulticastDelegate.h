//
//  PKUUID.m
//  PlatformKit
//
//  Created by Thong Nguyen on 04/01/2012.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKMulticastDelegate : NSObject
{
@private
	Protocol* protocol;
	NSArray* delegates;
}

+(PKMulticastDelegate*) addDelegate:(id)delegate withTarget:(PKMulticastDelegate*)target forProtocol:(Protocol*)protocol;
+(PKMulticastDelegate*) removeDelegate:(id)delegate withTarget:(PKMulticastDelegate*)target forProtocol:(Protocol*)protocol;

@end

