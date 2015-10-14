//
//  Area.h
//  UINavgationController
//
//  Created by zhangxin on 14-7-15.
//  Copyright (c) 2014年 zhangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Area : NSObject{
//    Areaid
//    Usetype
//    Name
//    Upid
//    Level
}
@property (nonatomic, strong) NSString* Areaid;
@property (nonatomic, strong) NSString* Usetype;
@property (nonatomic, strong) NSString* Name;
@property (nonatomic, strong) NSString* Upid;
@property (nonatomic, strong) NSString* Level;


+ (void)insert :(Area*)area;

+ (void)inserts :(NSArray*)areas;
@end
