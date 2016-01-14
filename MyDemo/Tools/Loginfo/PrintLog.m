//
//  PrintLog.m
//  BJXH-doctor
//
//  Created by zhangxin on 14-6-3.
//  Copyright (c) 2014年 zhangxin. All rights reserved.
//

#import "PrintLog.h"





void printLog(int level ,NSString* file ,int line ,NSString* format, ...){
    if (level < LEVEL_CONTROL) {
        return;
    }
    
    va_list ap;
    va_start(ap, format);
    NSString* logFormat = [[NSString alloc]initWithFormat:format arguments:ap];
    va_end(ap);
    /*
     id sender;
     va_list ap;
     va_start(ap, format);
     while ((sender = va_arg(ap, id))) {
        if ([sender isKindOfClass:[NSString class]]) {
     
        }
     }
    */
    
    NSString* levelStr = @"DEBUG";
    if (level == LEVEL_INFO) {
        levelStr = @"INFO";
    }else if (level == LEVEL_WARN) {
        levelStr = @"WARN";
    }else if (level == LEVEL_ERROR){
        levelStr = @"ERROR";
    }
    NSString* logStr = [NSString stringWithFormat:@"[%@]:%@ line:%d %@",levelStr,file,line,logFormat];
    NSLog(@"%@",logStr);

    
    
    
#ifdef SAVE_LOG_TO_FILE
    
    saveLogToFile(logStr);
    
#endif
}

void saveLogToFile(NSString* logString) {
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//取出需要的路径
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:SAVE_LOG_FILE_NAME];
    
    //    NSLog(@"file path is :%@", filePath);
    BOOL isDirectory = NO;
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    
    if (!isExist) {
        NSDictionary* infoDict = [[NSBundle mainBundle]infoDictionary];
        NSString *infoString = @"Application Info :";
        infoString = [infoString stringByAppendingFormat:@"\nName           : %@", infoDict[@"CFBundleName"]];
        infoString = [infoString stringByAppendingFormat:@"\nVersion        : %@", infoDict[@"CFBundleShortVersionString"]];
        infoString = [infoString stringByAppendingFormat:@"\nPlatformName   : %@", infoDict[@"DTPlatformName"]];
        infoString = [infoString stringByAppendingFormat:@"\nPlatformVersion: %@", infoDict[@"DTPlatformVersion"]];
        infoString = [infoString stringByAppendingFormat:@"\nSDKName        : %@", infoDict[@"DTSDKName"]];
        
        NSMutableData *writer = [[NSMutableData alloc] init];
        [writer appendData:[infoString dataUsingEncoding:NSUTF8StringEncoding]];
        [writer writeToFile:filePath atomically:YES];
    }
    
    NSFileHandle  * outFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if(outFile == nil) {
        //        NSLog(@"Open of file for writing failed");
    }
    [outFile seekToEndOfFile];
    NSString* saveString = [NSString stringWithFormat:@"\n%@ %@", [NSDate date], logString];
    NSData *buffer = [saveString dataUsingEncoding:NSUTF8StringEncoding];
    [outFile writeData:buffer];
    [outFile closeFile];
}
