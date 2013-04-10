//
//  NSString+PKExtensions.m
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import "NSString+PKExtensions.h"
#import <CommonCrypto/CommonDigest.h>

static unichar hexChars[16] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

@implementation NSString(PKExtensions)

+(BOOL) stringIsNilOrEmpty:(NSString*)value
{
    return value == nil || value.length == 0;
}

-(BOOL) containsString:(NSString*)stringToFind
{
	return ([self rangeOfString:stringToFind].location != NSNotFound);
}

-(NSData*) md5Data
{
    return [self md5DataWithEncoding:NSUTF8StringEncoding];
}

-(NSData*) md5DataWithEncoding:(NSStringEncoding)encoding
{
	unsigned char digest[16];
    const char* cStr = [self cStringUsingEncoding:encoding];

	CC_MD5(cStr, strlen(cStr), digest);
    
    return [NSData dataWithBytes:&digest[0] length:16];
}

-(NSString*) md5HexString
{
    return [self md5HexStringWithEncoding:NSUTF8StringEncoding];
}

-(NSString*) md5HexStringWithEncoding:(NSStringEncoding)encoding
{
	const char* cstr = [self cStringUsingEncoding:encoding];
    
    if (cstr == NULL)
    {
        return nil;
    }
    
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5(cstr, self.length, digest);
	
	unichar hexDigest[CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        hexDigest[(i * 2)] = hexChars[(digest[i] & 0xf0) >> 4];
        hexDigest[(i * 2) + 1] = hexChars[(digest[i] & 0x0f)];
    }
    
    return [[NSString alloc] initWithCharacters:hexDigest length:CC_MD5_DIGEST_LENGTH * 2];
}

-(NSString*) sha1HexString
{
    return [self sha1HexStringWithEncoding:NSUTF8StringEncoding];
}

-(NSString*) sha1HexStringWithEncoding:(NSStringEncoding)encoding
{
    const char* cstr = [self cStringUsingEncoding:encoding];
    
    if (cstr == NULL)
    {
        return nil;
    }
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(cstr, self.length, digest);
    
    unichar hexDigest[CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        hexDigest[(i * 2)] = hexChars[(digest[i] & 0xf0) >> 4];
        hexDigest[(i * 2) + 1] = hexChars[(digest[i] & 0x0f)];
    }
    
    return [[NSString alloc] initWithCharacters:hexDigest length:CC_SHA1_DIGEST_LENGTH * 2];
}

-(NSData*) sha1Data
{
    return [self sha1DataWithEncoding:NSUTF8StringEncoding];
}

-(NSData*) sha1DataWithEncoding:(NSStringEncoding)encoding
{
    int length = MIN(MAX(self.length, 0), INT_MAX);
    
    const char* cstr = [self cStringUsingEncoding:encoding];
    
    if (cstr == NULL)
    {
        return nil;
    }
    
    NSData* data = [NSData dataWithBytes:cstr length:length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    return [NSData dataWithBytes:&digest[0] length:20];
}

@end
