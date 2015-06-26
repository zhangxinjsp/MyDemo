//
//  CoreImageFilterViewController.m
//  UINavgationController
//
//  Created by zhangxin on 15/1/26.
//  Copyright (c) 2015年 zhangxin. All rights reserved.
//
#import <ImageIO/ImageIO.h>
#import "CoreImageFilterViewController.h"
#import <GLKit/GLKit.h>

@interface CoreImageFilterViewController (){
    UIButton* originalImageBtn;
    UIImageView* effectImageView;
    UIImage* image;
    BOOL needResizeRect;
}

@end

@implementation CoreImageFilterViewController

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
    
#if 0
    NSArray* arrarCategory = [NSArray arrayWithObjects: kCICategoryDistortionEffect, kCICategoryGeometryAdjustment, kCICategoryCompositeOperation, kCICategoryHalftoneEffect, kCICategoryColorAdjustment, kCICategoryColorEffect, kCICategoryTransition, kCICategoryTileEffect, kCICategoryGenerator, kCICategoryReduction, kCICategoryGradient, kCICategoryStylize, kCICategorySharpen, kCICategoryBlur, kCICategoryVideo, kCICategoryStillImage, kCICategoryInterlaced, kCICategoryNonSquarePixels, kCICategoryHighDynamicRange , kCICategoryBuiltIn, nil];
    
    for (NSString* category in arrarCategory) {
        NSArray* names = [CIFilter filterNamesInCategory:category];
        LOGINFO(@"-----%@------",category);
        for (NSString* str in names) {
            LOGINFO(@"%@", str);
        }
    }
#endif
    needResizeRect = NO;
    image = [UIImage imageNamed:@"redFlower.png"];
    
    originalImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 300, 200)];
    [originalImageBtn setImage:image forState:UIControlStateNormal];
    originalImageBtn.backgroundColor = [UIColor redColor];
    [originalImageBtn  addTarget:self action:@selector(coreImageFilterUsing:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:originalImageBtn];
    
    effectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(originalImageBtn.frame), CGRectGetMaxY(originalImageBtn.frame)+10, CGRectGetWidth(originalImageBtn.frame), CGRectGetHeight(originalImageBtn.frame))];
    effectImageView.contentMode = UIViewContentModeScaleAspectFit;
    effectImageView.backgroundColor = [UIColor whiteColor];;
    [self.view addSubview:effectImageView];
    
    effectImageView.image = image;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)coreImageFilterUsing:(id)sender{
    LOGINFO(@"start effect");
    
    CIFilter *filter = [self testFilter];
    
//    filter.inputKeys输入key
//    filter.outputKeys;输出key
//    filter.attributes//参数的定义，
    
    CIImage *outputCIImage = [filter outputImage];
    CGRect rect = [outputCIImage extent];
    if (needResizeRect) {
        rect = CGRectMake(0, 0, 200, 200);
    }
    LOGINFO(@"%f     %f", rect.size.width, rect.size.height);
#if 0
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputCIImage fromRect:rect];
    UIImage * effectImage = [UIImage imageWithCGImage:cgImage];
    effectImageView.image = effectImage;
#else
    /*
     使用OpenGL提升新能
     只要有可能，Core Image 将在 GPU 上执行滤镜操作。然而，它确实有回滚到 CPU 上执行的可能。滤镜操作在 CPU 上完成可具有更好的精确度，因为 GPU 经常在浮点计算上以失真换得更快的速度。在创建一个上下文时，你可以通过设置kCIContextUseSoftwareRenderer 关键字的值为 true 来强制 Core Image 在 CPU 上运行。
     
     你可以通过在 Xcode 中设置计划配置（scheme configuration）里的 CI_PRINT_TREE 环境变量为 1 来决定用 CPU 还是 GPU 来渲染。这将导致每次一个滤镜处理图像被渲染的时候 Core Image 都会打印诊断信息。此设置用来检查合成图像滤镜树也很有用。
     */
    
    EAGLContext* glContext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    GLKView* glView = [[GLKView alloc]initWithFrame:CGRectMake(0, 100, 320, 320) context:glContext];
    
    CIContext *context = [CIContext contextWithEAGLContext:glContext];
    
    [glView bindDrawable];
    [context drawImage:filter.outputImage inRect:rect fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    [glView display];
    
    [self.view addSubview:glView];
    
#endif
    
    LOGINFO(@"end effect");
   
    
//    [effectImageView.layer addAnimation:[self transition:filter] forKey:@"transition"];

    
    [self performSelector:@selector(coreImageFilterUsing:) withObject:sender afterDelay:1.0f/30.0f];
}

/*
 
*/
-(CIFilter*)testFilter{
    static CGFloat index = 0.0f;
    
//    CIFilter* filter = [self copyMachineTransitionFilter:index];
    
    CIColor* sepiaColor = [CIColor colorWithRed:0.76 green:0.65 blue:0.54];
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];
    
    CIFilter* monochromeFilter = [CIFilter filterWithName:@"CIColorMonochrome" withInputParameters:@{kCIInputColorKey :sepiaColor, kCIInputIntensityKey : @1.0}];
    
    [monochromeFilter setValue:inputCIImage forKey:kCIInputImageKey];
    
    CIFilter* vignetterFilter = [CIFilter filterWithName:@"CIVignette" withInputParameters:@{kCIInputRadiusKey : @1.75, kCIInputIntensityKey : @1.0}];
    
    [vignetterFilter setValue:monochromeFilter.outputImage forKey:kCIInputImageKey];
    
//    CIImage* outputImage = vignetterFilter.outputImage;
    
    index += 1.0f/30.0f;
    return vignetterFilter;
}

/*
 时光隧道效果
 */
-(CIFilter*)lightTunnelFilter{
    needResizeRect = YES;

    
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CILightTunnel"];
    [filter setValue:inputCIImage forKey:kCIInputImageKey];
    
    [filter setValue:[CIVector vectorWithString:@"[100 100]"] forKey:kCIInputCenterKey];
    [filter setValue:@10 forKey:@"inputRadius"];
    [filter setValue:@20 forKey:@"inputRotation"];
    
    return filter;
}

/*
 圆形屏幕
 */
-(CIFilter*)CircularScreenFilter{
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CICircularScreen"];
    [filter setValue:inputCIImage forKey:kCIInputImageKey];
    
    
    [filter setValue:[CIVector vectorWithX:100 Y:100] forKey:kCIInputCenterKey];
    [filter setValue:@10 forKey:kCIInputWidthKey];
    [filter setValue:@0.1 forKey:kCIInputSharpnessKey];
    return filter;
}

/*
 捏失真
 */
-(CIFilter*)pinchDistortionFilter{
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIPinchDistortion"];
    [filter setValue:inputCIImage forKey:kCIInputImageKey];
    
    [filter setValue:[CIVector vectorWithString:@"[100 100]"] forKey:kCIInputCenterKey];
    [filter setValue:@101 forKey:@"inputRadius"];
    [filter setValue:@0.6 forKey:@"inputScale"];//最大值在1.7
    return filter;
}

/*
 漩涡失真
 */
-(CIFilter*)VortexDistortionFilter{
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIVortexDistortion"];
    [filter setValue:inputCIImage forKey:kCIInputImageKey];
    
    [filter setValue:[CIVector vectorWithString:@"[100 100]"] forKey:kCIInputCenterKey];
    [filter setValue:@100 forKey:kCIInputRadiusKey];
    [filter setValue:@1000 forKey:kCIInputAngleKey];
    
    return filter;
}
/*
 旋转扭曲失真
 */
-(CIFilter*)TwirlDistortionFilter{
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CITwirlDistortion"];
    [filter setValue:inputCIImage forKey:kCIInputImageKey];
    
    [filter setValue:[CIVector vectorWithString:@"[100 100]"] forKey:kCIInputCenterKey];
    [filter setValue:@100 forKey:kCIInputRadiusKey];
    [filter setValue:@9 forKey:kCIInputAngleKey];
    
    return filter;
}

/*
 旋转
 */
-(CIFilter*)AffineTransformFilter{
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIAffineTransform"];
    [filter setValue:inputCIImage forKey:kCIInputImageKey];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformRotate(transform, 0.25*M_PI);
    
    [filter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:kCIInputTransformKey];
    
    return filter;
}

/*
 三角万花筒
 
 返回的图片是无限大的需要人为设置其大小
 */
-(CIFilter*)TriangleKaleidoscopeFilter{
    needResizeRect = YES;
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CITriangleKaleidoscope"];
    [filter setValue:inputCIImage forKey:kCIInputImageKey];
    
    [filter setValue:[CIVector vectorWithX:100 Y:100] forKey:@"inputPoint"];
    [filter setValue:@200 forKey:@"inputSize"];
    [filter setValue:@(-0.36) forKey:@"inputRotation"];
    [filter setValue:@0.85 forKey:@"inputDecay"];
    return filter;
}
#pragma mark -- colorEffect
/*
 对图片进行单色调处理
 */
-(CIFilter*)colorMonochromeFilter:(UIColor*)color{
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [filter setValue:inputCIImage forKey:kCIInputImageKey];
    [filter setValue:@0.8f forKey:kCIInputIntensityKey];
    [filter setValue:[[CIColor alloc]initWithColor:color] forKey:kCIInputColorKey];//(__MAC_10_5, __IPHONE_7_0);
    return filter;
}

/*
棕色色调处理
 */
-(CIFilter*)sepiaToneFilter{
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setValue:inputCIImage forKey:kCIInputImageKey];
    [filter setValue:@0.8f forKey:kCIInputIntensityKey];
    return filter;
}

/*
 色调调整
 */
-(CIFilter*)hueAdjustFilter:(CGFloat)angle{
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];
    CIFilter* hueAdjust = [CIFilter filterWithName:@"CIHueAdjust"];
    [hueAdjust setDefaults];
    [hueAdjust setValue: inputCIImage forKey: kCIInputImageKey];
    [hueAdjust setValue: [NSNumber numberWithFloat:angle] forKey: kCIInputAngleKey];
    return hueAdjust;
}

/*
 愁云
 */
-(CIFilter*)gloomFilter{
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];
    CIFilter *gloom = [CIFilter filterWithName:@"CIGloom"];
    [gloom setDefaults];                                        // 1
    [gloom setValue: inputCIImage forKey: kCIInputImageKey];
    [gloom setValue: @15.0f forKey: kCIInputRadiusKey];         // 2
    [gloom setValue: @0.9f forKey: kCIInputIntensityKey];      // 3
    return gloom;
}

/*
 凹凸变形
 */
-(CIFilter*)bumpDistortionFilter{
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];
    CIFilter *bumpDistortion = [CIFilter filterWithName:@"CIBumpDistortion"];    // 1
    [bumpDistortion setDefaults];                                                // 2
    [bumpDistortion setValue: inputCIImage forKey: kCIInputImageKey];
    [bumpDistortion setValue: [CIVector vectorWithX:80 Y:150] forKey: kCIInputCenterKey];                              // 3
    [bumpDistortion setValue: @40.0f forKey: kCIInputRadiusKey];                // 4
    [bumpDistortion setValue: @2.0f forKey: kCIInputScaleKey];                   // 5
    return bumpDistortion;
}
/*
 两张图片的拼接
 time >0.5时，会渐渐回到原始状态但是图片全是 inputTargetCIImage
 */
-(CIFilter*)copyMachineTransitionFilter:(CGFloat)a{
    
    CGFloat t  = 0.4 * a + 0.1;
    CGFloat modf = fmodf(t, 1.0f);
    NSNumber* time = [NSNumber numberWithFloat:0.5 * (1 - cos(modf * M_PI))];

    CIVector *extent = [CIVector vectorWithCGRect:CGRectMake(0, 0, 200, 200)];
    CIColor  *inputColor = [CIColor colorWithCGColor:[UIColor greenColor].CGColor];
    
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];
    CIImage *inputTargetCIImage = [[CIImage alloc]initWithImage:[UIImage imageNamed:@"boots.png"]];
    CIFilter *transition = [CIFilter filterWithName:@"CICopyMachineTransition"];    // 1
    [transition setDefaults];
    
    if (fmodf(t, 2.0) < 1.0f) {
        [transition setValue: inputCIImage  forKey: kCIInputImageKey];
        [transition setValue: inputTargetCIImage  forKey: kCIInputTargetImageKey];
    } else {
        [transition setValue: inputTargetCIImage  forKey: kCIInputImageKey];
        [transition setValue: inputCIImage  forKey: kCIInputTargetImageKey];
    }
    [transition setValue:inputColor forKeyPath:kCIInputColorKey];
    [transition setValue:extent forKey: kCIInputExtentKey];//最后出来的image的尺寸大小,(设置大于图片原有尺寸是有效，小于则无效)
    [transition setValue:time forKeyPath:kCIInputTimeKey];//和Extent的宽高同时作用于变化位置
    [transition setValue:[NSNumber numberWithFloat:0] forKeyPath:kCIInputAngleKey];
    [transition setValue:@50 forKeyPath:kCIInputWidthKey];
    [transition setValue:@0.5 forKeyPath:@"inputOpacity"];
    
    return transition;
}

/*
 马赛克
 */
-(CIFilter*)pixellateFilter{
    NSNumber* time = [NSNumber numberWithFloat:10];
    CIVector *extent = [CIVector vectorWithX:100 Y:100];
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];
    
    CIFilter *transition = [CIFilter filterWithName:@"CIPixellate"];
    [transition setDefaults];
    [transition setValue:inputCIImage forKeyPath:kCIInputImageKey];
    
    [transition setValue:extent forKey: kCIInputCenterKey];
    [transition setValue:time forKeyPath:kCIInputScaleKey];
    
    return transition;
}

/*
 筛选图片中的人脸
 */
-(void)faceFeature{
    CIImage* myImage = [[CIImage alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"face" ofType:@"png"]]];
    
    CIContext *context = [CIContext contextWithOptions:nil];                    // 1
    NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };      // 2
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:opts];                    // 3
    
    NSDictionary* imageProperties = [myImage properties];
    
    NSNumber* Orientation = [NSNumber numberWithInt:1];
    
    if (imageProperties && [imageProperties valueForKey:(NSString*) kCGImagePropertyOrientation]) {
        Orientation = [imageProperties valueForKey:(NSString*) kCGImagePropertyOrientation];
    }else{
        LOGINFO(@"there is no kCGImagePropertyOrientation properties ");
    }
    opts = @{ CIDetectorImageOrientation : Orientation }; // 4
    
    NSArray *features = [detector featuresInImage:myImage options:opts];        // 5
    
    for (CIFaceFeature *f in features)
    {
        LOGINFO(@"%@", NSStringFromCGRect(f.bounds));
        if (f.hasLeftEyePosition)
            LOGINFO(@"Left eye %g %g", f.leftEyePosition.x, f.leftEyePosition.y);
        
        if (f.hasRightEyePosition)
            LOGINFO(@"Right eye %g %g", f.rightEyePosition.x, f.rightEyePosition.y);
        
        if (f.hasMouthPosition)
            LOGINFO(@"Mouth %g %g", f.mouthPosition.x, f.mouthPosition.y);
    }
}

/*
 颜色十字多项式
 out.r =    in.r * rC[0] +
            in.g * rC[1] +
            in.b * rC[2] +
            in.r * in.r * rC[3] +
            in.g * in.g * rC[4] +
            in.b * in.b * rC[5] +
            in.r * in.g * rC[6] +
            in.g * in.b * rC[7] +
            in.b * in.r * rC[8] +
            rC[9]
 */
-(CIFilter*)colorCrossPolynomialFilter{
    
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorCrossPolynomial"];
    [filter setDefaults];
    [filter setValue:inputCIImage forKey:kCIInputImageKey];
    
    CIVector* vectorR = [CIVector vectorWithString:@"[1 0 0 0 0 0 0 0 0 0]"];
    [filter setValue:vectorR forKey:@"inputRedCoefficients"];
    
    CIVector* vectorG = [CIVector vectorWithString:@"[1 1 0 0 0 0 0 0 0 0]"];
    [filter setValue:vectorG forKey:@"inputGreenCoefficients"];
    
    CIVector* vectorB = [CIVector vectorWithString:@"[0 0 1 0 0 0 0 0 0 0]"];
    [filter setValue:vectorB forKey:@"inputBlueCoefficients"];
    
    return filter;
}

/*
 条形码
 iOS 8.0 
 
 inputMessage
 The data to be encoded as a Code 128 barcode. Must not contain non-ASCII characters. An NSData object whose display name is Message.
 
 inputQuietSpace
 The number of pixels of added white space on each side of the barcode. An NSNumber object whose attribute type is CIAttributeTypeScalar and whose display name is QuietSpace.
 
 Default value: 7.00 Minimum: 0.00 Maximum: 20.00 Slider minimum: 0.00 Slider maximum: 20.00 Identity: 0.00
 */
-(CIFilter*)Code128BarcodeGeneratorFilter{

    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setValue:[@"zhagnxin" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    [filter setValue:@10 forKey:@"inputQuietSpace"];
    
    return filter;
}

/*
 二维码
 ios 7.0
 
 inputMessage
 The data to be encoded as a QR code. An NSData object whose display name is Message.
 inputCorrectionLevel
 A single letter specifying the error correction format. An NSString object whose display name is CorrectionLevel.
 
 Default value: M
 L: 7%
 
 M: 15%
 
 Q: 25%
 
 H: 30%
 
 */
-(CIFilter*)QRCodeGeneratorFilter{

    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:[@"zhagnxin" dataUsingEncoding:NSISOLatin1StringEncoding] forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];

    
    return filter;
}






@end
