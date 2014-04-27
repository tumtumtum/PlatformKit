//
//  PKWebServiceClient.m
//  PlatformKit
//
//  Created by Thong Nguyen on 04/01/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kWebServiceResponse @"PKWebServiceResponse"
#define kWebServiceCallContext @"PKWebServiceCallContext"
#define kWebServiceClientClientSideError @"PKWebServiceClientClientSideError"

@class PKWebServiceClient;

@protocol PKWebServiceClientDelegate<NSObject>
-(id) webServiceClient:(PKWebServiceClient*)client createErrorResponseWithErrorCode:(NSString*)errorCode andMessage:(NSString*)message;
-(NSData*) webServiceClient:(PKWebServiceClient*)client serializeRequest:(id)requestObject;
-(id) webServiceClient:(PKWebServiceClient*)client parseResult:(NSData*)data withContentType:(NSString*)contentType andStatusCode:(int)statusCode;
@end

@interface PKWebServiceClient : NSObject
{
	id context;
    NSString* host;	
	NSString* gatewayName;
	NSString* queryString;
	NSOperationQueue* operationQueue;
}

@property (readonly) id context;
@property (readonly) NSString* host;
@property (readonly) NSString* gatewayName;
@property (readonly) NSString* queryString;
@property (readonly) NSOperation* operationQueue;
@property (readonly, weak) id<PKWebServiceClientDelegate> delegate;

+(PKWebServiceClient*) clientWithHost:(NSString*)hostIn gatewayName:(NSString*)gatewayNameIn queryString:(NSString*)queryStringIn context:(id)contextIn operationQueue:(NSOperationQueue*)operationQueue;

-(id) getSynchronously;
-(void) getWithCallback:(void(^)(id))callback;
-(id) postSynchronouslyWithRequestObject:(id)requestObject;
-(void) postWithRequestObject:(id)requestObject andCallback:(void(^)(id))callback;

@end
