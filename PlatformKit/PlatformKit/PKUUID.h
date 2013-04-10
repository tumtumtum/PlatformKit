//
//  PKUUID.h
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    PKUUIDFormatCompact = 0,
    PKUUIDFormatIncludeDashes = 1,
    PKUUIDFormatIncludeBraces = 2,
    PKUUIDFormatIncludeParenthesis = 4,
    PKUUIDFormatUpperCase = 8,
    PKUUIDFormatDashed = PKUUIDFormatIncludeDashes,
    PKUUIDFormatBraces = PKUUIDFormatIncludeDashes | PKUUIDFormatIncludeBraces,
    PKUUIDFormatParenthesis = PKUUIDFormatIncludeDashes | PKUUIDFormatIncludeParenthesis
}
PKUUIDFormat;

@interface PKUUID : NSObject<NSCoding>
{
@private
    UInt8 data[16];
}

-(id) initWithString:(NSString*)string;
-(id) initWithBytes:(UInt8[16])bytes;
-(NSString*) stringValue;
-(CFUUIDBytes) uuidBytes;
-(void) byteDataToBuffer:(UInt8*)bytes;
-(NSString*) stringValueWithFormat:(PKUUIDFormat)format;
-(BOOL) isEmpty;
-(BOOL) isEqual:(id)object;
-(NSUInteger) hash;
-(NSString*) description;

+(PKUUID*) randomUUID;
+(PKUUID*) emptyUUID;
+(PKUUID*) uuidFromString:(NSString*)uuidString;

@end
