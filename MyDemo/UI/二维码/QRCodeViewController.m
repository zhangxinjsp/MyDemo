//
//  ZXingViewController.m
//  UINavgationController
//
//  Created by 张鑫 on 14/12/15.
//  Copyright (c) 2014年 zhangxin. All rights reserved.
//

#import "QRCodeViewController.h"


@interface QRCodeViewController ()<UITextFieldDelegate>{
    UIImageView* imageView;
    UIButton* makeQRCodeBtn;
    UIButton* scanQRCodeBtn;

    UITextField* textField;
    UILabel* label;
    
}

@end

@implementation QRCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControls];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)initControls{
    textField = [[UITextField alloc]init];
    textField.backgroundColor = [UIColor lightGrayColor];
    textField.delegate = self;
    textField.placeholder = @"输入生成二维码的内容";
    textField.text = @"zhangxin";
    textField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textField];
    
    makeQRCodeBtn = [[UIButton alloc]init];
    makeQRCodeBtn.backgroundColor = [UIColor lightGrayColor];
    [makeQRCodeBtn setTitle:@"生成二维码" forState:UIControlStateNormal];
    [makeQRCodeBtn addTarget:self action:@selector(makeQRCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:makeQRCodeBtn];
    
    scanQRCodeBtn = [[UIButton alloc]init];
    scanQRCodeBtn.backgroundColor = [UIColor lightGrayColor];
    [scanQRCodeBtn setTitle:@"扫描二维码" forState:UIControlStateNormal];
    [scanQRCodeBtn addTarget:self action:@selector(scanQRCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanQRCodeBtn];
    
    imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:imageView];
    
    label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor lightGrayColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scanQRCodeBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [makeQRCodeBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    
    NSDictionary* viewsDict = NSDictionaryOfVariableBindings(textField, makeQRCodeBtn, scanQRCodeBtn, imageView, label);
    
    NSDictionary* metricsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:30], @"height", nil];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[textField(==height)]-10-[makeQRCodeBtn(height)]-10-[imageView(150)]-10-[label(>=height)]-10-|" options:NSLayoutFormatAlignAllLeft metrics:metricsDict views:viewsDict]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[textField(>=0)]-10-|" options:NSLayoutFormatAlignAllTop metrics:metricsDict views:viewsDict]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[makeQRCodeBtn(>=0)]-10-[scanQRCodeBtn(makeQRCodeBtn)]-10-|" options:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom metrics:metricsDict views:viewsDict]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:textField attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
}
#pragma mark －－－－－－－－－－－－－－－扫描二维码－－－－－－－－－－
- (void)scanQRCode {
    
    //详见《MediaCaptureViewController》二维码扫描部分
    
}

#pragma mark －－－－－－－－－－－－－－－识别二维码－－－－－－－－－－
- (void)detector {
    CIDetector* de = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    CIImage* ciImage = nil;//创建图片
    [de featuresInImage:ciImage];
}

#pragma mark －－－－－－－－－－－－－－－生成二维码－－－－－－－－－－
- (void)makeQRCode {
    imageView.image = [self QRCodeGeneratorWithText:textField.text];
}

-(UIImage*)QRCodeGeneratorWithText:(NSString*)text{
//    系统生成不支持中文
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:[text dataUsingEncoding:NSISOLatin1StringEncoding] forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *outputCIImage = [filter outputImage];
    CGRect rect = [outputCIImage extent];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputCIImage fromRect:rect];
    UIImage * effectImage = [UIImage imageWithCGImage:cgImage];
    
    
    
    return [self enlargeQRCodeImage:effectImage];
}

- (UIImage*)enlarge:(CIImage*)qrImage {
    NSInteger scale = 6;
    CGAffineTransform trans = CGAffineTransformMakeScale(scale, scale);
    CIImage* ciImage = [qrImage imageByApplyingTransform:trans];
    return [UIImage imageWithCIImage:ciImage];
}
/**
 *  二维码放大方法
 *
 *  @param QrCodeImage 二维码图片
 *
 *  @return 放大后的图片
 */
-(UIImage*)enlargeQRCodeImage:(UIImage*)QrCodeImage {
    
    CGFloat scale = 6.0f;
    
    CGSize size = CGSizeMake(QrCodeImage.size.width * scale, QrCodeImage.size.height * scale);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (int x = 0; x < QrCodeImage.size.width; x++) {
        for (int y = 0; y < QrCodeImage.size.width; y++) {
            
            UIColor* pointColor = [self getPixelColorAtLocation:CGPointMake(x, y) inImage:QrCodeImage];
            CGContextSetLineCap(ctx, kCGLineCapSquare);
            CGContextSetLineWidth(ctx, 1.0);
            
            CGContextSetFillColorWithColor(ctx, pointColor.CGColor);
            CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
            //Draw a circle - and paint it with a different outline (white) and fill color (green)
            CGContextAddRect(ctx, CGRectMake(x * scale, y * scale, scale, scale));//圆形
            CGContextClosePath(ctx);
            CGContextDrawPath(ctx, kCGPathFillStroke);
            CGContextStrokePath(ctx);
        }
    }
    UIImage *endImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return endImage;
}

- (UIColor*) getPixelColorAtLocation:(CGPoint)point inImage:(UIImage *)_image {
    UIColor* color = nil;
    CGImageRef inImage = _image.CGImage;
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) {
        return nil; /* error */
    }
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    CGContextDrawImage(cgctx, rect, inImage);
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:
                 (blue/255.0f) alpha:(alpha/255.0f)];
    }
    CGContextRelease(cgctx);
    if (data) {
        free(data);
    }
    return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow = ((int)pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * (int)pixelsHigh);
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL){
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL){
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,pixelsWide,pixelsHigh,8,bitmapBytesPerRow,colorSpace,kCGImageAlphaPremultipliedFirst);
    if (context == NULL){
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    return context;
}

-(BOOL)textFieldShouldReturn:(UITextField *)_textField{
    return [_textField resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
