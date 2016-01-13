//
//  BLEPeripheralManager.h
//  NEO
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 zhangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLEPeripheralManagerDelegate <NSObject>

-(void)peripheralManagerReceiveWriteData:(NSData*)data;
-(void)peripheralManagerSubscribeChanged:(BOOL)isSubscribe;

@end

@interface BLEPeripheralManager : NSObject

@property (nonatomic, assign) id<BLEPeripheralManagerDelegate> delegate;
@property (nonatomic, readonly) BOOL isAdvertising;

- (void)releasePeripheral;

- (void)stopAdvertising ;

- (void)startAdvertising ;

- (void)sendNotifyWithData:(NSData*)data;

@end
