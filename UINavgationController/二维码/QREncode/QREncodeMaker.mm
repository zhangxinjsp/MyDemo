//
//  QREncodeMaker.m
//  UINavgationController
//
//  Created by xsw on 14/12/16.
//  Copyright (c) 2014年 niexin. All rights reserved.
//

#import "QREncodeMaker.h"

#import "QREncoder.h"
#import "DataMatrix.h"

@implementation QREncodeMaker



+(UIImage*)makeQREncodeImageWithString:(NSString*)encodeString imageWidth:(CGFloat)width{
    //first encode the string into a matrix of bools, TRUE for black dot and FALSE for white. Let the encoder decide the error correction level and version
    DataMatrix* qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:encodeString];
    //then render the matrix
    return [QREncoder renderDataMatrix:qrMatrix imageDimension:width];
}



@end
