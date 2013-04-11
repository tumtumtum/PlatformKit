//
//  PKUUID.m
//  PlatformKit
//
//  Created by Thong Nguyen on 04/01/2012.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import "PKMulticastDelegate.h"
#import <objc/runtime.h>

@implementation PKMulticastDelegate

-(id) initWithDelegates:(NSArray*)delegatesIn forProtocol:(Protocol*)protocolIn
{
	if (self = [super init])
	{
		protocol = protocolIn;
		delegates = delegatesIn;
	}
	
	return self;
}

-(void) forwardInvocation:(NSInvocation *)invocation
{
	for (id delegate in delegates)
	{
		if ([delegate respondsToSelector:invocation.selector])
		{
			[invocation invokeWithTarget:delegate];
		}
	}
}

-(NSMethodSignature*) methodSignatureForSelector:(SEL)selector
{
	NSMethodSignature* signature;	
	struct objc_method_description methodDescription;

	methodDescription = protocol_getMethodDescription(protocol, selector, YES, YES);
	
	if (methodDescription.name == 0)
	{
		methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
	}
	
	signature = [NSMethodSignature signatureWithObjCTypes: methodDescription.types];
	
	return signature;
}

+(PKMulticastDelegate*) addDelegate:(id)delegate withTarget:(PKMulticastDelegate*)target forProtocol:(Protocol*)protocol
{
	if (target == nil)
	{
		return [[PKMulticastDelegate alloc] initWithDelegates:[NSArray arrayWithObject:delegate] forProtocol:protocol];
	}
	
	NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:[target->delegates count] + 1];
	
	[array addObjectsFromArray:target->delegates];
	[array addObject:delegate];
	
	return [[PKMulticastDelegate alloc] initWithDelegates:array forProtocol:protocol];
}

+(PKMulticastDelegate*) removeDelegate:(id)delegate withTarget:(PKMulticastDelegate*)target forProtocol:(Protocol*)protocol
{
	if (target == nil)
	{
		return nil;
	}
	
	int count = [target->delegates count];
	
	if (count <= 1)
	{
		return nil;
	}
	
	NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:count - 1];
	
	for (NSObject* del in target->delegates)
	{
		if (![del isEqual:delegate])
		{
			[array addObject:del];
		}
	}
	
	return [[PKMulticastDelegate alloc] initWithDelegates:array forProtocol:protocol];
}

@end
