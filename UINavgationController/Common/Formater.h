//
//  Formater.h
//  UINavgationController
//
//  Created by xsw on 14-10-21.
//  Copyright (c) 2014年 niexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Formater : NSObject


/*---------color-----------*/
+(UIColor*)colorWithHexStringRGB:(NSString*)RGB;
+(UIColor*)colorWithHexIntRGB:(int)RGB;


/*----------date----------*/
+(NSString*)weekWithDate:(id)date;
+(NSString*)stringDateAliasesWithDate:(id)date;
+(NSDate*)dateWithStringDate:(NSString*)dateStr;
+(NSDate*)dateWithStringDateSecond:(NSString*)dateStr;
+(NSString*)stringDateWithDate:(NSDate*)date;
+(NSString*)stringDateWithDateSecond:(NSDate*)date;
+(NSString *)whichDay;

@end
