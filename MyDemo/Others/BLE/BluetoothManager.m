//
//  BleuToothManager.m
//  testUrl
//
//  Created by xsw on 15/3/31.
//  Copyright (c) 2015年 fdcz. All rights reserved.
//

#import "BluetoothManager.h"
#import "BLEPeripheralManager.h"

#define Bluetooth_FOTA_UPDATE_TIMEOUT       70
#define Bluetooth_CALLBACK_TIMEOUT          30
#define Bluetooth_SCAN_LAST_CONNECT_TIMEOUT 30

@interface BluetoothManager ()<BLECentralManagerDelegate, BLEPeripheralManagerDelegate, UIAlertViewDelegate>{
    BOOL reconnectLast;
    
    BLECentralManager* _centralManager;
    BLEPeripheralManager *_peripheralManager;
    ConnectedBlock _connectedBlock;
    
    NSMutableDictionary* _callbackDict;
    NSMutableArray* _writeCallbackArray;
}

@property (nonatomic, readwrite) BOOL reconnectLast;

@end

@implementation BluetoothManager

@synthesize delegate;
@synthesize peripheralArray;
@synthesize isCentralConnected;
@synthesize isBleOn;
@synthesize centralManagerState;
@synthesize currentPeripheralName;

//private
@synthesize reconnectLast;

+(instancetype)sharedInstance{
    static BluetoothManager *instance;
    if (instance == nil) {
        @synchronized(self){//同步块
            if (instance == nil) {
                instance= [[BluetoothManager alloc] init];
            }
        }
    }
    return instance;
}

-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)startBluetoothCentral{
    if (!_centralManager) {
        _centralManager = [[BLECentralManager alloc]init];
        _centralManager.delegate = self;
        LOGINFO(@"Bluetooth central start");
    } else {
        LOGINFO(@"Bluetooth central already start");
    }
}

-(BOOL)isCentralConnected {
    if (!_centralManager.currentContectedItem) {
        return NO;
    }
    return _centralManager.currentContectedItem.peripheral.state == CBPeripheralStateConnected;
}

-(NSString *)currentPeripheralName{
    return _centralManager.currentContectedItem.name;
}

//Bluetooth action
-(void)scanForPeripherals{

    LOGINFO(@"scan for Vives !!");
    [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:SERVICE_UUID_STRING]]];
//    [_centralManager scanForPeripheralsWithServices:nil];

}

-(void)stopScanPeripherals{
    self.reconnectLast = NO;
    [_centralManager stopScanPeripherals];
}

-(void)connectPeripheral:(NSUInteger)peripheralIndex result:(ConnectedBlock)result{
    if (result) {
        _connectedBlock = result;
    }
    [_centralManager connectPeripheral:peripheralIndex];
}

-(void)reconnectCurrentPeripheral:(ConnectedBlock)result{
    LOGINFO(@"reconnect !");
    if (result) {
        _connectedBlock = result;
    }
    [_centralManager connectCurrentPeripheral];
}

-(void)scanAndConnectLastPeripheral:(ConnectedBlock)result{
    self.reconnectLast = YES;
    [self performSelector:@selector(scanLastAndConnectPeripheralsTimeout) withObject:nil afterDelay:Bluetooth_SCAN_LAST_CONNECT_TIMEOUT];
    if (result) {
        _connectedBlock = result;
    }
    if (isBleOn) {
        //在蓝牙开启的状态扫描才有意义
        [self scanForPeripherals];
    }
}

-(void)disconnectPeripheral:(NSUInteger)peripheralIndex{
    [_centralManager disconnectPeripheral:peripheralIndex];
}

-(void)disconnectCurrentPeripheral{
    [_centralManager disconnectCurrentPeripheral];
}

-(void)writeValueForCharacteristicWithRequest:(BLERequestDataModel *)req callBack:(CallBack)callBack{

    [self saveCallbackBlockWithId:req.commandId block:callBack request:req];
    LOGINFO(@"write this request!!");
    if (req == nil) {
        [_centralManager readValueForCharacteristic:req.uuid];
    } else {
        [_centralManager writeValueForCharacteristic:req.uuid data:[req bleModelToData]];
    }
}

-(void)writeValueForCharacteristicWithRequest:(BLERequestDataModel *)req writeCallBack:(WriteCallBack)callBack{
    
    if (!_writeCallbackArray) {
        _writeCallbackArray = [[NSMutableArray alloc]init];
    }
    [_writeCallbackArray addObject:callBack];
    if (req != nil) {
        [_centralManager writeValueForCharacteristic:req.uuid data:[req bleModelToData]];
    }
}
#pragma mark center manager delegate

-(void)centralManagerStateChanged:(CBManagerState)state{
    switch (state) {
        case CBCentralManagerStateUnknown:
            LOGINFO(@"Bluetooth state is %@", @"unknow");
            break;
        case CBCentralManagerStateResetting:
            LOGINFO(@"Bluetooth state is %@", @"Resetting");
            break;
        case CBCentralManagerStateUnsupported:
            LOGINFO(@"Bluetooth state is %@", @"Unsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            LOGINFO(@"Bluetooth state is %@", @"Unauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            LOGINFO(@"Bluetooth state is %@", @"PoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            LOGINFO(@"Bluetooth state is %@", @"PoweredOn");
            break;
        default:
            break;
    }
    if (self.reconnectLast && state == CBCentralManagerStatePoweredOn) {
        [self scanForPeripherals];
    }
    centralManagerState = state;
    isBleOn = state == CBCentralManagerStatePoweredOn;
    [[NSNotificationCenter defaultCenter]postNotificationName:BluetoothStateDidChangedNotification object:[NSNumber numberWithInteger:state]];
}

-(void)discoverPeripheralListChanged{
    
    [self.peripheralArray removeAllObjects];
    peripheralArray = nil;
    
    peripheralArray = [[NSMutableArray alloc]initWithArray:_centralManager.peripheralArray];
    
    if (self.reconnectLast) {
        PeripheralItem* peripheral = [peripheralArray lastObject];
        LOGINFO(@"last connect ble :%@ discover ble: %@ ", @"", peripheral.name);
        if (1) {
            LOGINFO(@"discover last connect ble : %@", @"");
            [self connectPeripheral:peripheralArray.count - 1 result:nil];
        }
    } else {
        if (delegate && [delegate respondsToSelector:@selector(discoverPeripheralsListChanged)]) {
            [delegate discoverPeripheralsListChanged];
        }
    }
}

-(void)connectPeripheralCallBack:(BOOL)connected{

    self.reconnectLast = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scanLastAndConnectPeripheralsTimeout) object:nil];
    if (_connectedBlock != nil) {
        _connectedBlock(connected);
        _connectedBlock = nil;
    }
}

-(void)didDisconnectPeripheral:(BOOL)isAuto {
    LOGINFO(@"ble disconnect <%@>!!!", isAuto ? @"auto" : @"by user");
//    BI_ADD_LOG(BIACtionDisconnected);
    [[NSNotificationCenter defaultCenter]postNotificationName:BluetoothDidDisconnectedNotification object:[NSNumber numberWithBool:isAuto]];
}

-(void)characteristicPropertiesError:(BOOL)isNil uuid:(CBUUID *)uuid commandId:(Byte)commandId{
    if (isNil) {
        LOGINFO(@"characteristic is something wrong: %@", @"characteristic is null");
    } else {
        LOGINFO(@"characteristic is something wrong: %@", @"characteristic properties is not correct");
    }
}

-(void)writeValueForCharacteristicCallBack:(NSError *)error{
    @try {
        if (error) {
            
        } else {
            LOGINFO(@"commend send success !!");
            WriteCallBack callback = [_writeCallbackArray firstObject];
            if (callback) {
                [_writeCallbackArray removeObjectAtIndex:0];
                callback(error);
            }
        }
    }
    @catch (NSException *exception) {
        LOGINFO(@"%@", exception);
    }
}

-(void)readNotificationForCharacteristicCallBack:(NSData *)data withUUID:(CBUUID *)uuid {
    
    BLERespondDataModel* model;
    
    Byte ID;
    [data getBytes:&ID range:NSMakeRange(0, 1)];
    model = [self eventModelWithID:ID andData:data];
    if (model) {
        [self backEvent:model evnetId:[NSString stringWithFormat:@"%x", ID] timeout:NO];
    } else {
        
    }
}

- (void)backEvent:(BLERespondDataModel*)model evnetId:(NSString*)eventId timeout:(BOOL)timeout{
    if (!timeout) {
        [self handleInternalCallbackBusinessLogic:model];
    }
    CallBack callback;

    callback = [_callbackDict objectForKey:eventId];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(eventCallbackTimeoutCommandId:) object:eventId];

    if (callback != nil) {
        LOGINFO(@"callback success !");
        [self removeCallbackWithEvnetModel:model eventId:eventId];
        callback(model);
    } else {
        LOGINFO(@"callback fail !");
    }
}

#pragma mark 回调block的存储
- (void)saveCallbackBlockWithId:(Byte)Id block:(CallBack)block request:(BLERequestDataModel *)req{
    if (_callbackDict == nil) {
        _callbackDict = [[NSMutableDictionary alloc]init];
    }
    if (block == nil) {
        return;
    }
    //TODO:还在整理中可能会出现一些问题
    switch (Id) {
        
        default:{
            [self addTimeOutAndSaveBlock:block withEventId:Id];
        }
            break;
    }
}

- (void)removeCallbackWithEvnetModel:(BLERespondDataModel*)model eventId:(NSString*)eventId{
    
    [_callbackDict removeObjectForKey:eventId];
}

- (void)addTimeOutAndSaveBlock:(CallBack)block withEventId:(Byte)eventId {
    NSString* key = [NSString stringWithFormat:@"%x", eventId];
    
    [self performSelector:@selector(eventCallbackTimeoutCommandId:) withObject:key afterDelay:Bluetooth_CALLBACK_TIMEOUT];
    
    [_callbackDict setObject:block forKey:key];
}



- (void)eventCallbackTimeoutCommandId:(NSString*)idStr{
    LOGINFO(@"request ble time out! id is <%@>", idStr);
    
    Byte bytes[] = {0x21, 0x01};
    NSData* data = [[NSData alloc]initWithBytes:&bytes length:2];
    
    BLERespondDataModel* model = [[BLERespondDataModel alloc]initWithData:data];
    [self backEvent:model evnetId:idStr timeout:YES];

}

- (void)scanLastAndConnectPeripheralsTimeout{
    LOGINFO(@"scan and connect last ble time out!" );
    if (!_centralManager.currentContectedItem) {
        LOGINFO(@"did not discover last connect ble!" );
    }
    [self connectPeripheralCallBack:NO];
}
#pragma mark 数据解析
-(BLERespondDataModel*)eventModelWithID:(Byte)ID andData:(NSData*)data{
    switch (ID) {

        default:
            LOGINFO(@"there is not correct data model pairing，command is : %x. use base model", ID);
            return [[BLERespondDataModel alloc]initWithData:data];
    }
}

#pragma mark 需要在内部自动处理的业务逻辑
- (void)handleInternalCallbackBusinessLogic:(BLERespondDataModel*)model {
    switch (model.commandId) {
        case 0x00: {
            
        }

            break;
        default:
            break;
    }
}

#pragma mark -----
#pragma mark peripheral 相关处理
#pragma mark -----

@synthesize isPeripheralConnected;
@synthesize peripheralIsAdvertising;

- (BOOL)isPeripheralConnected {
    return isPeripheralConnected;
}

- (BOOL)peripheralIsAdvertising {
    return _peripheralManager.isAdvertising;
}

- (void)startBluetoothPeripheral {
    if (!_peripheralManager) {
        _peripheralManager = [[BLEPeripheralManager alloc]init];
        _peripheralManager.delegate = self;
        LOGINFO(@"Bluetooth Peripheral start");
    } else {
        LOGINFO(@"Bluetooth Peripheral already start");
    }
}

- (void)sendNotifyWithData:(BLERequestDataModel *)req callBack:(CallBack)callBack{
    
    [self saveCallbackBlockWithId:req.commandId block:callBack request:req];
    [_peripheralManager sendNotifyWithData:[req bleModelToData]];
}

- (void)peripheralManagerReceiveWriteData:(NSData *)data {
    LOGINFO(@"receive data is :%@", data);
    Byte *byte = (Byte *)[data bytes];
    switch (byte[0]) {
        case NEOBluetoothConnamdIdPCName: {
            NSString* receiveString = [[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(1, data.length - 1)] encoding:NSUTF8StringEncoding];
            LOGINFO(@"receive pc name is :<%@>", receiveString);
            
            //TODO:先使用字符串形式的Mac地址 c8:2a:14:59:27:04 长度17
            
            NSString* pcName = [receiveString substringToIndex:(receiveString.length - 17)];
            
//            [NEOGlobalData sharedInstance].connectedViveName = pcName;
//            [NEOGlobalData sharedInstance].connectedViveMacAddress = [receiveString substringFromIndex:receiveString.length - 17];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:BluetoothReceiveNameNotification object:pcName];
        }
            break;
        case NEOBluetoothConnamdIdSetting: {
            LOGINFO(@"receive setting respons is :%@", data);
            
            [self readNotificationForCharacteristicCallBack:data withUUID:nil];
        }
            break;
            
        default:
            break;
    }
}

- (void)releasePeripheral {
    [_peripheralManager releasePeripheral];
    _peripheralManager.delegate = nil;
    _peripheralManager = nil;
}

- (void)peripheralStopAdvertising {
    [_peripheralManager stopAdvertising];
}

- (void)peripheralStartAdvertising {
    [_peripheralManager startAdvertising];
}

- (void)peripheralManagerSubscribeChanged:(BOOL)isSubscribe {
    isPeripheralConnected = isSubscribe;
    [[NSNotificationCenter defaultCenter]postNotificationName:BluetoothSubscribeChangedNotification object:[NSNumber numberWithBool:isSubscribe]];
}












@end
