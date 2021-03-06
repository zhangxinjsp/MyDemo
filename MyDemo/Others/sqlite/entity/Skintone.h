//
//  Skintone.h
//  UINavgationController
//
//  Created by 张鑫 on 14-6-22.
//  Copyright (c) 2014年 zhangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Skintone : NSObject{
    NSInteger skintoneId;
    NSString* skintoneName;
    NSString* RGB;
}

@property (nonatomic, readwrite) NSInteger skintoneId;
@property (nonatomic, strong) NSString* skintoneName;
@property (nonatomic, strong) NSString* RGB;

+ (NSArray*) queryAll;

@end
