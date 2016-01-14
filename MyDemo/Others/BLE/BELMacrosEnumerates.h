//
//  BELMacrosEnumerates.h
//  BLETest
//
//  Created by 张鑫 on 15/4/22.
//  Copyright (c) 2015年 zhangxin. All rights reserved.
//


#ifndef BLETest_BELMacrosEnumerates_h
#define BLETest_BELMacrosEnumerates_h

//test uuid string
#define SERVICE_UUID_STRING           @"7905F431-B5CE-4E99-A40F-4B1E122D0000"
#define CHARACTERISTIC_UUID_STRING    @"08590F7E-DB05-467E-8757-72F6FAEB13D4"

#define BLUETOOTH_CENTRAL_NAME    @"MY_CENTRAL"
#define BLUETOOTH_PERIPHERAL_NAME    @"MY_PERIPHERAL"

#define BluetoothStateDidChangedNotification  @"BluetoothStateDidChanged"
#define BluetoothDidDisconnectedNotification  @"BluetoothDidDisconnected"

#define BluetoothSubscribeChangedNotification   @"SubscribeChangedNotification"
#define BluetoothReceiveNameNotification        @"ReceiveNameNotification"

typedef NS_ENUM(NSUInteger, NEOBluetoothConnamdId){
    NEOBluetoothConnamdIdPCName     = 0x11,
    NEOBluetoothConnamdIdSetting    = 0x21,
};

typedef NS_ENUM(NSUInteger, NEOBluetoothConnamdResult){
    NEOBluetoothConnamdResultSuccess   = 0x00,
    NEOBluetoothConnamdResultFailed
};










#endif


















