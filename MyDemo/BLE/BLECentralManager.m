//
//  BLECentralManager.m
//  testUrl
//
//  Created by xsw on 15/3/31.
//  Copyright (c) 2015年 fdcz. All rights reserved.
//

#import "BLECentralManager.h"

#import "BELMacrosEnumerates.h"

@implementation PeripheralItem

@synthesize peripheral;
@synthesize advertisementDict;

- (instancetype)initWithPeripheral:(CBPeripheral*)_peripheral advertisementDict:(NSDictionary*)_advertisementDict{
    self = [super init];
    if (self) {
        self.peripheral        = _peripheral;
        self.advertisementDict = _advertisementDict;
    }
    return self;
}

-(NSString *)name{
    NSString* peripheralName = self.advertisementDict[CBAdvertisementDataLocalNameKey];
    if (!peripheralName || [peripheralName isEqualToString:@""]) {
        peripheralName  = [self.peripheral.name stringByTrimmingCharactersInSet:[[NSCharacterSet alphanumericCharacterSet]invertedSet]];
    }
    return peripheralName;
}



- (void)dealloc
{
    self.peripheral = nil;
    self.advertisementDict = nil;
}

@end

@implementation CommandItem
@synthesize data;
@synthesize uuid;
-(instancetype)initWithData:(NSData *)_data uuid:(CBUUID *)_uuid{
    self = [super init];
    if (self) {
        self.data = _data;
        self.uuid = _uuid;
    }
    return self;
}


@end


@interface BLECentralManager () <CBCentralManagerDelegate, CBPeripheralDelegate>{
    
    CBCentralManager* myCentralManager;
    NSMutableArray* characteristicArray;
    
    NSMutableDictionary* _longCommandSaveDict;
    NSMutableArray* _commandSendArray;
    NSInteger _receiveTotalPage;
    NSArray* _discoverServiceUUIDs;
    BOOL _autoDisconnect;
    BOOL _isSendingCommand;
}

@property (nonatomic, strong) CBCentralManager* myCentralManager;
@property (nonatomic, strong) NSMutableArray* characteristicArray;




@end

@implementation BLECentralManager

@synthesize peripheralArray;
@synthesize delegate;
@synthesize currentContectedItem;
@synthesize currentService;
//private
@synthesize myCentralManager;
@synthesize characteristicArray;



-(id)init{
    self = [super init];
    if (self) {
        _autoDisconnect = YES;
        myCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionRestoreIdentifierKey : BLUETOOTH_CENTRAL_NAME,
                                                                                               CBCentralManagerOptionShowPowerAlertKey : @YES}];
        peripheralArray = [[NSMutableArray alloc]init];
        characteristicArray = [[NSMutableArray alloc]init];
        _longCommandSaveDict = [[NSMutableDictionary alloc]init];
        _commandSendArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)stopScanPeripherals{
    LOGINFO(@"Scanning stopped");
    [myCentralManager stopScan];
}

-(void)scanForPeripheralsWithServices:(NSArray*)serviceUUIDs
{
    LOGINFO(@"start scan");
    [self disconnectCurrentPeripheral];
    self.currentContectedItem = nil;
    
    [self.peripheralArray removeAllObjects];
    
    if (delegate && [delegate respondsToSelector:@selector(discoverPeripheralListChanged)]) {
        [delegate discoverPeripheralListChanged];
    }
    _discoverServiceUUIDs = nil;
    _discoverServiceUUIDs = [[NSArray alloc]initWithArray:serviceUUIDs];
    [myCentralManager scanForPeripheralsWithServices:serviceUUIDs options:@{CBCentralManagerScanOptionAllowDuplicatesKey : [NSNumber numberWithBool:YES]}];
}

-(void)connectPeripheral:(NSUInteger)peripheralIndex{
    
    [self stopScanPeripherals];
    
    [self disconnectCurrentPeripheral];
    self.currentContectedItem = nil;
    self.currentService = nil;
    [characteristicArray removeAllObjects];
    [_commandSendArray removeAllObjects];
    
    CBPeripheral *peripheral = ((PeripheralItem*)[peripheralArray objectAtIndex:peripheralIndex]).peripheral;
    LOGINFO(@"connect Peripheral:%@", peripheral.name);
    [myCentralManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey: [NSNumber numberWithBool:YES],
                                                             CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
}

-(void)connectCurrentPeripheral{
    if (self.currentContectedItem) {
        LOGINFO(@"connect Peripheral:%@", self.currentContectedItem.peripheral.name);
        if (self.currentContectedItem.peripheral.state != CBPeripheralStateDisconnected) {
            [self disconnectCurrentPeripheral];
        }
        self.currentService = nil;
        [characteristicArray removeAllObjects];
        [_commandSendArray removeAllObjects];
        [myCentralManager connectPeripheral:self.currentContectedItem.peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey: [NSNumber numberWithBool:YES],
                                                                                           CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
    }
}

-(void)disconnectPeripheral:(NSUInteger)peripheralIndex{
    CBPeripheral *peripheral = ((PeripheralItem*)[peripheralArray objectAtIndex:peripheralIndex]).peripheral;
    if (peripheral.state != CBPeripheralStateDisconnected) {
        LOGINFO(@"disconnect Peripheral:%@", peripheral.name);
        for (CBService *service in peripheral.services) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                if (characteristic.isNotifying) {
                    // It is notifying, so unsubscribe
                    LOGINFO(@"characteristic is notifying, stopped: %@", characteristic);
                    [self.currentContectedItem.peripheral setNotifyValue:NO forCharacteristic:characteristic];
                }
            }
        }
        _autoDisconnect = NO;
        [myCentralManager cancelPeripheralConnection:peripheral];
    }
}

-(void)disconnectCurrentPeripheral{
    LOGINFO(@"disconnect Peripheral:%@", self.currentContectedItem.peripheral.name);
    if (self.currentContectedItem && self.currentContectedItem.peripheral.state != CBPeripheralStateDisconnected) {
        for (CBCharacteristic *characteristic in self.currentService.characteristics) {
            if (characteristic.isNotifying) {
                // It is notifying, so unsubscribe
                LOGINFO(@"characteristic is notifying, stopped: %@", characteristic);
                [self.currentContectedItem.peripheral setNotifyValue:NO forCharacteristic:characteristic];
            }
        }
        _autoDisconnect = NO;
        [myCentralManager cancelPeripheralConnection:self.currentContectedItem.peripheral];
    }
}

#pragma mark -- CBCentralManager delegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    LOGINFO(@"%@", central);
    if (delegate && [delegate respondsToSelector:@selector(centralManagerStateChanged:)]){
        [delegate centralManagerStateChanged:central.state];
    }
}

-(void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict{
    LOGINFO(@"%@", dict);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if (peripheralArray) {//获取到有用的peripheral
        NSArray* array = [peripheralArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.peripheral.identifier == %@", peripheral.identifier]];
        if (array.count == 0) {
            if ([self checkIsVive:advertisementData]) {
                LOGINFO(@"%@ \n advertisementData:%@ \n%@", peripheral, advertisementData, RSSI);
                [peripheralArray addObject:[[PeripheralItem alloc]initWithPeripheral:peripheral advertisementDict:advertisementData]];
                if (delegate && [delegate respondsToSelector:@selector(discoverPeripheralListChanged)]) {
                    [delegate discoverPeripheralListChanged];
                }
            }
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    LOGINFO(@"Peripheral connect success");
    peripheral.delegate = self;
    [peripheral discoverServices:_discoverServiceUUIDs];
    _autoDisconnect = YES;
    
    if (![self.currentContectedItem.peripheral isEqual:peripheral]) {
        [self disconnectCurrentPeripheral];
        self.currentContectedItem = nil;
    }
    for (PeripheralItem* item in self.peripheralArray) {
        if ([item.peripheral.identifier isEqual:peripheral.identifier]) {
            self.currentContectedItem = item;
            break;
        }
    }
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    LOGINFO(@"Peripheral connect fail ,error is: %@", error);
    if (delegate && [delegate respondsToSelector:@selector(connectPeripheralCallBack:)]) {
        [delegate connectPeripheralCallBack:NO];
    }
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    LOGINFO(@"did Disconnect <%@>,error is: %@", _autoDisconnect ? @"auto" : @"by user", error);
    
    if (delegate && [delegate respondsToSelector:@selector(didDisconnectPeripheral:)]) {
        [delegate didDisconnectPeripheral:_autoDisconnect];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        LOGINFO(@"Discovered service fail error is :%@", error);
    } else {
        CBService* interestingService = nil;
        
        for (CBService *service in peripheral.services) {
            LOGINFO(@"Discovered service %@ error is :%@", service.UUID, error);
            //本生只会存在一种service
            for (CBUUID* uuid in _discoverServiceUUIDs) {
                if ([service.UUID isEqual:uuid]) {
                    interestingService = service;
                    break;
                }
            }
            if (interestingService) {
                self.currentService = interestingService;
                LOGINFO(@"Discovering characteristics for service %@", interestingService);
                [peripheral discoverCharacteristics:nil forService:interestingService];
                break;
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        LOGINFO(@"Discovered characteristic fail error is  %@", error);
    } else {
        if (characteristicArray) {
            [characteristicArray removeAllObjects];
        } else {
            characteristicArray = [[NSMutableArray alloc]init];
        }
        for (CBCharacteristic *characteristic in service.characteristics) {
            LOGINFO(@"Discovered characteristic %@ error is :%@", characteristic.UUID, error);
            
            if (characteristic.properties & CBCharacteristicPropertyNotify) {
                //订阅一个通知，当值发生变化的时候会主动通知
                LOGINFO(@"can set notfy");
                [self.currentContectedItem.peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
            [characteristicArray addObject:characteristic];
        }
        if (delegate && [delegate respondsToSelector:@selector(connectPeripheralCallBack:)]) {
            [delegate connectPeripheralCallBack:YES];
        }
    }
}

-(void)writeValueForCharacteristic:(CBUUID*)uuid data:(NSData*)data{
    LOGINFO(@"write uuid is %@ data is %@", uuid, data);
    [self packageData:data uuid:uuid];

    CBCharacteristic *characteristic = [self getCharacteristicWithUUID:uuid];
    if (characteristic.properties & CBCharacteristicPropertyWrite) {
        CommandItem* item = [_commandSendArray firstObject];
        if (!_isSendingCommand) {
            LOGINFO(@"send first command ! uuid is:%@, data is :%@ ", item.uuid, item.data);
            _isSendingCommand = YES;
            [self.currentContectedItem.peripheral writeValue:item.data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            //[item.data subdataWithRange:NSMakeRange(0, 150)]
        } else {
            LOGINFO(@"send command later ! uuid is:%@, data is :%@ ", item.uuid, item.data);
        }
    }else{
        LOGINFO(@"%@ can not write!", characteristic);
        if (delegate && [delegate respondsToSelector:@selector(characteristicPropertiesError:uuid:commandId:)]) {
            Byte* bytes = (Byte*)[data bytes];
            [delegate characteristicPropertiesError:(characteristic == nil) uuid:uuid commandId:bytes[0]];
        }
    }
}

-(void)readValueForCharacteristic:(CBUUID *)uuid{
    LOGINFO(@"read data from uuid is %@!", uuid);
    CBCharacteristic *characteristic = [self getCharacteristicWithUUID:uuid];
    if (characteristic.properties & CBCharacteristicPropertyRead) {
        //主动去读区这里面的值，
        [self.currentContectedItem.peripheral readValueForCharacteristic:characteristic];
    }else{
        LOGINFO(@"%@ can not read!", characteristic);
        if (delegate && [delegate respondsToSelector:@selector(characteristicPropertiesError:uuid:commandId:)]) {
            [delegate characteristicPropertiesError:(characteristic == nil) uuid:uuid commandId:0];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error) {
        LOGINFO(@"Error writing characteristic value: %@ ;uuid is %@", [error localizedDescription], characteristic.UUID);
//        如果当前指令发送失败清除，当前还没有发送的相关指令
        BOOL clean = YES;
        while (clean) {
            @try {
                [_commandSendArray removeObjectAtIndex:0];
                CommandItem* item = [_commandSendArray firstObject];
                clean = [item.uuid isEqual:characteristic.UUID];
            }
            @catch (NSException *exception) {
                LOGINFO(@"%@", exception);
                clean = NO;
            }
        }
    }else{
        CommandItem* item = [_commandSendArray firstObject];
        LOGINFO(@"write success callback, uuid is %@ data is %@", characteristic.UUID, characteristic.value);
        if (item != nil) {
            LOGINFO(@"send command success, uuid is %@ data is %@", item.uuid, item.data);
            [_commandSendArray removeObjectAtIndex:0];
        }
        LOGINFO(@"send command success, left command count: %lu", (unsigned long)_commandSendArray.count);
    }
    if (_commandSendArray.count > 0) {
        CommandItem* item = [_commandSendArray firstObject];
        if ([item.uuid isEqual:characteristic.UUID]) {
            LOGINFO(@"send next command ! uuid is :%@, data is :%@ ", item.uuid, item.data);
            _isSendingCommand = YES;
            [self.currentContectedItem.peripheral writeValue:item.data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        } else {
            //如果当前指令与上一条的指令uuid不一样，说明上一条指令已经发送完成
            if (delegate && [delegate respondsToSelector:@selector(writeValueForCharacteristicCallBack:)]) {
                [delegate writeValueForCharacteristicCallBack:error];
            }
            
            LOGINFO(@"send first command ! uuid is :%@, data is :%@", item.uuid, item.data);
            CBCharacteristic *charact = [self getCharacteristicWithUUID:item.uuid];
            if (charact) {
                _isSendingCommand = YES;
                [self.currentContectedItem.peripheral writeValue:item.data forCharacteristic:charact type:CBCharacteristicWriteWithResponse];
            }
        }
    }else{
        _isSendingCommand = NO;
        if (delegate && [delegate respondsToSelector:@selector(writeValueForCharacteristicCallBack:)]) {
            [delegate writeValueForCharacteristicCallBack:error];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    NSData *data = characteristic.value;
    
    LOGINFO(@"receive uuid is %@; data is %@ length is %lu", characteristic.UUID, data, (unsigned long)data.length);
    
    [self analysisAndCallbackData:data uuid:characteristic.UUID];
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error) {
        LOGINFO(@"Error changing notification state: %@; uuid is %@", [error localizedDescription], characteristic.UUID);
    }else{
        if (characteristic.isNotifying) {
            LOGINFO(@"Notification began on %@", characteristic);
        } else {
            // Notification has stopped
            // so disconnect from the peripheral
            LOGINFO(@"Notification stopped on %@. Disconnecting", characteristic);
            [self disconnectCurrentPeripheral];
        }
    }
}

#pragma mark tool method
-(CBCharacteristic*)getCharacteristicWithUUID:(CBUUID*)uuid{
    if (uuid == nil) {
        return nil;
    }
    LOGINFO(@"count is %lu .", (unsigned long)characteristicArray.count);
    for (CBCharacteristic *characteristic in self.characteristicArray) {
        if ([characteristic.UUID isEqual:uuid]) {
            LOGINFO(@"get Characteristic is : %@.", characteristic);
            return characteristic;
        }
    }
    return nil;
}

- (BOOL)checkIsVive:(NSDictionary*)advertisementData {
    
    return YES;
        
}

#pragma mark  data analyse and package
-(void)packageData:(NSData*)data uuid:(CBUUID*)uuid{
    LOGINFO(@"package  callback data, uuid is :%@, original data is :%@ ", uuid, data);
    LOGINFO(@"add new command, left command count: %lu  ", (unsigned long)_commandSendArray.count);
    
    [_commandSendArray addObject:[[CommandItem alloc]initWithData:data uuid:uuid]];
    
}

-(void)analysisAndCallbackData:(NSData*)data uuid:(CBUUID*)uuid{
    LOGINFO(@"analysis  callback data");
    @try {
        if (delegate && [delegate respondsToSelector:@selector(readNotificationForCharacteristicCallBack:withUUID:)]) {
            LOGINFO(@"receive complete data %@", data);
            [delegate readNotificationForCharacteristicCallBack:data withUUID:uuid];
        }
    }
    @catch (NSException *exception) {
        LOGINFO(@"analysis  callback data failed ,the exception is : %@", exception);
    }
    @finally {
        
    }
    
}

















@end
