//
//  CoreImageFilterViewController.m
//  UINavgationController
//
//  Created by xsw on 15/1/26.
//  Copyright (c) 2015年 niexin. All rights reserved.
//

#import "CoreImageFilterViewController.h"

@interface CoreImageFilterViewController (){
    UIButton* originalImageBtn;
    UIImageView* effectImageView;
    UIImage* image;
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
    
#if 1
    NSArray* arrarCategory = [NSArray arrayWithObjects: kCICategoryDistortionEffect, kCICategoryGeometryAdjustment, kCICategoryCompositeOperation, kCICategoryHalftoneEffect, kCICategoryColorAdjustment, kCICategoryColorEffect, kCICategoryTransition, kCICategoryTileEffect, kCICategoryGenerator, kCICategoryReduction, kCICategoryGradient, kCICategoryStylize, kCICategorySharpen, kCICategoryBlur, kCICategoryVideo, kCICategoryStillImage, kCICategoryInterlaced, kCICategoryNonSquarePixels, kCICategoryHighDynamicRange , kCICategoryBuiltIn, nil];
    
    for (NSString* category in arrarCategory) {
        NSArray* names = [CIFilter filterNamesInCategory:category];
        LOGINFO(@"-----%@------",category);
        for (NSString* str in names) {
            LOGINFO(@"%@", str);
        }
    }
#endif
    image = [UIImage imageNamed:@"redFlower.png"];
    
    originalImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 300, 200)];
    [originalImageBtn setImage:image forState:UIControlStateNormal];
    originalImageBtn.backgroundColor = [UIColor redColor];
    [originalImageBtn  addTarget:self action:@selector(coreImageFilterUsing:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:originalImageBtn];
    
    effectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(originalImageBtn.frame), CGRectGetMaxY(originalImageBtn.frame)+10, CGRectGetWidth(originalImageBtn.frame), CGRectGetHeight(originalImageBtn.frame))];
    effectImageView.contentMode = UIViewContentModeScaleAspectFit;
    effectImageView.backgroundColor = [UIColor redColor];;
    [self.view addSubview:effectImageView];
    
    effectImageView.image = image;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//CIFilter Name define
#define CIGaussianBlur          @"CIGaussianBlur" //高斯模糊
-(void)coreImageFilterUsing:(id)sender{
    LOGINFO(@"start effect");
    CIFilter *filter = nil;
//    CIFilter *filter = [self colorMonochromeFilter:[UIColor greenColor]];
//    CIFilter *filter = [self sepiaToneFilter];
//    CIFilter *filter = [self colorCrossPolynomialFilter];
//    CIFilter *filter = [self hueAdjustFilter:3.6];
//    filter = [self bumpDistortionFilter];
    filter = [self testFilter];
    
    CIImage *outputCIImage = [filter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputCIImage fromRect:[outputCIImage extent]];
    
    UIImage * effectImage = [UIImage imageWithCGImage:cgImage];
    
    LOGINFO(@"end effect");
    
//    [effectImageView.layer addAnimation:[self transition:filter] forKey:@"transition"];

    LOGINFO(@"%f,%f", effectImage.size.width , effectImage.size.height);
    effectImageView.image = effectImage;
    
}

-(CATransition*)transition:(CIFilter*)filter{
    // Create the transition object
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
//    transition.startProgress = 0;
//    transition.endProgress = 1.0;
    transition.filter = filter;
    transition.fillMode = kCAFillModeForwards;
    transition.duration = 3.0;
    
    return transition;
}
/*
*/
-(CIFilter*)testFilter{
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
 
 */
-(CIFilter*)colorCrossPolynomialFilter{
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];

    CIFilter *filter = [CIFilter filterWithName:@"CIColorCrossPolynomial"];
    [filter setValue:inputCIImage forKey:kCIInputImageKey];
    
    CIVector* vector = [CIVector vectorWithX:12];
    
    
    [filter setValue:vector forKey:@"inputRedCoefficients"];
    
    [filter setValue:inputCIImage forKey:@"inputGreenCoefficients"];
    [filter setValue:inputCIImage forKey:@"inputBlueCoefficients"];

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

-(CIFilter*)copyMachineTransitionFilter{
    NSNumber* time = [NSNumber numberWithFloat:0.5];
    CIVector *extent = [CIVector vectorWithCGRect:CGRectMake(0, 0, 200, 200)];
    CIColor  *inputColor = [CIColor colorWithCGColor:[UIColor greenColor].CGColor];
    
    
    CIImage *inputCIImage = [[CIImage alloc]initWithImage:image];
    CIImage *inputTargetCIImage = [[CIImage alloc]initWithImage:[UIImage imageNamed:@"boots.png"]];
    
    CIFilter *transition = [CIFilter filterWithName:@"CICopyMachineTransition"];    // 1
    [transition setDefaults];
    [transition setValue:inputCIImage forKeyPath:kCIInputImageKey];
    [transition setValue:inputTargetCIImage forKeyPath:kCIInputTargetImageKey];
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

@end
