//
//  DrawView.h
//  UINavgationController
//
//  Created by zhangxin on 12-11-7.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreImage/CoreImageDefines.h>
#import <QuartzCore/QuartzCore.h>
#import "test.h"

@interface DrawView : UIView{
    UIImageView* circleView;
}
@property (nonatomic, readwrite) NSInteger type;
@end
