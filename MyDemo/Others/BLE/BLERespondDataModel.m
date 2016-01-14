//
//  BLEEventDataModel.m
//  testUrl
//
//  Created by xsw on 15/4/13.
//  Copyright (c) 2015年 fdcz. All rights reserved.
//

#import "BLERespondDataModel.h"

@implementation BLERespondDataModel

@synthesize commandId;
@synthesize reslut;

-(instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        Byte *byte = (Byte *)[data bytes];
        @try {
            self.commandId  = byte[0];
            self.reslut = byte[1];
        }
        @catch (NSException *exception) {
            LOGINFO(@"%@", exception);
        }
    }
    return self;
}

@end


