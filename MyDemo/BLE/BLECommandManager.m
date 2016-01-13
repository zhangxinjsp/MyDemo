//
//  CombinedCommandManager.m
//  BLETest
//
//  Created by xsw on 15/5/26.
//  Copyright (c) 2015年 zhangxin. All rights reserved.
//

#import "BLECommandManager.h"

@implementation BLECommandManager




+ (void)sendSettingInfoWithCallBack:(CallBack)callBack {
    
//    BLESettingRequestModel* req = [[BLESettingRequestModel alloc]initWithCallsIsOn:[NEOGlobalData sharedInstance].callsIsOn
//                                                                           smsIsOn:[NEOGlobalData sharedInstance].smsIsOn
//                                                                      calendarIsOn:[NEOGlobalData sharedInstance].calendarIsOn];
//    [[BluetoothManager sharedInstance]sendNotifyWithData:req callBack:callBack];
}

+ (void)receivePcNameResponse:(BOOL)success {
    BLEReceiveNameRequestModel* req = [[BLEReceiveNameRequestModel alloc]initWithResult:success];
    [[BluetoothManager sharedInstance]sendNotifyWithData:req callBack:nil];
}

+(void)disconnect {
    BLEDisconnectRequestModel* req = [[BLEDisconnectRequestModel alloc]initWithType:NO];
    [[BluetoothManager sharedInstance]sendNotifyWithData:req callBack:nil];
}

+(void)unpare {
    BLEDisconnectRequestModel* req = [[BLEDisconnectRequestModel alloc]initWithType:YES];
    [[BluetoothManager sharedInstance]sendNotifyWithData:req callBack:nil];
}



@end
