
使用时.m文件需要改成.mm

/*需要倒入文件*/
#import "QREncoder.h"
#import "DataMatrix.h"

/*使用方法*/
//first encode the string into a matrix of bools, TRUE for black dot and FALSE for white. Let the encoder decide the error correction level and version
DataMatrix* qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:textField.text];
//then render the matrix
imageView.image = [QREncoder renderDataMatrix:qrMatrix imageDimension:imageView.frame.size.width];