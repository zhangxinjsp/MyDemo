//
//  BLERequestDataModel.h
//  testUrl
//
//  Created by xsw on 15/4/13.
//  Copyright (c) 2015年 fdcz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreGraphics/CoreGraphics.h>
#import "BELMacrosEnumerates.h"


@interface BLERequestDataModel : NSObject


@property (nonatomic, readwrite) Byte commandId;
@property (nonatomic, strong) CBUUID* uuid;
-(NSData*)bleModelToData;

@end


@interface BLESettingRequestModel : BLERequestDataModel

@property (nonatomic, assign) BOOL callsIsOn;
@property (nonatomic, assign) BOOL smsIsOn;
@property (nonatomic, assign) BOOL calendarIsOn;

-(instancetype)initWithCallsIsOn:(BOOL)callsIsOn smsIsOn:(BOOL)smsIsOn calendarIsOn:(BOOL)calendarIsOn;

@end

@interface BLEReceiveNameRequestModel : BLERequestDataModel

@property (nonatomic, assign) BOOL success;

-(instancetype)initWithResult:(BOOL)success;

@end

@interface BLEDisconnectRequestModel : BLERequestDataModel

@property (nonatomic, assign) BOOL isUnpare;

-(instancetype)initWithType:(BOOL)isUnpare;

@end



