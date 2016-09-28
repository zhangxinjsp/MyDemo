//
//  BleuToothManager.h
//  testUrl
//
//  Created by xsw on 15/3/31.
//  Copyright (c) 2015年 fdcz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLERequestDataModel.h"
#import "BLERespondDataModel.h"
#import "BLECentralManager.h"

typedef void (^CallBack)(BLERespondDataModel* model);
typedef void (^WriteCallBack)(NSError* error);
typedef void (^ConnectedBlock)(BOOL connected);

@protocol BluetoothManagerDiscoverDelegate <NSObject>

- (void)discoverPeripheralsListChanged;

@end


@interface BluetoothManager : NSObject{
    
}

+ (instancetype)sharedInstance;

#pragma mark central
@property (nonatomic, assign) id<BluetoothManagerDiscoverDelegate> delegate;
@property (nonatomic, strong, readonly) NSMutableArray* peripheralArray;
@property (nonatomic, readonly) BOOL isCentralConnected;
@property (nonatomic, readonly) BOOL isBleOn;
@property (nonatomic, readonly) CBManagerState centralManagerState;
@property (nonatomic, readonly, strong) NSString* currentPeripheralName;

-(void)startBluetoothCentral;
/* 这三个方法用不到
-(void)scanForPeripherals;
-(void)stopScanPeripherals;
-(void)connectPeripheral:(NSUInteger)peripheralIndex result:(ConnectedBlock)result;
 */
-(void)reconnectCurrentPeripheral:(ConnectedBlock)result;
-(void)scanAndConnectLastPeripheral:(ConnectedBlock)result;//使用这个方法，扫描连接deviceIdentifierName的外设
-(void)disconnectPeripheral:(NSUInteger)peripheralIndex;
-(void)disconnectCurrentPeripheral;
/**
 *  ble的请求数据
 *
 *  @param req      请求的参数，当req为nil时不发送请求，等待GC事件的响应
 *  @param callBack 回调的block
 */
-(void)writeValueForCharacteristicWithRequest:(BLERequestDataModel*)req callBack:(CallBack)callBack;

/**
 *  ble 在不需要知道返回数据的时候使用
 *
 *  @param req      请求的参数，当req为nil时不发送请求，
 *  @param callBack 回调的block，
 */
-(void)writeValueForCharacteristicWithRequest:(BLERequestDataModel*)req writeCallBack:(WriteCallBack)callBack;

#pragma mark peripheral
@property (nonatomic, readonly) BOOL isPeripheralConnected;
@property (nonatomic, readonly) BOOL peripheralIsAdvertising;

- (void)startBluetoothPeripheral;

- (void)releasePeripheral;

- (void)peripheralStopAdvertising ;

- (void)peripheralStartAdvertising ;

- (void)sendNotifyWithData:(BLERequestDataModel*)req callBack:(CallBack)callBack;

@end
