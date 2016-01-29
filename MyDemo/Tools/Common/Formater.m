//
//  Formater.m
//  UINavgationController
//
//  Created by zhangxin on 14-10-21.
//  Copyright (c) 2014年 zhangxin. All rights reserved.
//

#import "Formater.h"

@implementation Formater



+(UIColor*)colorWithHexStringRGB:(NSString*)RGB{
    if ([RGB isNullOrEmpty]) {
        return [UIColor clearColor];
    }
    while (RGB.length < 6) {
        RGB = [RGB stringByAppendingString:@"0"];
    }
    float red = strtoul([[RGB substringToIndex:2] UTF8String],0,16);
    float green = strtoul([[RGB substringWithRange:NSMakeRange(2, 2)] UTF8String],0,16);
    float blue = strtoul([[RGB substringFromIndex:4] UTF8String],0,16);
    UIColor * color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}

+(UIColor*)colorWithHexIntRGB:(int)RGB{
    float red = (float)((RGB & 0xFF0000) >> 16);
    float green = (float)((RGB & 0xFF00) >> 8);
    float blue = (float)(RGB & 0xFF);
    UIColor * color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}

+(NSString*)weekWithTag:(NSInteger)tag{
    switch (tag) {
        case 1:
            return @"星期日";
        case 2:
            return @"星期一";
        case 3:
            return @"星期二";
        case 4:
            return @"星期三";
        case 5:
            return @"星期四";
        case 6:
            return @"星期五";
        case 7:
            return @"星期六";
        default:
            return @"";
    }
}

+(NSDateFormatter*)initDateFormatter:(NSString*)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    return dateFormatter;
}

+(NSString*)weekWithDate:(id)date{
    NSDate* transDate = nil;
    if ([date isKindOfClass:[NSString class]]) {
        transDate = [Formater dateWithStringDate:date];
    }else if ([date isKindOfClass:[NSDate class]]){
        transDate = date;
    }else{
        return @"";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"c"];//@"e"和@"c"是相同的，星期天都是一周的开始，返回1；
    NSString * temp = [dateFormatter stringFromDate:transDate];
    return [Formater weekWithTag:temp.intValue];
}

+(NSString*)stringDateAliasesWithDate:(id)date{
    NSString* dateStr = @"";
    if ([date isKindOfClass:[NSString class]]) {
        dateStr = date;
    }else if ([date isKindOfClass:[NSDate class]]){
        dateStr = [Formater stringDateWithDateSecond:date];;
    }
    NSDate* currentDate = [Formater dateWithStringDate:[Formater stringDateWithDate:[NSDate date]]];
    NSDate* compareDate = nil;
//    2014-10-10 12:22:11
    if (dateStr.length >= 10) {
        compareDate = [Formater dateWithStringDate:[dateStr substringToIndex:10]];
    }
    NSString* aliasesDate = @"";
    if (compareDate != nil) {
        NSInteger days = [compareDate timeIntervalSinceDate:currentDate] / 24 / 3600;
        if (days == -1){
            aliasesDate = @"昨天";
        }else if (days == 0) {
            aliasesDate = @"今天";
        }else if (days == 1){
            aliasesDate = @"明天";
        }else{
            return dateStr;
        }
        aliasesDate = [aliasesDate stringByAppendingString:[dateStr substringFromIndex:10]];
    }
    return aliasesDate;
}

+(NSDate*)dateWithStringDate:(NSString*)dateStr{
    if ([dateStr isNullOrEmpty]) {
        return [NSDate date];
    }
    NSDateFormatter* dateFormatter = [Formater initDateFormatter:@"yyyy-MM-dd"];
    NSDate* date = [dateFormatter dateFromString:dateStr];
    return date;
}

+(NSDate*)dateWithStringDateSecond:(NSString*)dateStr{
    if ([dateStr isNullOrEmpty]) {
        return [NSDate date];
    }
    NSDateFormatter* dateFormatter = [Formater initDateFormatter:@"yyyy-MM-dd hh:mm:ss"];
    NSDate* date = [dateFormatter dateFromString:dateStr];
    return date;
}

+(NSString*)stringDateWithDate:(NSDate*)date{
    if (date == nil) {
        return @"";
    }
    NSDateFormatter* dateFormatter = [Formater initDateFormatter:@"yyyy-MM-dd"];
    NSString* dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

+(NSString*)stringDateWithDateSecond:(NSDate*)date{
    if (date == nil) {
        return @"";
    }
    NSDateFormatter* dateFormatter = [Formater initDateFormatter:@"yyyy-MM-dd hh:mm:ss"];
    NSString* dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}



+ (NSString *)whichDay {
    // Return "today", "tomorrow", or "yesterday" as appropriate for the time zone
    NSDateComponents *dateComponents;
    NSInteger myDay, tzDay;
    
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];//self.calendar;
    NSDate *date = [NSDate date];//self.date;
    
    // Set the calendar's time zone to the default time zone.
    [calendar setTimeZone:[NSTimeZone defaultTimeZone]];
    dateComponents = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    myDay = [dateComponents weekday];
    
    //		[calendar setTimeZone:self.timeZone];
    dateComponents = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    tzDay = [dateComponents weekday];
    
    NSRange dayRange = [calendar maximumRangeOfUnit:NSWeekdayCalendarUnit];
    NSInteger maxDay = NSMaxRange(dayRange) - 1;
    LOGINFO(@"max day is :%d", maxDay);
    if (myDay == tzDay) {
        return @"today";
    } else {
        if ((tzDay - myDay) > 0) {
            return @"tomorrow";
        } else {
            return @"yesterday";
        }
        // Special cases for days at the end of the week
//        if ((myDay == maxDay) && (tzDay == 1)) {
//            return @"tomorrow";
//        }
//        if ((myDay == 1) && (tzDay == maxDay)) {
//            return @"yesterday";
//        }
	}
    return @"today";
}
















@end
