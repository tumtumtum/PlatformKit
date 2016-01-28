//
//  NSData+PKExtensions.m
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import "NSData+PKExtensions.h"

@implementation NSData (PKExtensions)

-(NSString*) base64Encode
{
    uint8_t* input = (uint8_t*)self.bytes;
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((self.length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    for (int i = 0; i < self.length; i += 3)
    {
        int value = 0;
        
        for (int j = i; j < (i + 3); j++)
        {
            value <<= 8;
            
            if (j < self.length)
            {
                value |= (0xFF & input[j]);
            }
        }
        
        int index = (i / 3) * 4;
        
        output[index + 0] = table[(value >> 18) & 0x3F];
        output[index + 1] = table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < self.length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < self.length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

-(NSString*) hexString
{
    unichar* unichars = malloc(sizeof(unichar) * self.length * 2);
    
    for (int i = 0; i < self.length; i++)
	{
        unsigned char* chars = (unsigned char*)self.bytes;
        
        unichars[(i * 2)] = (chars[i] & 0xf0) >> 4;
        unichars[(i * 2) + 1] = (chars[i] & 0x0f);
	}
    
    return [[NSString alloc] initWithCharactersNoCopy:unichars length:self.length * 2 freeWhenDone:YES];
}

@end
