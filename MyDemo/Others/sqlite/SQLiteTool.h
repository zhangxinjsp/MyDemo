//
//  SQLiteTool.h
//  UINavgationController
//
//  Created by 张鑫 on 14-6-22.
//  Copyright (c) 2014年 zhangxin. All rights reserved.
/*
 在工程的build setting里修改配置other c flags添加
 -DSQLITE_HAS_CODEC 
 -DSQKUTE_THREADSAFE 
 -DSQLCIPHER_CRYPTO_CC 
 -DSQLITE_TEMP_STORE=2,
 加入Security.framework
 */

#import <Foundation/Foundation.h>
#import "sqlite3.h"


#define DB_NAME     @"area"

@interface SQLiteTool : NSObject{
    sqlite3* database;
    sqlite3_stmt* statement;
    char* errorMsg;
}

@property(nonatomic, readwrite) sqlite3_stmt* statement;
@property(nonatomic, readwrite) sqlite3* database;

+(SQLiteTool *)shareInstance;

+(NSString*)errorMessage;
+(BOOL)hasRows;
+(BOOL)stepDone;
+(void)beginTransaction;
+(void)commitTransaction;
+(void)rollbackTransaction;

+(void)bindTextAtColumnIndex:(int)columnIndex withValue:(NSString*)value;
+(void)bindIntAtColumnIndex:(int)columnIndex withValue:(NSInteger)value;

+(NSString*)readStringAtColumnIndex:(int)columnIndex;
+(NSInteger)readIntegerAtColumnIndex:(int)columnIndex;
+(double)readDoubleAtColumnIndex:(int)columnIndex;
+(NSDate*)readDateAtColumnIndex:(int)columnIndex;
+(BOOL)isNullAtColumnIndex:(int)columnIndex;
+(NSInteger)count;

-(BOOL)openDbWithName:(NSString*)dbName key:(NSString*)key;
-(BOOL)openDb:(NSString*)dbName;
-(void)closeDb;

-(BOOL)executeSql:(NSString*)sql;

-(BOOL)prepareSql:(NSString*)sql;

@end
