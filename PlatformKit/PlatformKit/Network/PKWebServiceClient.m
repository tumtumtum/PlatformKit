//
//  PKWebServiceClient.h
//  PlatformKit
//
//  Created by Thong Nguyen on 04/01/2013.
//  Copyright (c) 2013-2014 Thong Nguyen. All rights reserved.
//

#if !TARGET_OS_WATCH

#import "PKWebServiceClient.h"
#import <CommonCrypto/CommonDigest.h>
#import <zlib.h>
#import "NSString+PKExtensions.h"

static NSOperationQueue* defaultOperationQueue;

@interface PKWebServiceClient()
{
@private
    NSURL* url;
    NSDictionary* options;
    NSOperationQueue* operationQueue;
}
@end

@implementation PKWebServiceClient

+(void) initialize
{
    defaultOperationQueue = [[NSOperationQueue alloc] init];
	
    [defaultOperationQueue setMaxConcurrentOperationCount:32];
}

-(id) createErrorResponseWithErrorCode:(NSString*)errorCode andMessage:(NSString*)message
{
	return [self.delegate webServiceClient:self createErrorResponseWithErrorCode:errorCode andMessage:message];
}

-(NSOperationQueue*) operationQueue
{
	return operationQueue;
}

-(id) initWithURL:(NSURL*)urlIn options:(NSDictionary*)optionsIn operationQueue:(NSOperationQueue*)operationQueueIn
{
	if ((self = [self init]))
	{
        self->url = urlIn;
        self->options = optionsIn;

		if (operationQueueIn)
		{
			operationQueue = operationQueueIn;
        }
		else
		{
			operationQueue = defaultOperationQueue;
        }
	}

    return self;
}

-(NSDictionary*) options
{
	return options;
}

+(PKWebServiceClient*) clientWithURL:(NSURL*)url options:(NSDictionary*)optionsIn operationQueue:(NSOperationQueue*)operationQueueIn
{
	PKWebServiceClient* request = [[PKWebServiceClient alloc] initWithURL:url options:optionsIn operationQueue:operationQueueIn];
    
    return request;
}

-(CFReadStreamRef) newReadStreamForGet
{
    return [self newReadStreamWithPostData:nil];
}


-(CFReadStreamRef) newReadStreamForPostWithRequestObject:(id)requestObject
{
    NSData* postData = [self.delegate webServiceClient:self serializeRequest:requestObject];
	
	if (!postData)
	{
		return NULL;
	}

    return [self newReadStreamWithPostData:postData];
}

-(CFReadStreamRef) newReadStreamWithPostData:(NSData*)postData
{
    CFReadStreamRef stream;
    NSString* requestMethod = postData ? @"POST" : @"GET";
    CFHTTPMessageRef message = CFHTTPMessageCreateRequest(NULL, (__bridge CFStringRef)requestMethod, (__bridge CFURLRef)url, kCFHTTPVersion1_1);

	if (message == 0)
	{
		return 0;
	}

    CFHTTPMessageSetHeaderFieldValue(message, CFSTR("Content-Type"), (__bridge CFStringRef)@"application/json");
    CFHTTPMessageSetHeaderFieldValue(message, CFSTR("Accept"), (__bridge CFStringRef)@"application/json,*/*;");
    CFHTTPMessageSetHeaderFieldValue(message, CFSTR("Accept-Encoding"), (__bridge CFStringRef)@"gzip");

	for (NSString* key in options.allKeys)
	{
		if ([key hasPrefix:@"Header/"])
		{
			NSString* value = [options objectForKey:key];
			NSString* header = [key substringFromIndex:@"Header/".length];
			
			CFHTTPMessageSetHeaderFieldValue(message, (__bridge CFStringRef)header, (__bridge CFStringRef)value);
		}
	}
	
    if (postData)
    {
        CFHTTPMessageSetHeaderFieldValue(message, CFSTR("Content-Length"), (__bridge CFStringRef)[NSString stringWithFormat:@"%d", (int)postData.length]);
        CFHTTPMessageSetBody(message, (__bridge CFDataRef)postData);
    }

    stream = CFReadStreamCreateForHTTPRequest(NULL, message);

	if (stream == 0)
	{
		CFRelease(message);

		return 0;
	}

	if (!CFReadStreamSetProperty(stream, kCFStreamPropertyHTTPShouldAutoredirect, kCFBooleanTrue))
    {
		CFReadStreamClose(stream);
		CFRelease(stream);
        CFRelease(message);

        return 0;
    }

    CFDictionaryRef proxySettings = CFNetworkCopySystemProxySettings();
    CFReadStreamSetProperty(stream, kCFStreamPropertyHTTPProxy, proxySettings);
    CFRelease(proxySettings);

    if ([url.scheme caseInsensitiveCompare:@"https"] == NSOrderedSame)
    {
		BOOL disableCertificateValidation = [[options objectForKey:@"SSL/Disable-Certificate-Chain-Validation"] boolValue];

		if (disableCertificateValidation)
		{
			NSDictionary* sslSettings = [NSDictionary dictionaryWithObjectsAndKeys:
				(NSString*)kCFStreamSocketSecurityLevelNegotiatedSSL, kCFStreamSSLLevel,
				[NSNumber numberWithBool: NO], kCFStreamSSLValidatesCertificateChain,
				[NSNull null], kCFStreamSSLPeerName, nil];
		
			CFReadStreamSetProperty(stream, kCFStreamPropertySSLSettings, (CFTypeRef)sslSettings);
		}
    }

    CFRelease(message);

    return stream;
}

-(id) createStreamCreationFailResponse
{
    return [self createErrorResponseWithErrorCode:kWebServiceClientClientSideError andMessage:@"Unable to connect to server (CFReadStream error)"];
}

-(void)makeRequestWithReadStream:(CFReadStreamRef)readStream andCallback:(void(^)(id))callbackIn andWaitForFinish:(BOOL)waitForFinish andCallbackInMainThread:(BOOL)callbackInMainThread
{
	NSAssert([NSThread currentThread] == [NSThread mainThread], ([NSString stringWithFormat:@"Asynchronous service calls (query: %@) currently need to be made on the UI thread (thread: %@)", [url description], [[NSThread currentThread] name]]));

	void(^callback)(id) = NULL;

	if (callbackIn)
	{
		callback = [callbackIn copy];
	}

    if (readStream)
    {
        CFRetain(readStream);
    }

    NSOperation* operation = [NSBlockOperation blockOperationWithBlock:^
	{
		// Open
		if (!readStream || !CFReadStreamOpen(readStream))
		{
            if (readStream)
            {
                CFRelease(readStream);
            }
        
   			if (callback)
			{
                id response = [self createStreamCreationFailResponse];

				dispatch_async(dispatch_get_main_queue(), ^
				{
					callback(response);
				});
			}
		
			return;
		}

		NSMutableData* data;
		UInt8 firstByte = 0;
		id response = nil;
		
		@autoreleasepool
        {
            int result = (int)CFReadStreamRead(readStream, &firstByte, 1);

            if (result <= 0)
            {
                CFErrorRef error = CFReadStreamCopyError(readStream);

                NSString* errorDescription = result == 0 ? @"no data" : @"unknown socket error";
                
                if (error)
                {
                    errorDescription = (__bridge_transfer NSString*)CFErrorCopyDescription(error);
                }

                response = [self createErrorResponseWithErrorCode:kWebServiceClientClientSideError andMessage:errorDescription];

                if (error)
                {
                    CFRelease(error);
                }
            }
            else
            {
                CFHTTPMessageRef httpResponse = (CFHTTPMessageRef)CFReadStreamCopyProperty(readStream, kCFStreamPropertyHTTPResponseHeader);
                
                int length;
                z_stream z;
                BOOL compressed = NO;
                NSString* contentLengthAsString = (__bridge_transfer NSString*)CFHTTPMessageCopyHeaderFieldValue(httpResponse, (CFStringRef)@"Content-Length");
                NSString* encoding = (__bridge_transfer NSString*)CFHTTPMessageCopyHeaderFieldValue(httpResponse, (CFStringRef)@"Content-Encoding");
                NSString* contentType = (__bridge_transfer NSString*)CFHTTPMessageCopyHeaderFieldValue(httpResponse, (CFStringRef)@"Content-Type");
                int statusCode = (int)CFHTTPMessageGetResponseStatusCode(httpResponse);

                CFRelease(httpResponse);
                    
                if (encoding != nil)
                {
                    NSString* trimmedEncoding = [encoding stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

                    if ([trimmedEncoding caseInsensitiveCompare:@"gzip"] == NSOrderedSame
                        || [trimmedEncoding caseInsensitiveCompare:@"deflate"] == NSOrderedSame)
                    {
                        compressed = YES;

                        z.zalloc = Z_NULL;
                        z.zfree = Z_NULL;
                        z.opaque = Z_NULL;
                        z.avail_in = 0;
                        z.next_in = Z_NULL;

                        int result = inflateInit2(&z, 15 + 32);

                        if (result != Z_OK)
                        {
                            response = [self createErrorResponseWithErrorCode:kWebServiceClientClientSideError andMessage:@"ZlibInitError"];
                        }
                    }
                    else
                    {
                        response = [self createErrorResponseWithErrorCode:kWebServiceClientClientSideError andMessage:[NSString stringWithFormat:@"UnsupportedEncoding: %@", trimmedEncoding]];
                    }
                }	

                if (contentLengthAsString == nil || contentLengthAsString.length == 0)
                {
                    length = 64 * 1024;
                }
                else
                {
                    length = [contentLengthAsString intValue];
                }
                
                if (response == nil)
                {
                    UInt8 buffer[8192];
                    UInt8* outbuffer = 0;
                    int sizeOfOutBuffer = 0;
                    data = [NSMutableData dataWithCapacity:compressed ? length : length * 3];

                    if (compressed)
                    {
                        z.avail_in = 1;
                        z.next_in = &firstByte;
                        sizeOfOutBuffer = 8192 * 2;
                        outbuffer = alloca(sizeOfOutBuffer);

                        z.avail_out = sizeOfOutBuffer;
                        z.next_out = &outbuffer[0];

                        result = inflate(&z, Z_SYNC_FLUSH);

                        switch (result)
                        {
                            case Z_NEED_DICT:
                                response = [self createErrorResponseWithErrorCode:kWebServiceClientClientSideError andMessage:@"ZLIB_NEED_DICT_FIRST_BYTE"];
                                break;
                            case Z_DATA_ERROR:
                                response = [self createErrorResponseWithErrorCode:kWebServiceClientClientSideError andMessage:@"ZLIB_DATA_ERROR_FIRST_BYTE"];
                                break;
                            case Z_MEM_ERROR:
                                response = [self createErrorResponseWithErrorCode:kWebServiceClientClientSideError andMessage:@"ZLIB_MEM_ERROR_FIRST_BYTE"];
                                break;
                            case Z_STREAM_END:
                                break;
                        }

                        [data appendBytes:&outbuffer[0] length:sizeOfOutBuffer - z.avail_out];
                    }
                    else
                    {
                        [data appendBytes:&firstByte length:1];
                    }

                    while (response == nil)
                    {
                        result = (int)CFReadStreamRead(readStream, &buffer[0], sizeof(buffer));

                        if (result == 0)
                        {
                            break;
                        }
                        else if (result < 0)
                        {
                            CFErrorRef error = CFReadStreamCopyError(readStream);

                            NSString* errorDescription = @"Unknown socket error";

                            if (error)
                            {
                                errorDescription = (__bridge_transfer NSString*)CFErrorCopyDescription(error);
                            }

                            response = [self createErrorResponseWithErrorCode:kWebServiceClientClientSideError andMessage:errorDescription];

                            if (error)
                            {					
                                CFRelease(error);
                            }

                            break;
                        }

                        if (compressed)
                        {
                            z.avail_in = result;
                            z.next_in = &buffer[0];

                            do
                            {
                                z.avail_out = sizeOfOutBuffer;
                                z.next_out = &outbuffer[0];

                                result = inflate(&z, Z_SYNC_FLUSH);

                                switch (result)
                                {
                                    case Z_NEED_DICT:
                                        response = [self createErrorResponseWithErrorCode:kWebServiceClientClientSideError andMessage:@"ZLIB_NEED_DICT"];
                                        break;
                                    case Z_DATA_ERROR:
                                        response = [self createErrorResponseWithErrorCode:kWebServiceClientClientSideError andMessage:@"ZLIB_DATA_ERROR"];
                                        break;
                                    case Z_MEM_ERROR:
                                        response = [self createErrorResponseWithErrorCode:kWebServiceClientClientSideError andMessage:@"ZLIB_MEM_ERROR"];
                                        break;
                                    case Z_STREAM_END:
                                        break;
                                }

                                [data appendBytes:&outbuffer[0] length:sizeOfOutBuffer - z.avail_out];
                            }
                            while (z.avail_out == 0 && response == nil);
                        }
                        else
                        {
                            [data appendBytes:&buffer[0] length:result];
                        }
                    }

                    if (compressed)
                    {
                        inflateEnd(&z);
                    }
                }

                if (response == nil)
                {
                    response = [self parseResult:data withContentType:contentType andStatusCode:statusCode];
                }
            }
        }

		CFReadStreamClose(readStream);
		CFRelease(readStream);

		if (callback)
		{
			if (callbackInMainThread)
			{
				dispatch_async(dispatch_get_main_queue(), ^
				{
					callback(response);
				});
			}
			else
			{
				callback(response);
			}
		}
	}];

    [operationQueue addOperation:operation];

    if (waitForFinish)
    {
        [operation waitUntilFinished];
    }
}

-(void)getWithCallback:(void(^)(id))callbackIn
{
	CFReadStreamRef readStream = [self newReadStreamForGet];

    [self makeRequestWithReadStream:readStream andCallback:callbackIn andWaitForFinish:NO andCallbackInMainThread:YES];

	if (readStream != 0)
	{
		CFRelease(readStream);
	}
}

-(id) getSynchronously
{
	__block id retval = nil;
	CFReadStreamRef readStream = [self newReadStreamForGet];

    [self makeRequestWithReadStream:readStream andCallback:^(id response)
	{
		retval = response;
	}
	andWaitForFinish:YES andCallbackInMainThread:NO];

	if (readStream != 0)
	{
		CFRelease(readStream);
	}

	return retval;
}

-(void) postWithRequestObject:(id)requestObject andCallback:(void(^)(id))callbackIn
{
	CFReadStreamRef readStream = [self newReadStreamForPostWithRequestObject:requestObject];

    [self makeRequestWithReadStream:readStream andCallback:callbackIn andWaitForFinish:NO andCallbackInMainThread:YES];

	if (readStream != 0)
	{
		CFRelease(readStream);
	}
}

-(id) postSynchronouslyWithRequestObject:(id)requestObject
{
	__block id retval = nil;
	CFReadStreamRef readStream = [self newReadStreamForPostWithRequestObject:requestObject];

    [self makeRequestWithReadStream:readStream andCallback:^(id response)
	{
		retval = response;
	}
	andWaitForFinish:YES andCallbackInMainThread:NO];

	if (readStream != 0)
	{
		CFRelease(readStream);
	}

	return retval;
}

-(id) parseResult:(NSData*)data withContentType:(NSString*)contentType andStatusCode:(int)statusCode
{
	id response = [self.delegate webServiceClient:self parseResult:data withContentType:contentType andStatusCode:statusCode];
	
	return response;
}

@end

#endif