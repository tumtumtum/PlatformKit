//
//  PKTimeSpan.h
//  PlatformKit
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKTimeSpan : NSObject<NSCopying>
{
    @private
    int64_t ticks;
}

+(PKTimeSpan*) zero;
+(PKTimeSpan*) minValue;
+(PKTimeSpan*) maxValue;

+(PKTimeSpan*) fromDays:(double) value;
+(PKTimeSpan*) fromHours:(double) value;
+(PKTimeSpan*) fromMinutes:(double) value;
+(PKTimeSpan*) fromSeconds:(double) value;
+(PKTimeSpan*) fromMilliseconds:(double) value;
+(PKTimeSpan*) fromTicks:(int64_t) value;
+(PKTimeSpan*) fromIsoString:(NSString*) duration;
+(PKTimeSpan*) parse:(NSString*) value;

-(id) initWithTicks:(int64_t)ticks;
-(id) initWithHours:(int)hours minutes:(int)minutes seconds:(int)seconds;
-(id) initWithDays:(int)days hours:(int)hours minutes:(int)minutes seconds:(int)seconds;
-(id) initWithDays:(int)days hours:(int)hours minutes:(int)minutes seconds:(int)seconds milliseconds:(int)milliseconds;

-(BOOL) isEqualToTimeSpan:(PKTimeSpan*)ts;
-(BOOL) isGreaterThan:(PKTimeSpan*)ts;
-(BOOL) isLessThan:(PKTimeSpan*)ts;
-(BOOL) isGreaterThanOrEqualTo:(PKTimeSpan*)ts;
-(BOOL) isLessThanOrEqualTo:(PKTimeSpan*)ts;

-(PKTimeSpan*) add:(PKTimeSpan*)ts;
-(PKTimeSpan*) subtract:(PKTimeSpan*)ts;
-(PKTimeSpan*) negate;

-(NSString*) toIsoString;


@property (nonatomic, readonly) int days;
@property (nonatomic, readonly) int hours;
@property (nonatomic, readonly) int minutes;
@property (nonatomic, readonly) int seconds;
@property (nonatomic, readonly) int milliseconds;
@property (nonatomic, readonly) int64_t ticks;

@property (nonatomic, readonly) double totalDays;
@property (nonatomic, readonly) double totalHours;
@property (nonatomic, readonly) double totalMinutes;
@property (nonatomic, readonly) double totalSeconds;
@property (nonatomic, readonly) double totalMilliseconds;




@end
