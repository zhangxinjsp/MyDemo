//
//  BLEEventDataModel.h
//  testUrl
//
//  Created by xsw on 15/4/13.
//  Copyright (c) 2015年 fdcz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "BELMacrosEnumerates.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLERespondDataModel : NSObject

@property (nonatomic, readwrite) Byte commandId;
@property (nonatomic, readwrite) Byte reslut;

-(instancetype)initWithData:(NSData*)data;

@end







