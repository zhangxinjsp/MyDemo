//
//  SQLiteTool.m
//  UINavgationController
//
//  Created by 张鑫 on 14-6-22.
//  Copyright (c) 2014年 zhangxin. All rights reserved.
//

#import "SQLiteTool.h"



@implementation SQLiteTool

@synthesize statement;
@synthesize database;

+(SQLiteTool *)shareInstance{
    static SQLiteTool *instance;
    if (instance == nil) {
        @synchronized(self){
            if (instance == nil) {
                instance = [[SQLiteTool alloc] init];
            }
        }
    }
    return instance;
}


-(NSString*)dbPath:(NSString*)dbName{
#if 1
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* DBName = [dbName stringByAppendingString:@".db"];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:DBName];
#else
    NSString *path = [[NSBundle mainBundle] pathForResource: dbName ofType: @"db"];
#endif
    LOGINFO(@"%@", path);
    return path;
}

-(BOOL)openDbWithName:(NSString*)dbName key:(NSString*)key {
    NSString* dbPath = [self dbPath:dbName];
    //将项目中的数据库复制到sendbox中
    if (![[NSFileManager defaultManager]fileExistsAtPath:dbPath]) {
        NSString* sourcePath = [[NSBundle mainBundle] pathForResource: dbName ofType: @"db"];
        if ([[NSFileManager defaultManager]fileExistsAtPath:sourcePath]) {
            [[NSFileManager defaultManager]copyItemAtPath:sourcePath toPath:dbPath error:nil];
        }
    }
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        LOGINFO(@"%@" ,@"打开成功数据库");
        const char* keyC = [key UTF8String];
        int keyReslute = sqlite3_key(database, keyC, (int)strlen(keyC));
        LOGINFO(@"数据库解密结果：%d" ,keyReslute);
        return YES;
    }
    return NO;
}

-(BOOL)openDb:(NSString*)dbName{
    NSString* dbPath = [self dbPath:dbName];
    //将项目中的数据库复制到sendbox中
    if (![[NSFileManager defaultManager]fileExistsAtPath:dbPath]) {
        NSString* sourcePath = [[NSBundle mainBundle] pathForResource: dbName ofType: @"db"];
        if ([[NSFileManager defaultManager]fileExistsAtPath:sourcePath]) {
            [[NSFileManager defaultManager]copyItemAtPath:sourcePath toPath:dbPath error:nil];
        }
    }
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        LOGINFO(@"%@" ,@"打开成功数据库");
        return YES;
    }
    return NO;
}

-(void)closeDb{
    sqlite3_close(database);
    sqlite3_finalize(statement);//called to delete a [prepared statement]
}

-(BOOL)executeSql:(NSString*)sql{
    if (database == nil) {
        [[SQLiteTool shareInstance] openDb:DB_NAME];
    }
    
    const char *execute = [sql UTF8String];
    if (sqlite3_exec(database, execute, NULL, NULL, &errorMsg) == SQLITE_OK) {
        LOGINFO(@"%@" ,@"SQL 执行成功成功.");
        return YES;
    }else{
        LOGINFO(@"%@" ,[NSString stringWithFormat:@"error: %s",errorMsg]);
        sqlite3_free(errorMsg);
        return NO;
    }
}

-(BOOL)prepareSql:(NSString*)sql{
    const char *pzTail; //Pointer to unused portion of zSql
    //执行查询
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, &pzTail) == SQLITE_OK) {
        LOGINFO(@"%@  %s" ,@"select success!!", pzTail);
        return YES;
        //获取stmt 里面的数据
//        while (sqlite3_step(statement) == SQLITE_ROW) { }
    }else{
        LOGINFO(@"%@", @"prepare failed!!");
        return NO;
    }
}

+(NSString*)errorMessage{
    char* charStr = (char*)sqlite3_errmsg([SQLiteTool shareInstance].database);
    return [NSString stringWithCString:charStr encoding:NSUTF8StringEncoding];
}

+(BOOL)hasRows{
    return sqlite3_step([SQLiteTool shareInstance].statement) == SQLITE_ROW;
}

+(BOOL)stepDone{
    return sqlite3_step([SQLiteTool shareInstance].statement) == SQLITE_DONE;
}

+(NSInteger)columnCount{
    return sqlite3_column_count([SQLiteTool shareInstance].statement);
}

+(NSString*)columnName:(NSInteger)index{
    const char* name = sqlite3_column_name([SQLiteTool shareInstance].statement, (int)index);
    return [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
}

+(void)beginTransaction{
    [[SQLiteTool shareInstance]executeSql:@"BEGIN TRANSACTION"];
    
//    sqlite3_exec([SQLiteTool shareInstance].database, "BEGIN TRANSACTION", 0, 0, 0);
}

+(void)commitTransaction{
    [[SQLiteTool shareInstance]executeSql:@"COMMIT TRANSACTION"];
//    sqlite3_exec([SQLiteTool shareInstance].database, "COMMIT TRANSACTION", 0, 0, 0);
}

+(void)rollbackTransaction{
    [[SQLiteTool shareInstance]executeSql:@"ROLLBACK"];
//    sqlite3_exec([SQLiteTool shareInstance].database, "ROLLBACK", 0, 0, 0);
}


+(void)bindTextAtColumnIndex:(int)columnIndex withValue:(NSString*)value{
    sqlite3_bind_text([SQLiteTool shareInstance].statement, columnIndex, [value UTF8String], -1, SQLITE_TRANSIENT);
}

+(void)bindIntAtColumnIndex:(int)columnIndex withValue:(NSInteger)value{
    sqlite3_bind_int([SQLiteTool shareInstance].statement, columnIndex, (int)value);
}


+(NSString*)readStringAtColumnIndex:(int)columnIndex{
    char* charStr = (char*)sqlite3_column_text([SQLiteTool shareInstance].statement, columnIndex);
    return [NSString stringWithCString:charStr encoding:NSUTF8StringEncoding];
}

+(NSInteger)readIntegerAtColumnIndex:(int)columnIndex{
    return sqlite3_column_int([SQLiteTool shareInstance].statement, columnIndex);;
}

+(double)readDoubleAtColumnIndex:(int)columnIndex{
    return sqlite3_column_double([SQLiteTool shareInstance].statement, columnIndex);;
}

+(NSDate*)readDateAtColumnIndex:(int)columnIndex{
    const char* charStr = (char*)sqlite3_column_text([SQLiteTool shareInstance].statement, columnIndex);
    NSString* dateStr = [NSString stringWithUTF8String:charStr];
    
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-HH-mm HH:mm:ss"];
    [format setLocale:[NSLocale currentLocale]];
    return [format dateFromString:dateStr];
}

+(NSInteger)count{
    return sqlite3_column_count([SQLiteTool shareInstance].statement);
}

+(BOOL)isNullAtColumnIndex:(int)columnIndex{
    return sqlite3_column_type([SQLiteTool shareInstance].statement, columnIndex) == SQLITE_NULL;
}

+(void)test {
    
//    sqlite3_key ();
    
    
}

/*
 
 sqlite3* database;
 sqlite3_stmt* statement;
 //第一和二的参数都是一样的，
 sqlite3_open([@"" UTF8String], &database);
 sqlite3_open16([@"" UTF8String], &database);
 *
 * 第三个是sql的权限设置。SQLITE_OPEN_READWRITE｜SQLITE_OPEN_CREATE是前面的默认方式
 * 第四个是vfs是sqlite的核心和底层操作系统之间的接口,填写nil会使用默认的sqlite_vfs对象
 *
 sqlite3_open_v2([@"" UTF8String], &database, SQLITE_OPEN_READONLY, nil);

 //推荐使用v2的方法，其中包含了低版本的。
 sqlite3_prepare     (<#sqlite3 *db#>, <#const char *zSql#>, <#int nByte#>, <#sqlite3_stmt **ppStmt#>, <#const char **pzTail#>)
 sqlite3_prepare16   (<#sqlite3 *db#>, <#const void *zSql#>, <#int nByte#>, <#sqlite3_stmt **ppStmt#>, <#const void **pzTail#>)
 sqlite3_prepare_v2  (<#sqlite3 *db#>, <#const char *zSql#>, <#int nByte#>, <#sqlite3_stmt **ppStmt#>, <#const char **pzTail#>)
 sqlite3_prepare16_v2(<#sqlite3 *db#>, <#const void *zSql#>, <#int nByte#>, <#sqlite3_stmt **ppStmt#>, <#const void **pzTail#>)

 sqlite3_step(<#sqlite3_stmt *#>)
 //回到上次执行的sql语句，
 sqlite3_reset(<#sqlite3_stmt *pStmt#>)
 sqlite3_finalize(<#sqlite3_stmt *pStmt#>)

 以下是占位符：NNN代表一个整数（这个整数是代表这个参数的索引），VVV代表一个字母标识符（参数的名字）
 ?
 ?NNN（可以指定索引如：?1, ?2）
 :VVV（:name1）
 @VVV（@naem2）
 $VVV（$name3）
 
 sqlite3_bind_blob(<#sqlite3_stmt *#>, <#int#>, <#const void *#>, <#int n#>, <#void (*)(void *)#>);
 sqlite3_bind_int(<#sqlite3_stmt *#>, <#int#>, <#int#>)
 sqlite3_bind_parameter_index(<#sqlite3_stmt *#>, <#const char *zName#>)

 sqlite3_column_name(<#sqlite3_stmt *#>, <#int N#>)
 
 
 
 

 SQL 使用单引号来环绕文本值（大部分数据库系统也接受双引号）。如果是数值，请不要使用引号。

 创建表语句：
 integer(size)，int(size)， smallint(size)， tinyint(size) 仅容纳整数。在括号内规定数字的最大位数。
 decimal(size,d)， numeric(size,d) 容纳带有小数的数字。 "size" 规定数字的最大位数。"d" 规定小数点右侧的最大位数。
 char(size) 容纳固定长度的字符串（可容纳字母、数字以及特殊字符）。 在括号中规定字符串的长度。
 varchar(size) 容纳可变长度的字符串（可容纳字母、数字以及特殊的字符）。 在括号中规定字符串的最大长度。
 date(yyyymmdd)	容纳日期。

 create table if not exists TABLE_NAME (id integer primary key autoincrement, COLUMN_1 text, COLUMN_2 integer, COLUMN_3 text)
 
 插入：
 COLUMN_1, COLUMN_2可以省略但是values要按照表里面的顺序全写上
 insert into TABLE_NAME (COLUMN_1, COLUMN_2) values ("张鑫", 1)"
 
 更新：
 update TABLE_NAME set COLUMN_1='张鑫', COLUMN_2=1 where id=1;
 
 删除：
 delete from TABLE_NAME where COLUMN_1>0"
 delete * from TABLE_NAME == delete from TABLE_NAME

 搜索：
 select COLUMN_1, COLUMN_2 from TABLE_NAME";

 select COLUMN_1, COLUMN_2 from TABLE_NAME where COLUMN_1=%i",aNote.noteId];
 
 选取唯一不同的值
 select DISTINCT 列名称 from TABLE_NAME
 
 AND 和 OR的用法
 select COLUMN_1, COLUMN_2 from TABLE_NAME where COLUMN_1='Thomas' AND COLUMN_2='Carter'
 select COLUMN_1, COLUMN_2 from TABLE_NAME where (COLUMN_1='Thomas' OR COLUMN_2='William') AND COLUMN_3='Carter'
 
 COLUMN_1 降序, COLUMN_2 升序排列
 select COLUMN_1, COLUMN_2 from TABLE_NAME order by COLUMN_1 DESC, COLUMN_2 ASC
 
 select COLUMN_1, COLUMN_2 from TABLE_NAME limit 5
 
 以 "N" 开始   提示："%" 可用于定义通配符（模式中缺少的字母）。（not like／like）
 select COLUMN_1, COLUMN_2 from TABLE_NAME where COLUMN_2 like 'N%'
 
 %	替代一个或多个字符
 _	仅替代一个字符
 [charlist]	字符列中的任何单一字符
 [^charlist]， [!charlist]不在字符列中的任何单一字符
 
 select COLUMN_1, COLUMN_2 from TABLE_NAME where COLUMN_1 IN ('Adams','Carter')
 
 字母顺序显示介于 "Adams"（包括）和 "Carter"（不包括）之间的 （between/not between）
 select COLUMN_1, COLUMN_2 from TABLE_NAME where COLUMN_1 between 'Adams' AND 'Carter'
*/

@end
