//
//  Area.m
//  UINavgationController
//
//  Created by zhangxin on 14-7-15.
//  Copyright (c) 2014年 zhangxin. All rights reserved.
//

#import "Area.h"

#import "SQLiteTool.h"

@implementation Area

@synthesize Areaid;
@synthesize Usetype;
@synthesize Name;
@synthesize Upid;
@synthesize Level;



+ (void)insert :(Area*)area {
    [[SQLiteTool shareInstance] openDb:DB_NAME];
    
    NSString *sql = @"INSERT INTO Area (Areaid, Usetype, Name, Upid, Level) VALUES (?, ?, ?, ?, ?)";
    
    if ([[SQLiteTool shareInstance] prepareSql:sql]) {
        
        [SQLiteTool bindTextAtColumnIndex:1 withValue:area.Areaid];
        [SQLiteTool bindTextAtColumnIndex:2 withValue:area.Usetype];
        [SQLiteTool bindTextAtColumnIndex:3 withValue:area.Name];
        [SQLiteTool bindTextAtColumnIndex:4 withValue:area.Upid];
        [SQLiteTool bindTextAtColumnIndex:5 withValue:area.Level];
        if ([SQLiteTool stepDone]) {
            
        }
    }
    
    LOGINFO(@"%@", [SQLiteTool errorMessage]);

}

+ (void)inserts :(NSArray*)areas {

    [[SQLiteTool shareInstance] openDb:DB_NAME];
    [SQLiteTool beginTransaction];
    NSString *sql = @"INSERT INTO Area (Areaid, Usetype, Name, Upid, Level) VALUES (?, ?, ?, ?, ?)";
    
    
    int hasError = 0;
    for (int i=0; i < [areas count]; i++) {
        if ([[SQLiteTool shareInstance] prepareSql:sql]) {
            
            Area* area = areas[i];
            [SQLiteTool bindTextAtColumnIndex:1 withValue:area.Areaid];
            [SQLiteTool bindTextAtColumnIndex:2 withValue:area.Usetype];
            [SQLiteTool bindTextAtColumnIndex:3 withValue:area.Name];
            [SQLiteTool bindTextAtColumnIndex:4 withValue:area.Upid];
            [SQLiteTool bindTextAtColumnIndex:5 withValue:area.Level];
            
            if (![SQLiteTool stepDone]) {
                hasError=1;
                LOGINFO(@"Prepare-error %@", [SQLiteTool errorMessage]);
            }
        }
    }
    
    [self performSelector:@selector(aaaa) withObject:nil afterDelay:5];
    
    if( hasError == 0 ) {
        [SQLiteTool commitTransaction];
    } else {
        [SQLiteTool rollbackTransaction];
    }
}



@end
