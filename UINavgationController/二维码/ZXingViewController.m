//
//  ZXingViewController.m
//  UINavgationController
//
//  Created by 张鑫 on 14/12/15.
//  Copyright (c) 2014年 zhangxin. All rights reserved.
//

#import "ZXingViewController.h"
#import "ZXingObjC.h"
#import "QRCodeGenerator.h"
#import "QREncodeMaker.h"

@interface ZXingViewController ()<UITextFieldDelegate, ZXCaptureDelegate>{
    UIImageView* imageView;
    UIButton* makeQRCodeBtn;
    
    UIButton* scanQRCodeBtn;
    UIButton* readAlbumsQRCodeBtn;
    UIButton* catchQRCodeBtn;
    UITextField* textField;
    UILabel* label;
    
    
    
    
    ZXCapture *capture;
}

@end

@implementation ZXingViewController

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
    
    capture = [[ZXCapture alloc]init];
    [capture setCamera:1];
    [capture setRotation:90];
    [capture setDelegate: self];
    [capture setLuminance:YES];
    
    capture.luminance.frame = CGRectMake(80, 200, 150, 150);
    capture.luminance.borderColor = [UIColor redColor].CGColor;
    capture.luminance.borderWidth = 3.0f;
    //  [self.capture setBinary:YES];  //显示黑白照片
    [self.view.layer addSublayer:capture.luminance];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    capture.luminance.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
}

-(void)initControls{
    textField = [[UITextField alloc]init];
    textField.backgroundColor = [UIColor lightGrayColor];
    textField.delegate = self;
    textField.placeholder = @"输入生成二维码的内容";
    textField.text = @"zhangxin张鑫";
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
    [scanQRCodeBtn addTarget:self action:@selector(scanQRCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanQRCodeBtn];
    
    readAlbumsQRCodeBtn = [[UIButton alloc]init];
    readAlbumsQRCodeBtn.backgroundColor = [UIColor lightGrayColor];
    [readAlbumsQRCodeBtn setTitle:@"相册二维码" forState:UIControlStateNormal];
    [readAlbumsQRCodeBtn addTarget:self action:@selector(readFromAlbums) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:readAlbumsQRCodeBtn];
    
    catchQRCodeBtn = [[UIButton alloc]init];
    catchQRCodeBtn.backgroundColor = [UIColor lightGrayColor];
    [catchQRCodeBtn setTitle:@"捕获二维码" forState:UIControlStateNormal];
    [catchQRCodeBtn addTarget:self action:@selector(catchQRCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:catchQRCodeBtn];
    
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
    [readAlbumsQRCodeBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [catchQRCodeBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    
    NSDictionary* viewsDict = NSDictionaryOfVariableBindings(textField, makeQRCodeBtn, scanQRCodeBtn, readAlbumsQRCodeBtn, catchQRCodeBtn, imageView, label);
    
    NSDictionary* metricsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:30], @"height", nil];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[textField(==height)]-10-[makeQRCodeBtn(height)]-10-[imageView(150)]-10-[label(>=height)]-10-|" options:NSLayoutFormatAlignAllLeft metrics:metricsDict views:viewsDict]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[textField(>=0)]-10-|" options:NSLayoutFormatAlignAllTop metrics:metricsDict views:viewsDict]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[makeQRCodeBtn(>=0)]-10-[scanQRCodeBtn(makeQRCodeBtn)]-10-[readAlbumsQRCodeBtn(makeQRCodeBtn)]-10-[catchQRCodeBtn(makeQRCodeBtn)]-10-|" options:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom metrics:metricsDict views:viewsDict]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:textField attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
}

#pragma mark －－－－－－－－－－－－－－－生成二维码－－－－－－－－－－

-(void)makeQRCode{
#if 0
    NSError* error = nil;
    
    ZXEncodeHints* hints = [ZXEncodeHints hints];
    hints.errorCorrectionLevel = [ZXErrorCorrectionLevel errorCorrectionLevelL];//容错性设成最高，二维码里添加图片
    hints.encoding =  NSUTF8StringEncoding;// 加上这两句，可以用中文了
    
    ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:textField.text format:kBarcodeFormatQRCode width:800 height:800 hints:hints error:&error];
//    ZXBitMatrix* result = [[ZXMultiFormatWriter writer] encode:textField.text format:kBarcodeFormatQRCode width:500 height:500 error:&error];
    
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        
        UIImage *image1 =   [UIImage imageWithCGImage:image];//二维码原图
        UIImage *subIamge = [UIImage imageNamed:@"icon3.jpg"];
        
        UIImage *image2 = [self addSubImage:image1 sub:subIamge];//二维码里加图标，长宽最好为原图的1/4一下 放在图像中间，这样不妨碍二维码识别

        imageView.image = image2;
        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
    } else {
        NSString* errorMessage = [error localizedDescription];
        label.text = errorMessage;
    }
#elif 0
    imageView.image = [QRCodeGenerator qrImageForString:textField.text imageSize:imageView.frame.size.width];
    
#else
    
    imageView.image = [QREncodeMaker makeQREncodeImageWithString:textField.text imageWidth:imageView.frame.size.width];
#endif
}

-(UIImage *)addSubImage:(UIImage *)img sub:(UIImage *) subImage
{
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    int subWidth = subImage.size.width;
    int subHeight = subImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextDrawImage(context, CGRectMake( (w-subWidth)/2, (h - subHeight)/2, subWidth, subHeight), [subImage CGImage]);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
    //  CGContextDrawImage(contextRef, CGRectMake(100, 50, 200, 80), [smallImg CGImage]);
}

#pragma mark －－－－－－－－－－－－－－－扫描二维码－－－－－－－－－－
//扫描二维码图片
-(void)scanQRCode:(id)sender{
    UIButton * bt = (UIButton *) sender;
    if(capture.running){
        [capture stop];
        [bt setTitle:@"扫一扫" forState:UIControlStateNormal];
    }else{
        [capture start];
        [bt setTitle:@"停止" forState:UIControlStateNormal];
    }
}
//从相册中读取二维码图片
- (void)readFromAlbums {
    CGImageRef imageToDecode = imageView.image.CGImage;
    //CGImself.img.image;  // Given a CGImage in which we are looking for barcodes
    
    ZXLuminanceSource* source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode] ;
    ZXBinaryBitmap* bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError* error = nil;
    
    // There are a number of hints we can give to the reader, including
    // possible formats, allowed lengths, and the string encoding.
    ZXDecodeHints* hints = [ZXDecodeHints hints];
    hints.encoding = NSUTF8StringEncoding;// StringEncoding;
    
    ZXMultiFormatReader* reader = [ZXMultiFormatReader reader];
    ZXResult* result = [reader decode:bitmap hints:hints error:&error];

//    ZXResult* result = [reader decode:bitmap hints:nil error:&error];
    if (result) {
        // The coded result as a string. The raw data can be accessed with
        // result.rawBytes and result.length.
        NSString* contents = result.text;
        
        // The barcode format, such as a QR code or UPC-A
//        ZXBarcodeFormat format = result.barcodeFormat;
        
        label.text = contents;
        
    } else {
        label.text = @"没扫到";
        NSLog(@"没扫到");
    }

}
//捕捉二维码
- (void)catchQRCode {
    
}


# pragma mark ZXcapture 代理方法
- (void)captureResult:(ZXCapture *)_capture result:(ZXResult *)result{
    NSLog(@"%s",__func__);
    if (result) {
        NSString* contents = result.text;
        
        // The barcode format, such as a QR code or UPC-A
//        ZXBarcodeFormat format = result.barcodeFormat;
        LOGINFO(@"%d ,%@",contents.length,contents);
        
        label.text = contents;
        [_capture stop];
        NSLog(@"%@",contents);
    } else {
        NSLog(@"中文出错");
    }
    
    
}

- (void)captureSize:(ZXCapture *)capture width:(NSNumber *)width height:(NSNumber *)height{
    NSLog(@"%s",__func__);
}

- (void)captureCameraIsReady:(ZXCapture *)capture{
    NSLog(@"%s",__func__);
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
