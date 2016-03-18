//
//  PKTimeSpan.m
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import "PKTimeSpan.h"

@interface PKTimeSpan()

- (id) initWithInterval:(double)interval scale:(int)scale;

@end

static PKTimeSpan* Zero;
static PKTimeSpan* MinValue;
static PKTimeSpan* MaxValue;

@implementation PKTimeSpan

+(PKTimeSpan*) zero
{
    if (Zero == nil)
    {
        Zero = [PKTimeSpan fromTicks:0];
    }
    
    return Zero;
}

+(PKTimeSpan*) minValue
{
    if (MinValue == nil)
    {
        MinValue = [PKTimeSpan fromTicks:9223372036854775808ULL * -1];
    }
    
    return MinValue;
}

+(PKTimeSpan*) maxValue
{
    if (MaxValue == nil)
    {
        MaxValue = [PKTimeSpan fromTicks:0x7fffffffffffffffLL];
    }
    
    return MaxValue;
}

+(PKTimeSpan*) fromDays:(double) value
{
    return [[PKTimeSpan alloc] initWithInterval:value scale:0x5265c00];
}

+(PKTimeSpan*) fromHours:(double) value
{
    return [[PKTimeSpan alloc] initWithInterval:value scale:0x36ee80];
}

+(PKTimeSpan*) fromMinutes:(double) value
{
    return [[PKTimeSpan alloc] initWithInterval:value scale:0xea60];
}

+(PKTimeSpan*) fromSeconds:(double) value
{
    return [[PKTimeSpan alloc] initWithInterval:value scale:0x3e8];
}

+(PKTimeSpan*) fromMilliseconds:(double) value
{
    return [[PKTimeSpan alloc] initWithInterval:value scale:1];
}

+(PKTimeSpan*) fromTicks:(int64_t) value
{
    return [[PKTimeSpan alloc] initWithTicks:value];
}

+(PKTimeSpan*) fromIsoString:(NSString*) isoString
{
    double year = 0, month = 0, day = 0, hour = 0, minute = 0, second = 0;
    NSError* error = NULL;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"^P(([0-9\\.]*)Y)?(([0-9\\.]*)M)?(([0-9\\.]*)D)?(T)?(([0-9\\.]*)H)?(([0-9\\.]*)M)?(([0-9\\.]*)S)?$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:isoString options:0 range:NSMakeRange(0, [isoString length])];
    
    NSTextCheckingResult* match;
    NSString* value;
    
    if ([matches count] == 1)
    {
		NSRange range;
		match = matches.firstObject;
		
        range = [match rangeAtIndex:2];
		
		if (range.length > 0)
		{
			value = [isoString substringWithRange:range];
		}
        
        if (value && ![value isEqualToString:@""])
        {
            year = [value doubleValue];
        }
        
		range = [match rangeAtIndex:4];

		if (range.length > 0)
		{
			value = [isoString substringWithRange:range];
		
			if (value && ![value isEqualToString:@""])
			{
				month = [value doubleValue];
			}
		}
		
		range = [match rangeAtIndex:6];
		
		if (range.length > 0)
		{
			value = [isoString substringWithRange:range];
			
			if (value && ![value isEqualToString:@""])
			{
				day = [value doubleValue];
			}
		}
		
		range = [match rangeAtIndex:9];
		
		if (range.length > 0)
		{
			value = [isoString substringWithRange:range];
			
			if (value && ![value isEqualToString:@""])
			{
				hour = [value doubleValue];
			}
		}
		
		range = [match rangeAtIndex:11];
		
		if (range.length > 0)
		{
			value = [isoString substringWithRange:range];
			
			if (value && ![value isEqualToString:@""])
			{
				minute = [value doubleValue];
			}
		}
		
		range = [match rangeAtIndex:13];

		if (range.length > 0)
		{
			value = [isoString substringWithRange:range];
			
			if (value && ![value isEqualToString:@""])
			{
				second = [value doubleValue];
			}
		}
    }
    else
    {
        [NSException raise:@"Format exception" format:@"Incorrect TimeSpan format."];
    }
    
    PKTimeSpan* retVal = [[PKTimeSpan alloc] initWithDays:(year * (double)365.242199) + (month * (double)30.4368499) + day
                                                 hours:hour
                                               minutes:minute
                                               seconds:0
                                          milliseconds:0];
    
    return [retVal add:[PKTimeSpan fromTicks:(second * 0x989680)]];
}

+(PKTimeSpan*) parse:(NSString*) value
{
    if ([value length] == 0)
    {
        [NSException raise:@"Format exception" format:@"Incorrect TimeSpan format."];
    }
    
    if ([value characterAtIndex:0] == 'p' || [value characterAtIndex:0] == 'P')
    {
        return [PKTimeSpan fromIsoString:value];
    }
    else
    {
        return [PKTimeSpan fromTicks:[value longLongValue]];
    }
}

-(id) initWithInterval:(double)interval scale:(int)scale
{
    double x = interval * scale;
    double y = x + ((interval >= 0.0) ? 0.5 : -0.5);
    
    if ((y > 922337203685477LL)  || (y < -922337203685477LL))
    {
        [NSException raise:@"TimeSpan too long" format:@""];
    }
    
    return [self initWithTicks:((int64_t)y * (int64_t)0x2710LL)];
}

-(id) initWithTicks:(int64_t)inTicks
{
    if ((self = [super init]))
    {
	    ticks = inTicks;
    }
    
    return self;
}

-(id) initWithHours:(int)hours minutes:(int)minutes seconds:(int)seconds
{
    return [self initWithDays:0 hours:hours minutes:minutes seconds:seconds];
}

- (id) initWithDays:(int)days hours:(int)hours minutes:(int)minutes seconds:(int)seconds
{
    return [self initWithDays:days hours:hours minutes:minutes seconds:seconds milliseconds:0];
}

-(id) initWithDays:(int)days hours:(int)hours minutes:(int)minutes seconds:(int)seconds milliseconds:(int)milliseconds
{
    int64_t num = ((((((days * 0xe10LL) * 0x18LL) + (hours * 0xe10LL)) + (minutes * 60LL)) + seconds) * 0x3e8LL) + milliseconds;
    
    if ((num > 0x346dc5d638865LL) || (num < -922337203685477LL))
    {
        [NSException raise:@"Overflowed when trying to initialise a TimeSpan"
                    format:@"Init values: %d days, %d hours, %d minutes, %d seconds, %d milliseconds", days, hours, minutes, seconds, milliseconds];
    }
    
    return [self initWithTicks:num * 0x2710LL];
}

-(BOOL) isEqualToTimeSpan:(PKTimeSpan*)ts
{
    return ticks == ts.ticks;
}

-(BOOL) isGreaterThan:(PKTimeSpan*)ts
{
    return ticks > ts.ticks;
}

-(BOOL) isLessThan:(PKTimeSpan*)ts
{
    return ticks < ts.ticks;
}

-(BOOL) isGreaterThanOrEqualTo:(PKTimeSpan*)ts
{
    return ticks >= ts.ticks;
}

-(BOOL) isLessThanOrEqualTo:(PKTimeSpan*)ts
{
    return ticks <= ts.ticks;
}

-(PKTimeSpan*) add:(PKTimeSpan*)ts
{
    int64_t tempTicks = ticks + ts.ticks;
    
    if (((ticks >> 0x3f) == (ts.ticks >> 0x3f)) && ((ticks >> 0x3f) != (tempTicks >> 0x3f)))
    {
        [NSException raise:@"TimeSpan overflow" format:@""];
    }
    
    return [PKTimeSpan fromTicks:tempTicks];
}

-(PKTimeSpan*) subtract:(PKTimeSpan*)ts
{
    int64_t tempTicks = ticks - ts.ticks;
    
    if (((ticks >> 0x3f) == (ts.ticks >> 0x3f)) && ((ticks >> 0x3f) != (tempTicks >> 0x3f)))
    {
        [NSException raise:@"TimeSpan overflow" format:@""];
    }
    
    return [PKTimeSpan fromTicks:tempTicks];
}

-(PKTimeSpan*) negate
{
    if (ticks == MinValue.ticks)
    {
        [NSException raise:@"Negating the minimum value" format:@""];
    }
    
    return [PKTimeSpan fromTicks:-ticks];
}

-(NSString*) toIsoString
{
    NSString* retval = @"";
    
    int num = (int)(ticks / (int64_t)0xc92a69c000LL);
    int64_t num2 = ticks % (int64_t)0xc92a69c000LL;
    
    if (ticks < 0L)
    {
        retval = [retval stringByAppendingFormat:@"-"];
        
        num = -num;
        num2 = -num2;
    }
    
    retval = [retval stringByAppendingFormat:@"P%dDT%dH%dM%d",
              num,
              (int) ((num2 / (int64_t)0x861c46800LL) % 0x18LL),
              (int) ((num2 / (int64_t)0x23c34600LL) % 60LL),
              (int) ((num2 / (int64_t)0x989680LL) % 60LL)];
    
    int n = (int) (num2 % (int64_t)0x989680LL);
    
    if (n != 0)
    {
        retval = [retval stringByAppendingFormat:@".%07d", n];
    }
    
    retval = [retval stringByAppendingFormat:@"S"];
    
    return retval;
}

-(int) days
{
    return (int)(ticks / (int64_t)0xc92a69c000LL);
}

-(int) hours
{
    return (int)((ticks / (int64_t)0x861c46800LL) % (int64_t)0x18LL);
}

-(int) minutes
{
    return (int)((ticks / (int64_t)0x23c34600LL) % (int64_t)60LL);
}

-(int) seconds
{
    return (int)((ticks / (int64_t)0x989680LL) % 60LL);
}

-(int) milliseconds
{
    return (int)((ticks / (int64_t)0x2710LL) % (int64_t)0x3e8LL);
}

-(int64_t) ticks
{
    return ticks;
}

-(double) totalDays
{
    return (ticks * (double)1.1574074074074074E-12);
}

-(double) totalHours
{
    return (ticks * (double)2.7777777777777777E-11);
}

-(double) totalMinutes
{
    return (ticks * (double)1.6666666666666667E-09);
}

-(double) totalSeconds
{
    return (ticks * (double)1E-07);
}

-(double) totalMilliseconds
{
    double num = ticks * (double)0.0001;
    
    if (num > 922337203685477LL)
    {
        return 922337203685477LL;
    }
    
    if (num < -922337203685477LL)
    {
        return -922337203685477LL;
    }
    
    return num;
}

#pragma mark - NSCopying

-(id) copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] initWithTicks:ticks];
    
    return theCopy;
}

@end

