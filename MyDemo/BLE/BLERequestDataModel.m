//
//  BLERequestDataModel.m
//  testUrl
//
//  Created by xsw on 15/4/13.
//  Copyright (c) 2015年 fdcz. All rights reserved.
//

#import "BLERequestDataModel.h"

@implementation BLERequestDataModel

@synthesize commandId;
@synthesize uuid;

-(NSData *)bleModelToData{
    return nil;
}
@end

@implementation BLESettingRequestModel

@synthesize calendarIsOn;
@synthesize callsIsOn;
@synthesize smsIsOn;

-(instancetype)initWithCallsIsOn:(BOOL)_callsIsOn smsIsOn:(BOOL)_smsIsOn calendarIsOn:(BOOL)_calendarIsOn {
    self = [super init];
    if (self) {
        self.uuid = [CBUUID UUIDWithString:CHARACTERISTIC_UUID_STRING];
        self.commandId = NEOBluetoothConnamdIdSetting;
        self.callsIsOn = _callsIsOn;
        self.calendarIsOn = _calendarIsOn;
        self.smsIsOn = _smsIsOn;
    }
    return self;
}

-(NSData *)bleModelToData{
    
    NSMutableDictionary* sendDict = [[NSMutableDictionary alloc]init];
    [sendDict setObject:@"filters" forKey:@"msg_type"];
    
    NSArray* settingArray = @[@{@"phonecall": (self.callsIsOn    ? @YES : @NO)},
                              @{@"sms"      : (self.smsIsOn      ? @YES : @NO)},
                              @{@"calendar" : (self.calendarIsOn ? @YES : @NO)}];
    [sendDict setObject:settingArray forKey:@"metadata"];
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:sendDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString* string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    LOGINFO(@"send setting json string is :%@", string);
    
    NSMutableData* data = [[NSMutableData alloc]initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    return data;
}
@end

@implementation BLEReceiveNameRequestModel

@synthesize success;

-(instancetype)initWithResult:(BOOL)_success {
    self = [super init];
    if (self) {
        self.uuid = [CBUUID UUIDWithString:CHARACTERISTIC_UUID_STRING];
        self.commandId = NEOBluetoothConnamdIdPCName;
        self.success = _success;
    }
    return self;
}

-(NSData *)bleModelToData{
    
    NSMutableData* data = [[NSMutableData alloc]init];
    
    Byte ID = self.commandId;
    [data appendBytes:&ID length:1];
    
    Byte result = self.success ? NEOBluetoothConnamdResultSuccess : NEOBluetoothConnamdResultFailed;
    [data appendBytes:&result length:1];
    return data;
}
@end

@implementation BLEDisconnectRequestModel

@synthesize isUnpare;

-(instancetype)initWithType:(BOOL)_isUnpare {
    self = [super init];
    if (self) {
        self.uuid = [CBUUID UUIDWithString:CHARACTERISTIC_UUID_STRING];
        self.commandId = NEOBluetoothConnamdIdSetting;
        self.isUnpare = _isUnpare;
    }
    return self;
}

-(NSData *)bleModelToData{
    
    NSMutableDictionary* sendDict = [[NSMutableDictionary alloc]init];
    if (self.isUnpare) {
        [sendDict setObject:@"bluetooth" forKey:@"msg_type"];
        [sendDict setObject:@[@{@"action" : @"unpair"}] forKey:@"metadata"];
    } else {
        [sendDict setObject:@"ancs_ble" forKey:@"msg_type"];
        [sendDict setObject:@[@{@"action" : @"disconnect"}] forKey:@"metadata"];
    }
    
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:sendDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString* string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    LOGINFO(@"send setting json string is :%@", string);
    
    NSMutableData* data = [[NSMutableData alloc]init];
    
//    Byte ID = self.commandId;
//    [data appendBytes:&ID length:1];
    [data appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    return data;
}
@end

