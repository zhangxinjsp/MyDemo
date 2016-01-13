//
//  ZBarViewController.h
//  UINavgationController
//
//  Created by zhangxin on 14/12/12.
//  Copyright (c) 2014年 zhangxin. All rights reserved.
//
/*
 需要倒入的相关framework
 libiconv.dylib
 QuartzCore.framework
 CoreVideo.framework
 CoreMedia.framework
 AVfoundation.framework
 */
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"



@interface ZBarViewController : BaseViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end
