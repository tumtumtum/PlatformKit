//
//  PKWebServiceClient.m
//  PlatformKit
//
//  Created by Thong Nguyen on 04/01/2013.
//  Copyright (c) 2013-2014 Thong Nguyen. All rights reserved.
//

#if !TARGET_OS_WATCH

#import <Foundation/Foundation.h>

#define kWebServiceResponse @"PKWebServiceResponse"
#define kWebServiceCallContext @"PKWebServiceCallContext"
#define kWebServiceClientClientSideError @"PKWebServiceClientClientSideError"

@class PKWebServiceClient;

@protocol PKWebServiceClientDelegate<NSObject>
-(id)webServiceClient:(PKWebServiceClient*)client createErrorResponseWithErrorCode : (NSString*)errorCode andMessage : (NSString*)message;
-(NSData*)webServiceClient:(PKWebServiceClient*)client serializeRequest : (id)requestObject;
-(id)webServiceClient:(PKWebServiceClient*)client parseResult : (NSData*)data withContentType : (NSString*)contentType andStatusCode : (int)statusCode;
@end

@interface PKWebServiceClient : NSObject

@property(readonly) NSDictionary* options;
@property(readonly) NSOperation* operationQueue;
@property(readwrite, weak) id<PKWebServiceClientDelegate> delegate;

+(PKWebServiceClient*)clientWithURL:(NSURL*)url options : (NSDictionary*)optionsIn operationQueue : (NSOperationQueue*)operationQueueIn;

-(id)getSynchronously;
-(void)getWithCallback:(void(^)(id))callback;
-(id)postSynchronouslyWithRequestObject:(id)requestObject;
-(void)postWithRequestObject:(id)requestObject andCallback : (void(^)(id))callback;

@end

#endif