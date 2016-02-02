//
//  CoreGraphicsView.h
//  MyDemo
//
//  Created by 张鑫 on 16/2/2.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OptionTypes) {
    lineAndGraph ,
    word,
    image ,
    gradient ,
    animation,
    patterns,
};

@interface CoreGraphicsView : UIView

@property (nonatomic, readwrite) OptionTypes type;

+ (NSArray*)titles;

@end
