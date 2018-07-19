//
//  CustomUI.m
//  Test
//
//  Created by 张鑫 on 16/4/22.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "CustomUI.h"

#import <objc/message.h>

@implementation CustomUI

@end


@implementation UIControl (ac)

+ (void)load {
    
    Class selfClass = [self class];
    
    SEL oriSEL = @selector(sendAction:to:forEvent:);
    Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
    
    SEL cusSEL = @selector(mySendAction:to:forEvent:);
    Method cusMethod = class_getInstanceMethod(selfClass, cusSEL);
    
#if 1
    //
    BOOL addSucc = class_addMethod(selfClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
    if (addSucc) {
        // 添加成功：将源方法的实现替换到交换方法的实现
        class_replaceMethod(selfClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        //添加失败：说明源方法已经有实现，直接将两个方法的实现交换即
        method_exchangeImplementations(oriMethod, cusMethod);
    }
#else
//如果交换的方法是父类的方法，那么其他子类在使用的时候会找不到此方法
    method_exchangeImplementations(cusMethod, oriMethod);
    
#endif
}

- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    NSLog(@"%@, %s,", [target class], sel_getName(action));
    [self mySendAction:action to:target forEvent:event];
}





@end
