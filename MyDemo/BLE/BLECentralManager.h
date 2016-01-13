//
//  BLECentralManager.h
//  testUrl
//
//  Created by xsw on 15/3/31.
//  Copyright (c) 2015年 fdcz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>


@protocol BLECentralManagerDelegate <NSObject>
-(void)centralManagerStateChanged:(CBCentralManagerState)state;
-(void)discoverPeripheralListChanged;
-(void)connectPeripheralCallBack:(BOOL)connected;
-(void)didDisconnectPeripheral:(BOOL)isAuto;
-(void)writeValueForCharacteristicCallBack:(NSError *)error;
-(void)readNotificationForCharacteristicCallBack:(NSData*)data withUUID:(CBUUID*)uuid;
-(void)characteristicPropertiesError:(BOOL)isNil uuid:(CBUUID*)uuid commandId:(Byte)commandId;

@end

@interface  PeripheralItem : NSObject

@property (nonatomic , strong) CBPeripheral* peripheral;
@property (nonatomic , strong) NSDictionary* advertisementDict;
@property (nonatomic , strong, readonly) NSString* name;

- (instancetype)initWithPeripheral:(CBPeripheral*)_peripheral advertisementDict:(NSDictionary*)_advertisementDict;

@end

@interface CommandItem : NSObject

@property (nonatomic , strong) CBUUID* uuid;
@property (nonatomic , strong) NSData* data;

- (instancetype)initWithData:(NSData*)_data uuid:(CBUUID*)_uuid;

@end

@interface BLECentralManager : NSObject{
    
}

@property (nonatomic , strong) NSMutableArray* peripheralArray;
@property (nonatomic , strong) id<BLECentralManagerDelegate> delegate;
@property (nonatomic , strong) PeripheralItem* currentContectedItem;
@property (nonatomic , strong) CBService* currentService;

-(void)stopScanPeripherals;
-(void)scanForPeripheralsWithServices:(NSArray*)serviceUUIDs;
-(void)connectPeripheral:(NSUInteger)peripheralIndex;
-(void)connectCurrentPeripheral;
-(void)disconnectPeripheral:(NSUInteger)peripheralIndex;
-(void)disconnectCurrentPeripheral;
-(void)readValueForCharacteristic:(CBUUID*)uuid;
-(void)writeValueForCharacteristic:(CBUUID*)uuid data:(NSData*)data;



@end
