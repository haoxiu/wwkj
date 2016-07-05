//
//  NSDate+SL.h
//
//  Created by apple on 14-5-9.
//  Copyright (c) 2014年 seven All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DateFormat_yyyyMMdd, // 2015-04-23
    DateFormat_MMdd, // 04-23
    DateFormat_yyyyMMddHHmmss // 2015-04-23 09:10:10
    
} DateFormat;

@interface NSDate (Extension)
/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;

/**
 *  根据一个1970时间戳返回时间字符串
 *
 *  @param date1970Str 时间戳
 *  @param DateFormat  日期/时间格式
 *
 *  @return 时间字符串
 */
+ (NSString *)dateWithTimeIntervalSince1970:(NSTimeInterval)date1970Str dateFormat:(DateFormat)DateFormat;
/**
 *  返回当前时间所在月的天数
 *
 *  @return 返回当前时间所在月的天数
 */
+ (NSInteger)daysOfMonthInCurrentDate;
@end
