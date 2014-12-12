//
//  ZBarViewController.h
//  UINavgationController
//
//  Created by xsw on 14/12/12.
//  Copyright (c) 2014年 niexin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"

@interface ZBarViewController : BaseViewController <ZBarReaderDelegate>

@end
