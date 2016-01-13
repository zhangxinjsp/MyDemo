//
//  BLEPeripheralManager.m
//  NEO
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 zhangxin. All rights reserved.
//

#import "BLEPeripheralManager.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEPeripheralManager () <CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBPeripheralManager* peripheralManager;
@property (nonatomic, strong) CBMutableService*     peripheralService;
@property (nonatomic, strong) CBMutableCharacteristic* peripheralCharacteristic;
@end

@implementation BLEPeripheralManager

@synthesize delegate;
@synthesize isAdvertising;

- (instancetype)init {
    self = [super init];
    if (self) {
        LOGINFO(@"准备开启服务");
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:@{CBPeripheralManagerOptionRestoreIdentifierKey : BLUETOOTH_PERIPHERAL_NAME ,
                                                                                                    CBPeripheralManagerOptionShowPowerAlertKey : @YES}];
    }
    return self;
}

- (BOOL)isAdvertising {
    return _peripheralManager.isAdvertising;
}

- (void)releasePeripheral {
    [_peripheralManager stopAdvertising];
    _peripheralManager.delegate = nil;
    _peripheralManager = nil;
}

- (void)stopAdvertising {
    LOGINFO(@"stop Advertising");
    if (_peripheralManager.isAdvertising) {
        [_peripheralManager stopAdvertising];
    }
}

- (void)startAdvertising {
    LOGINFO(@"starting Advertising");
    if (!_peripheralManager.isAdvertising) {
        NSString* deviceName = [UIDevice currentDevice].name;
        LOGINFO(@"set local name %@", deviceName);
        while ([deviceName dataUsingEncoding:NSUTF8StringEncoding].length > 29) {
            deviceName = [deviceName substringToIndex:deviceName.length - 1];
        }
        LOGINFO(@"set local name %@", deviceName);
        [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:CHARACTERISTIC_UUID_STRING]],
                                                   CBAdvertisementDataLocalNameKey : deviceName}];
    }
}

- (void)sendNotifyWithData:(NSData*)data {
    LOGINFO(@"send data is %@", data);
    BOOL sendSuccesss = [self.peripheralManager updateValue:data forCharacteristic:self.peripheralCharacteristic onSubscribedCentrals:nil];

    LOGINFO(@"send data %@", sendSuccesss ? @"success" : @"fail");
    
}

#pragma mark start peripheral
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        LOGINFO(@"ble is unenable");
        return;
    }
    LOGINFO(@"BLE is enable");
    
    self.peripheralCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:CHARACTERISTIC_UUID_STRING]
                                                                      properties:CBCharacteristicPropertyNotify | CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite
                                                                           value:nil
                                                                     permissions:CBAttributePermissionsReadable | CBAttributePermissionsWriteable];
    
    self.peripheralService = [[CBMutableService alloc]initWithType:[CBUUID UUIDWithString:SERVICE_UUID_STRING] primary:YES];
    
    self.peripheralService.characteristics = @[self.peripheralCharacteristic];
    
    [_peripheralManager addService:self.peripheralService];
}
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error{
    
    if (error) {
        LOGINFO(@"Error publishing service: %@", [error localizedDescription]);
        return;
    }
    [self startAdvertising];
    
}

-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    if (error) {
        LOGINFO(@"Error publishing service: %@", [error localizedDescription]);
        return;
    }
    LOGINFO(@"server Advertising");
}

#pragma mark subscribe notify
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic{
    LOGINFO(@"receive subscribe ,maximum Update Value Length is: %d", central.maximumUpdateValueLength);
    if (delegate != nil && [delegate respondsToSelector:@selector(peripheralManagerSubscribeChanged:)]) {
        
//        BLESettingRequestModel* req = [[BLESettingRequestModel alloc]initWithCallsIsOn:[NEOGlobalData sharedInstance].callsIsOn
//                                                                               smsIsOn:[NEOGlobalData sharedInstance].smsIsOn
//                                                                          calendarIsOn:[NEOGlobalData sharedInstance].calendarIsOn];
//        [self sendNotifyWithData:[req bleModelToData]];
//        [self performSelector:@selector(sendNotifyWithData:) withObject:[req bleModelToData] afterDelay:0.5];
        [delegate peripheralManagerSubscribeChanged:YES];
        [self stopAdvertising];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic{
    LOGINFO(@"didUnsubscribeFromCharacteristic");
    if (delegate != nil && [delegate respondsToSelector:@selector(peripheralManagerSubscribeChanged:)]) {
        [self startAdvertising];
        [delegate peripheralManagerSubscribeChanged:NO];
    }
}

#pragma mark receive read write
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    LOGINFO(@"didReceiveReadRequest");
    if ([request.characteristic.UUID isEqual:self.peripheralCharacteristic.UUID]) {
        if (request.offset > self.peripheralCharacteristic.value.length) {
            [_peripheralManager respondToRequest:request withResult:CBATTErrorInvalidOffset];
            return;
        }
        request.value = self.peripheralCharacteristic.value;
        
        [_peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests {
    LOGINFO(@"didReceiveWriteRequests");
    for (CBATTRequest* req in requests) {
        self.peripheralCharacteristic.value = req.value;
        NSData* data = req.value;
        //TODO:可能需要做数据的验证，才给出respond
        if (data != nil) {
            [self.peripheralManager respondToRequest:req withResult:CBATTErrorSuccess];
            if (delegate != nil && [delegate respondsToSelector:@selector(peripheralManagerReceiveWriteData:)]) {
                [delegate peripheralManagerReceiveWriteData:data];
            }
        } else {
            LOGINFO(@"receive write data is <nil>");
        }
    }
}

#pragma mark restore
- (void)peripheralManager:(CBPeripheralManager *)peripheral willRestoreState:(NSDictionary*)dict {
    LOGINFO(@"will Restore State <%@>", dict);
}





















@end
