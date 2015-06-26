//
//  PrintLog.h
//  BJXH-doctor
//
//  Created by zhangxin on 14-6-3.
//  Copyright (c) 2014年 zhangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define LEVEL_CONTROL   0
#else
#define LEVEL_CONTROL   2
#endif



#define LEVEL_DEBUG  0
#define LEVEL_INFO   1
#define LEVEL_WARN   2
#define LEVEL_ERROR  3

#define FILE_NAME           [NSString stringWithFormat:@"%s",__FUNCTION__]//__PRETTY_FUNCTION__
#define FILE_PATH           [NSString stringWithFormat:@"%s",__FILE__]


#define LOGDEBUG(format,...)  printLog(LEVEL_DEBUG,FILE_NAME,__LINE__,format,##__VA_ARGS__)
#define LOGINFO(format,...)  printLog(LEVEL_INFO,FILE_NAME,__LINE__,format,##__VA_ARGS__)
#define LOGWORN(format,...)  printLog(LEVEL_WARN,FILE_NAME,__LINE__,format,##__VA_ARGS__)
#define LOGERROR(format,...)  printLog(LEVEL_ERROR,FILE_NAME,__LINE__,format,##__VA_ARGS__)

#ifdef __cplusplus
extern "C"
{
#endif
void printLog(int level ,NSString* file ,int line ,NSString* format, ...);
#ifdef __cplusplus
}
#endif

