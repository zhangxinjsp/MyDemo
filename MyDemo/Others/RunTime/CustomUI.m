//
//  CustomUI.m
//  Test
//
//  Created by 张鑫 on 16/4/22.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "CustomUI.h"


#import <objc/runtime.h>
#import <objc/message.h>

@implementation CustomUI

@end


@implementation UIButton (ac)

+ (void)load {
    
    Class selfClass = [self class];
    
    SEL oriSEL = @selector(sendAction:to:forEvent:);
    Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
    
    SEL cusSEL = @selector(mySendAction:to:forEvent:);
    Method cusMethod = class_getInstanceMethod(selfClass, cusSEL);
    
    method_exchangeImplementations(oriMethod, cusMethod);
}

- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    NSLog(@"aaaaa");
    [self mySendAction:action to:target forEvent:event];
}





@end