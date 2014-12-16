//
//  QREncodeMaker.h
//  UINavgationController
//
//  Created by xsw on 14/12/16.
//  Copyright (c) 2014年 niexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QREncodeMaker : NSObject

+(UIImage*)makeQREncodeImageWithString:(NSString*)encodeString imageWidth:(CGFloat)width;

@end
