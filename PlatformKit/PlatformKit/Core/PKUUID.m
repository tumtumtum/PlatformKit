//
//  PKUUID.m
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import "PKUUID.h"

#define ConvertToHexCharLower(x) (((x) >= 0 && (x) <= 9) ? (char)((x) + '0') : (char)((x) - 10 + 'a'))
#define ConvertToHexCharUpper(x) (((x) >= 0 && (x) <= 9) ? (char)((x) + '0') : (char)((x) - 10 + 'A'))
#define IsHexChar(x) ((((x) >= '0' && (x) <= '9') || ((x) >= 'a' && (x) <= 'f') || ((x) >= 'A' && (x) <= 'F')))

@interface PKUUID()
-(id) initWithCFUUIDBytes:(CFUUIDBytes)bytes;
-(id) initWithBytePointer:(unsigned char*)bytes;
+(BOOL) uuidBytesFromString:(NSString*)uuidString bytes:(UInt8*)bytes;
@end

@implementation PKUUID

-(id) initWithCoder:(NSCoder*)decoder
{
	if (self = [super init])
	{
		NSUInteger length;
		
		const uint8_t* bytes = [decoder decodeBytesForKey:@"data" returnedLength:&length];
		
		if (length == 16)
		{
			memcpy(data, bytes, length);
		}
	}
	
	return self;
}

-(void) encodeWithCoder:(NSCoder*)coder
{
	[coder encodeBytes:&data[0] length:16 forKey:@"data"];
}

+(PKUUID*) emptyUUID
{
	static PKUUID* retval;
	
	if (retval == nil)
	{
		retval = [[PKUUID alloc] init];
	}
	
	return retval;
}

-(id) initWithBytes:(UInt8[16])bytes
{
    return [self initWithBytePointer:&bytes[0]];
}

-(id) initWithCFUUIDBytes:(CFUUIDBytes)bytes
{
	if (self = [super init])
	{
		memcpy(data, &bytes, 16);
	}
	
	return self;
}

-(id) initWithBytePointer:(UInt8*)bytes
{
    if (self = [super init])
    {
		memcpy(data, bytes, 16);
    }
    
    return self;
}

-(id) initWithString:(NSString*)string
{
    if (self = [super init])
    {
		if (![PKUUID uuidBytesFromString:string bytes:&data[0]])
		{
			[NSException raise:@"UUID wrong format" format:@"The string %@ is not a value UUID", string];
		}
    }
    
    return self;
}

-(NSString*) stringValueWithFormat:(PKUUIDFormat)format
{
	int index = 0;
	unichar buffer[32 + 4 + 2];
	
	if (format & PKUUIDFormatIncludeBraces)
	{
		buffer[index++] = '{';
	}
	else if (format & PKUUIDFormatIncludeParenthesis)
	{
		buffer[index++] = '(';
	}
	
	if (format & PKUUIDFormatUpperCase)
	{
		if (format & PKUUIDFormatIncludeDashes)
		{
			for (int i = 0; i < 4; i++)
			{
				unsigned char c = data[i];
				unsigned char c1 = c & 0x0f;
				unsigned char c2 = (c & 0xf0) >> 4;
				
				buffer[index++] = ConvertToHexCharUpper(c2);
				buffer[index++] = ConvertToHexCharUpper(c1);
			}
			
			buffer[index++] = '-';
			
			for (int i = 4; i < 6; i++)
			{
				unsigned char c = data[i];
				unsigned char c1 = c & 0x0f;
				unsigned char c2 = (c & 0xf0) >> 4;
				
				buffer[index++] = ConvertToHexCharUpper(c2);
				buffer[index++] = ConvertToHexCharUpper(c1);
			}
			
			buffer[index++] = '-';
			
			for (int i = 6; i < 8; i++)
			{
				unsigned char c = data[i];
				unsigned char c1 = c & 0x0f;
				unsigned char c2 = (c & 0xf0) >> 4;
				
				buffer[index++] = ConvertToHexCharUpper(c2);
				buffer[index++] = ConvertToHexCharUpper(c1);
			}
			
			buffer[index++] = '-';
			
			for (int i = 8; i < 10; i++)
			{
				unsigned char c = data[i];
				unsigned char c1 = c & 0x0f;
				unsigned char c2 = (c & 0xf0) >> 4;
				
				buffer[index++] = ConvertToHexCharUpper(c2);
				buffer[index++] = ConvertToHexCharUpper(c1);
			}
			
			buffer[index++] = '-';
			
			for (int i = 10; i < 16; i++)
			{
				unsigned char c = data[i];
				unsigned char c1 = c & 0x0f;
				unsigned char c2 = (c & 0xf0) >> 4;
				
				buffer[index++] = ConvertToHexCharUpper(c2);
				buffer[index++] = ConvertToHexCharUpper(c1);
			}
		}
		else
		{
			for (int i = 0; i < 16; i++)
			{
				unsigned char c = data[i];
				unsigned char c1 = c & 0x0f;
				unsigned char c2 = (c & 0xf0) >> 4;
				
				buffer[index++] = ConvertToHexCharUpper(c2);
				buffer[index++] = ConvertToHexCharUpper(c1);
			}
		}
	}
	else
	{
		if (format & PKUUIDFormatIncludeDashes)
		{
			for (int i = 0; i < 4; i++)
			{
				unsigned char c = data[i];
				unsigned char c1 = c & 0x0f;
				unsigned char c2 = (c & 0xf0) >> 4;
				
				buffer[index++] = ConvertToHexCharLower(c2);
				buffer[index++] = ConvertToHexCharLower(c1);
			}
			
			buffer[index++] = '-';
			
			for (int i = 4; i < 6; i++)
			{
				unsigned char c = data[i];
				unsigned char c1 = c & 0x0f;
				unsigned char c2 = (c & 0xf0) >> 4;
				
				buffer[index++] = ConvertToHexCharLower(c2);
				buffer[index++] = ConvertToHexCharLower(c1);
			}
			
			buffer[index++] = '-';
			
			for (int i = 6; i < 8; i++)
			{
				unsigned char c = data[i];
				unsigned char c1 = c & 0x0f;
				unsigned char c2 = (c & 0xf0) >> 4;
				
				buffer[index++] = ConvertToHexCharLower(c2);
				buffer[index++] = ConvertToHexCharLower(c1);
			}
			
			buffer[index++] = '-';
			
			for (int i = 8; i < 10; i++)
			{
				unsigned char c = data[i];
				unsigned char c1 = c & 0x0f;
				unsigned char c2 = (c & 0xf0) >> 4;
				
				buffer[index++] = ConvertToHexCharLower(c2);
				buffer[index++] = ConvertToHexCharLower(c1);
			}
			
			buffer[index++] = '-';
			
			for (int i = 10; i < 16; i++)
			{
				unsigned char c = data[i];
				unsigned char c1 = c & 0x0f;
				unsigned char c2 = (c & 0xf0) >> 4;
				
				buffer[index++] = ConvertToHexCharLower(c2);
				buffer[index++] = ConvertToHexCharLower(c1);
			}
		}
		else
		{
			for (int i = 0; i < 16; i++)
			{
				unsigned char c = data[i];
				unsigned char c1 = c & 0x0f;
				unsigned char c2 = (c & 0xf0) >> 4;
				
				buffer[index++] = ConvertToHexCharLower(c2);
				buffer[index++] = ConvertToHexCharLower(c1);
			}
		}
	}
	if (format & PKUUIDFormatIncludeBraces)
	{
		buffer[index++] = '}';
	}
	else if (format & PKUUIDFormatIncludeParenthesis)
	{
		buffer[index++] = ')';
	}
    
	return [NSString stringWithCharacters:buffer length:index];
}

+(PKUUID*) randomUUID
{
	CFUUIDRef uuid = CFUUIDCreate(0);
	CFUUIDBytes bytes = CFUUIDGetUUIDBytes(uuid);
	CFRelease(uuid);
	
	PKUUID* retval = [[PKUUID alloc] initWithCFUUIDBytes:bytes];
	
	return retval;
}

+(PKUUID*) uuidFromString:(NSString*)uuidString
{
	UInt8 bytes[16];
	
	if ([self uuidBytesFromString:uuidString bytes:&bytes[0]])
	{
		return [[PKUUID alloc] initWithBytes:bytes];
	}
	
	return nil;
}

+(BOOL) uuidBytesFromString:(NSString*)uuidString bytes:(UInt8*)bytes
{
	int offset = 0;
	int length = (int)uuidString.length;
	
	if (uuidString == nil || length == 0)
	{
		return NO;
	}
	
	char firstChar = [uuidString characterAtIndex:0];
	memset(bytes, 0, 16);
    
    if (firstChar == '{')
    {
		if (length == 0x26)
		{
			if ([uuidString characterAtIndex:0x25] != '}')
			{
				return NO;
			}
		}
		else if (length == 0x22)
		{
			if ([uuidString characterAtIndex:0x21] != '}')
			{
				return NO;
			}
		}
		else
		{
			return NO;
		}
        
        offset = 1;
    }
    else if (firstChar == '(')
    {
        if (length == 0x26)
		{
			if ([uuidString characterAtIndex:0x25] != ')')
			{
				return NO;
			}
		}
		else if (length == 0x22)
		{
			if ([uuidString characterAtIndex:0x21] != ')')
			{
				return NO;
			}
		}
		else
		{
			return NO;
		}
        
        offset = 1;
    }
    else if (length != 0x24 && length != 0x20)
    {
        return NO;
    }
	
	if ((offset == 1 && length == 0x26) || (offset == 0 && length == 0x24))
	{
		if ((([uuidString characterAtIndex:8 + offset] != '-') || ([uuidString characterAtIndex:13 + offset] != '-'))
			|| (([uuidString characterAtIndex:0x12 + offset] != '-' || ([uuidString characterAtIndex:0x17 + offset] != '-'))))
		{
			return NO;
		}
	}
    
	int x = 0;
	int dataIndex = 0;
    
    for (int i = 0, j = 0; i < uuidString.length; i++, dataIndex++)
    {
        unichar c = [uuidString characterAtIndex:i];
        
        if (c == '{' || c == '}' || c == '-')
        {
            continue;
        }
        
        int shift;
		int mask;
		
		x = j / 2;
        
        if (j % 2 == 0)
        {
            shift = 4;
            mask = 0xf0;
        }
        else
        {
            shift = 0;
            mask = 0x0f;
        }
        
        if (x >= 16)
        {
            return NO;
        }
        
        if (c >= 'a' && c <= 'f')
        {
            bytes[x] |= (((c - 'a' + 10) << shift) & mask);
        }
        else if (c >= 'A' && c <= 'F')
        {
            bytes[x] |= (((c - 'A' + 10) << shift) & mask);
        }
        else if (c >= '0' && c <= '9')
        {
            bytes[x] |= (((c - '0') << shift) & mask);
        }
        else
        {
            return NO;
        }
        
        j++;
    }
	
	return x == 15;
}

-(BOOL) isEqual:(id)other
{
	if (other == self)
	{
		return YES;
	}
	
    if (other == nil || [other class] != PKUUID.class)
	{
        return NO;
	}
	
    return memcmp(&data[0], ((PKUUID*)other)->data, 16) == 0;
}

-(NSUInteger) hash
{
	NSUInteger retval = 0;
	
	retval = *((UInt32*)&data[0])
        ^ *((UInt32*)&data[4])
        ^ *((UInt32*)&data[8])
        ^ *((UInt32*)&data[12]);
        
	return retval;
}

-(CFUUIDBytes) uuidBytes
{
	CFUUIDBytes retval;
	
	memcpy(&retval, data, 16);
	
	return retval;
}

-(void) byteDataToBuffer:(UInt8*)bytes
{
    memcpy(bytes, data, 16);
}

-(BOOL) isEmpty
{
	return [self isEqual:PKUUID.emptyUUID];
}

-(NSString*) stringValue
{
	return [self stringValueWithFormat:PKUUIDFormatDashed];
}

-(NSString*) description
{
	return [self stringValueWithFormat:PKUUIDFormatDashed];
}

-(NSString*) compactStringValue
{
	return [self stringValueWithFormat:PKUUIDFormatCompact];
}

-(NSString*) dashedStringValue
{
	return [self stringValueWithFormat:PKUUIDFormatDashed];
}

-(NSString*) bracedStringValue
{
	return [self stringValueWithFormat:PKUUIDFormatBraces];
}

-(NSString*) parenedStringValue
{
	return [self stringValueWithFormat:PKUUIDFormatParenthesis];
}

-(id) copyWithZone:(NSZone*)zone
{
	PKUUID* retval = [[PKUUID allocWithZone:zone] initWithBytes:data];
    
	return retval;
}

@end
