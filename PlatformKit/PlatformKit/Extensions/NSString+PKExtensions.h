//
//  NSString+PKExtensions.h
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(PKExtensions)

+(BOOL) stringIsNilOrEmpty:(NSString*)value;

-(BOOL) containsString:(NSString*)stringToFind;
-(NSString*) md5HexString;
-(NSData*) md5Data;
-(NSData*) md5DataWithEncoding:(NSStringEncoding)encoding;
-(NSString*) sha1HexString;
-(NSData*) sha1Data;
-(NSData*) sha1DataWithEncoding:(NSStringEncoding)encoding;
-(NSString*) appendUrlComponent:(NSString*)right;

@end
