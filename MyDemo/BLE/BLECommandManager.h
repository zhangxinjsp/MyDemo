//
//  CombinedCommandManager.h
//  BLETest
//
//  Created by xsw on 15/5/26.
//  Copyright (c) 2015年 zhangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BluetoothManager.h"


@interface BLECommandManager : NSObject


+ (void)sendSettingInfoWithCallBack:(CallBack)callBack;

+ (void)receivePcNameResponse:(BOOL)success;

+ (void)disconnect;

+ (void)unpare;


@end
