//
//  CoreGraphicsView.m
//  MyDemo
//
//  Created by 张鑫 on 16/2/2.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "CoreGraphicsView.h"

#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

//https://developer.apple.com/library/ios/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_context/dq_context.html




@interface CoreGraphicsView () <CAAnimationDelegate> {
    UIImageView* circleView;
}

@end

@implementation CoreGraphicsView

@synthesize type;


+ (NSArray *)titles {
    return @[@"线图", @"文字", @"图片", @"渐变色", @"动画", @"patterns", @"倒影"];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    switch (type) {
        case lineAndGraph: {
            [self lineAndGraph];
            break;
        }
        case word: {
            [self word];
            break;
        }
        case gradient: {
            [self gradient];
            break;
        }
        case animation: {
            [self animation];
            break;
        }
        case image: {
            [self image];
            break;
        }
        case patterns: {
            [self patterns];
            break;
        }
            break;
        case reflected:{
            UIImage* image = [self reflectedImageRepresentationWithHeight:50];
//            self.backgroundColor = [UIColor colorWithPatternImage:image];
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:self.bounds];
            imageView.image = image;
            imageView.contentMode = UIViewContentModeCenter;
            imageView.backgroundColor = [UIColor redColor];
            [self addSubview:imageView];
            break;
        }
        default:{
            
        }
            break;
    }
    
    
    
}

- (void)lineAndGraph {
    // Drawing code.画线条
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条两端的样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置连接点的样式
    CGContextSetLineJoin(context, kCGLineJoinMiter);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1.0);
    //阴影
    CGContextSetShadowWithColor(context, CGSizeMake(3, 3), 2, [UIColor redColor].CGColor);
    //反图像失真，锯齿现象
    CGContextSetAllowsAntialiasing(context, TRUE);
    //设置边线色[[UIColor blueColor]setStroke];
    CGContextSetRGBStrokeColor(context, 1.0, 161.0/256.0, 112.0/256.0, 256.0/256.0);
    
    CGContextSetRGBFillColor(context, 1.0f, 0.5f, 0.5f, 1.0);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    //设置一个直线
    CGContextMoveToPoint(context, 10, 10);
    CGContextAddLineToPoint(context, 100, 10);
    
    //点与点之间用圆弧
    CGContextMoveToPoint(context, 10, 30);
    CGContextAddArcToPoint(context, 100, 30, 100, 20, 10);

    //曲线
    CGContextMoveToPoint(context, 10, 60);
    CGContextAddCurveToPoint(context, 40, 40, 70, 80, 100, 60);
    
    CGContextMoveToPoint(context, 10, 80);
    CGContextAddQuadCurveToPoint(context, 50, 60, 100, 80);
    
    CGContextMoveToPoint(context, 10, 100);
    //0表示顺时针，1表示逆时针;弧度时安顺时针算的
    CGContextAddArc(context, 50, 100, 20, M_PI * 0, M_PI * 0.9, 0);
    
    //把线条显示出来
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 10, 130);
    CGContextAddEllipseInRect(context, CGRectMake(10, 130, 90, 40));
    
    //当参数为kCGPathStroke 与CGContextStrokePath方法的效果是一样的，
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)word {
    
    NSString* text = @"张鑫！！1234:：： aasdfasd";
    UIFont * font = [UIFont systemFontOfSize:17];
    
    
    [text drawAtPoint:CGPointMake(20, 100) withAttributes:@{NSFontAttributeName : font,
                                                            NSForegroundColorAttributeName : [UIColor redColor]}];
    
    
//    添加外边线
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    CGContextSetTextDrawingMode(context1, kCGTextFillStroke);
    CGContextSetLineWidth(context1, 1.0f);
    CGContextSetLineJoin(context1, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(context1, [UIColor whiteColor].CGColor);
    // Set white color for alpha mask.
    CGContextSetFillColorWithColor(context1, [UIColor redColor].CGColor);//无效设置
//    颜色设置会覆盖上面的设置
    [text drawInRect:CGRectMake(20, 130, 300, 80) withAttributes:@{NSFontAttributeName : font,
                                           /*NSForegroundColorAttributeName: [UIColor clearColor]*/}];
    
    

    
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName : font}];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    
    int strokeSize = 1;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Prepare mask.
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetLineWidth(context, 0.50f);
    [text drawInRect:rect withAttributes:@{NSFontAttributeName : font}];
    // Save alpha mask.
    CGImageRef alphaMask = CGBitmapContextCreateImage(context);    
    CGContextClearRect(context, rect);
    CGContextRestoreGState(context);
    
    //渐变色处理
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, 0.0f, rect.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);

    CGContextClipToMask(context, rect, alphaMask);
    NSMutableArray *gradientColors = [NSMutableArray arrayWithObjects:(__bridge id)[UIColor orangeColor].CGColor,(__bridge id)[UIColor greenColor].CGColor, nil];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, NULL);
    CGPoint startPoint = CGPointMake(0,0);
    CGPoint endPoint = CGPointMake(0,size.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    CGImageRelease(alphaMask);
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextClearRect(context, rect);
    
    CGContextRestoreGState(context);
    
    
    
//    Draw stroke.
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextStroke);
    CGContextSetLineWidth(context, strokeSize * 2.0f);

    [text drawInRect:rect withAttributes:@{NSFontAttributeName : font,
                                           NSForegroundColorAttributeName : [UIColor blueColor]}];
    
    CGContextTranslateCTM(context, 0.0f, rect.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextDrawImage(context, rect, image); // Clean up, because ARC doesn't handle CG.
    CGImageRelease(image);
    CGContextRestoreGState(context);
    
    UIImage *endimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [endimage drawInRect:rect];
    

}


- (void)image {
    UIImage* image0 = [UIImage imageNamed:@"上睫毛阴影.png"];
    
    CGFloat scale = 0.5;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 180, -50);
    CGContextRotateCTM(ctx, M_PI_4);
    CGContextScaleCTM(ctx, scale, scale);

    UIImage* image2 = [self addBackgroundColor:image0 color:[UIColor greenColor]];
    CGRect area2 = CGRectMake(0 , 400, image0.size.width, image0.size.height);
    CGContextDrawImage(ctx, area2, image2.CGImage);
    
    //反的图
    CGContextDrawImage(ctx, CGRectMake(0, 200, image0.size.width, image0.size.height), image0.CGImage);
    
    //正的图
    UIGraphicsPushContext(ctx);
    [image0 drawInRect:CGRectMake(0 , 0, image0.size.width, image0.size.height)];
    UIGraphicsPopContext();
    
    /**
     通过mask的方式裁剪图片,可以是自己画的图形也可以是其他图片
     CGImageRef circle = CGBitmapContextCreateImage(ctx);
     CGContextClipToMask(ctx, rect, circle);
     CGContextDrawImage(ctx, rect, image.CGImage);
     UIImage *circle1 = UIGraphicsGetImageFromCurrentImageContext();
     */

}

-(UIImage*)addBackgroundColor :(UIImage*)image color:(UIColor*)color{
    //直接用UIGraphicsGetCurrentContext view的背景色灰影响效果，除非用clearcolor
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    [image drawInRect: area];
    
    // overlay a red rectangle
    CGContextSetBlendMode( ctx, kCGBlendModeMultiply) ;
    //    CGContextSetBlendMode( ctx, kCGBlendModeColor) ;
    CIColor * cicolor = [CIColor colorWithCGColor:color.CGColor];
    CGContextSetRGBFillColor ( ctx,  cicolor.red, cicolor.green, cicolor.blue,  cicolor.alpha);
    CGContextFillRect ( ctx, area );
    
    // redraw image
    [image drawInRect: area blendMode: kCGBlendModeDestinationIn alpha: cicolor.alpha];
    
    UIImage * _image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return _image;
}

- (void)gradient {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat componets1 [] = {  0.0f/255.0f,   0.0f/255.0f, 255.0f/255.0f, 1.0,
                             250.0f/255.0f,   0.0f/255.0f,   0.0f/255.0f, 1.0,
                               0.0f/255.0f, 255.0f/255.0f,   0.0f/255.0f, 1.0};//前6位起始色和结束色，后两位是开始和结束的透明度
    CGFloat componets2 [] = {0.0f, 0.5f, 1.0f};//渐变位置（范围）
    int x = 3;//变化的层次数，与上面的配合
    CGColorSpaceRef colorspace1 = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient1 = CGGradientCreateWithColorComponents(colorspace1, componets1,componets2 , x);
    CGContextSaveGState(context);//
    
    //设置作用范围
//    CGContextClipToRect(context, CGRectMake(0,0,300,300));//在矩形中
//    CGContextAddEllipseInRect(context, rect);//在圆形中;
    
    CGPoint points [] = {CGPointMake(10, 10), CGPointMake(150, 50), CGPointMake(300, 10), CGPointMake(300, 200), CGPointMake(150, 160), CGPointMake(10, 200)};
    CGContextAddLines(context, points, 6);
    CGContextClosePath(context);//形成封闭空间
    CGContextClip(context);//超出部分裁剪掉
    //形成封闭的空间设置此封闭的空间为作用空间！
    
    CGContextDrawLinearGradient(context, gradient1, CGPointMake(0,0), CGPointMake(0,200),kCGGradientDrawsBeforeStartLocation);
    CGColorSpaceRelease(colorspace1);
    CGContextRestoreGState(context);
    
    [[UIColor blueColor]setFill];//设置填充色
    [[UIColor blueColor]setStroke];//设置填充色
    
    CGContextDrawRadialGradient(context, gradient1, CGPointMake(100, 300), 10, CGPointMake(160, 300), 50, kCGGradientDrawsBeforeStartLocation);
}

- (void)animation {
    //Prepare the animation - we use keyframe animation for animations of this complexity
    //需要quartzcore。framework
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationCubicPaced;
    pathAnimation.fillMode = kCAFillModeRemoved;
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.duration = 4;
//    pathAnimation.repeatDuration = 6.0;//重复时间不可以与重复次数连用，有了重复时间重复次数就等于repeatDuration／duration
    pathAnimation.repeatCount = 1;
    pathAnimation.delegate = self;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    
    CGPathMoveToPoint(curvedPath, nil, 20, 20);
    CGPathAddLineToPoint(curvedPath, nil, 20, 200);
    CGPathAddLineToPoint(curvedPath, nil, 200, 200);
    CGPathAddLineToPoint(curvedPath, nil, 200, 20);
    CGPathAddLineToPoint(curvedPath, nil, 20, 20);
    //Now we have the path, we tell the animation we want to use this path - then we release the path
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    //We will now draw a circle at the start of the path which we will animate to follow the path
    //We use the same technique as before to draw to a bitmap context and then eventually create
    //a UIImageView which we add to our view
    
    
    UIGraphicsBeginImageContext(CGSizeMake(20,20));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //    //Set context variables
    CGContextSetLineWidth(ctx, 1);
    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    //    //Draw a circle - and paint it with a different outline (white) and fill color (green)
    CGContextAddEllipseInRect(ctx, CGRectMake(1, 1, 18, 18));//圆形
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage *circle = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (circleView == nil) {
        circleView = [[UIImageView alloc] initWithImage:circle];
        circleView.frame = CGRectMake(10, 10, 20, 20);
        [self addSubview:circleView];
    }
    //Add the animation to the circleView - once you add the animation to the layer, the animation starts
    [circleView.layer addAnimation:pathAnimation forKey:@"moveTheSquare"];
}


-(void)animationDidStart:(CAAnimation *)anim{
    LOGINFO(@"%@",@"path start!!");
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        //        [circleView removeFromSuperview];
    }
    [circleView removeFromSuperview];
    LOGINFO(@"%@",@"path finish!");
}













- (void)drawingToBitmapGraphicsContext {
    
    CGRect myBoundingBox = self.bounds;//CGRectMake (0, 0, myWidth, myHeight);// 2
    CGContextRef myBitmapContext = MyCreateBitmapContext (self.bounds.size.width, self.bounds.size.height);// 3
    // ********** Your drawing code here ********** // 4
    CGContextSetRGBFillColor (myBitmapContext, 1, 0, 0, 1);
    CGContextFillRect (myBitmapContext, CGRectMake (0, 0, 200, 100 ));
    CGContextSetRGBFillColor (myBitmapContext, 0, 0, 1, .5);
    CGContextFillRect (myBitmapContext, CGRectMake (0, 0, 100, 200 ));
    
    CGImageRef myImage = CGBitmapContextCreateImage (myBitmapContext);// 5
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGContextDrawImage(myContext, myBoundingBox, myImage);// 6
    char *bitmapData = CGBitmapContextGetData(myBitmapContext); // 7
    CGContextRelease (myBitmapContext);// 8
    if (bitmapData) free(bitmapData); // 9
    CGImageRelease(myImage);
}

CGContextRef MyCreateBitmapContext (int pixelsWide, int pixelsHigh)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    bitmapBytesPerRow   = (pixelsWide * 4);// 1
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);// 2
    bitmapData = calloc( pixelsHigh, bitmapBytesPerRow );// 3
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,// 4
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    if (context== NULL)
    {
        free (bitmapData);// 5
        fprintf (stderr, "Context not created!");
        return NULL;
    }
    CGColorSpaceRelease( colorSpace );// 6
    
    return context;// 7
}


//倒影图片
- (UIImage *)reflectedImageRepresentationWithHeight:(NSUInteger)height {
    
    CGContextRef mainViewContentContext;
    CGColorSpaceRef colorSpace;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a bitmap graphics context the size of the image
    mainViewContentContext = CGBitmapContextCreate (NULL, self.bounds.size.width,height, 8,0, colorSpace, kCGImageAlphaPremultipliedLast);
    
    // free the rgb colorspace
    CGColorSpaceRelease(colorSpace);
    
    if (mainViewContentContext == NULL)
        return NULL;
    
    // offset the context. This is necessary because, by default, the layer created by a view for
    // caching its content is flipped. But when you actually access the layer content and have
    // it rendered it is inverted. Since we're only creating a context the size of our
    // reflection view (a fraction of the size of the main view) we have to translate the context the
    // delta in size, render it, and then translate back
    
    CGFloat translateVertical = self.bounds.size.height-height;
    CGContextTranslateCTM(mainViewContentContext, 0, -translateVertical);
    
    // render the layer into the bitmap context
    [self.layer renderInContext:mainViewContentContext];
    
    // translate the context back
    CGContextTranslateCTM(mainViewContentContext, 0, translateVertical);
    
    // Create CGImageRef of the main view bitmap content, and then release that bitmap context
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    // create a 2 bit CGImage containing a gradient that will be used for masking the
    // main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
    // function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
    CGImageRef gradientMaskImage = AEViewCreateGradientImage(1, height);
    
    // Create an image by masking the bitmap of the mainView content with the gradient view
    // then release the pre-masked content bitmap and the gradient bitmap
    CGImageRef reflectionImage = CGImageCreateWithMask(mainViewContentBitmapContext, gradientMaskImage);
    CGImageRelease(mainViewContentBitmapContext);
    CGImageRelease(gradientMaskImage);
    
    // convert the finished reflection image to a UIImage
    UIImage *theImage = [UIImage imageWithCGImage:reflectionImage];
    
    CGImageRelease(reflectionImage);
    
    return theImage;
}
//倒影的渐变效果
CGImageRef AEViewCreateGradientImage (int pixelsWide, NSInteger pixelsHigh) {
    
    CGImageRef theCGImage = NULL;
    CGContextRef gradientBitmapContext = NULL;
    CGColorSpaceRef colorSpace;
    CGGradientRef grayScaleGradient;
    CGPoint gradientStartPoint, gradientEndPoint;
    
    // Our gradient is always black-white and the mask
    // must be in the gray colorspace
    colorSpace = CGColorSpaceCreateDeviceGray();
    
    // create the bitmap context
    gradientBitmapContext = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh,
                                                   8, 0, colorSpace, kCGImageAlphaNone);
    
    if (gradientBitmapContext != NULL) {
        // define the start and end grayscale values (with the alpha, even though
        // our bitmap context doesn't support alpha the gradient requires it)
        CGFloat colors[] = {0.0, 1.0,1.0, 1.0,};
        
        // create the CGGradient and then release the gray color space
        grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
        
        // create the start and end points for the gradient vector (straight down)
        gradientStartPoint = CGPointZero;
        gradientEndPoint = CGPointMake(0,pixelsHigh);
        
        // draw the gradient into the gray bitmap context
        CGContextDrawLinearGradient (gradientBitmapContext, grayScaleGradient, gradientStartPoint, gradientEndPoint, kCGGradientDrawsAfterEndLocation);
        
        // clean up the gradient
        CGGradientRelease(grayScaleGradient);
        
        // convert the context into a CGImageRef and release the context
        theCGImage = CGBitmapContextCreateImage(gradientBitmapContext);
        CGContextRelease(gradientBitmapContext);
    }
    
    // clean up the colorspace
    CGColorSpaceRelease(colorSpace);
    
    // return the imageref containing the gradient
    return theCGImage;
}




#define H_PATTERN_SIZE 16
#define V_PATTERN_SIZE 18
/**
 *
 1. Declares storage for a CGPattern object that is created later.
 2. Declares storage for a pattern color space that is created later.
 3. Declares a variable for alpha and sets it to 1, which specifies the opacity of the pattern as completely opaque.
 4. Declares variable to hold the height and width of the window. In this example, the pattern is painted over the area of a window.
 5. Declares and fills a callbacks structure, passing 0 as the version and a pointer to a drawing callback function. This example does not provide a release info callback, so that field is set to NULL.
 6. Creates a pattern color space object, setting the pattern’s base color space to NULL. When you paint a colored pattern, the pattern supplies its own color in the drawing callback, which is why you set the color space to NULL.
 7. Sets the fill color space to the pattern color space object you just created.
 8. Releases the pattern color space object.
 9. Passes NULL because the pattern does not need any additional information passed to the drawing callback.
 10.Passes a CGRect object that specifies the bounds of the pattern cell.
 11.Passes a CGAffineTransform matrix that specifies how to translate the pattern space to the default user space of the context in which the pattern is used. This example passes the identity matrix.
 12.Passes the horizontal pattern size as the horizontal displacement between the start of each cell. In this example, one cell is painted adjacent to the next.
 13.Passes the vertical pattern size as the vertical displacement between start of each cell.
 14.Passes the constant kCGPatternTilingConstantSpacing to specify how Quartz should render the pattern. For more information, see Tiling.
 15.Passes true for the isColored parameter, to specify that the pattern is a colored pattern.
 16.Passes a pointer to the callbacks structure that contains version information, and a pointer to your drawing callback function.
 17.Sets the fill pattern, passing the context, the CGPattern object you just created, and a pointer to the alpha value that specifies an opacity for Quartz to apply to the pattern.
 18.Releases the CGPattern object.
 19.Fills a rectangle that is the size of the window passed to the MyColoredPatternPainting routine. Quartz fills the rectangle using the pattern you just set up.
 */
- (void)patterns {

    CGContextRef myContext = UIGraphicsGetCurrentContext();
    
    CGPatternRef    pattern;// 1
    CGColorSpaceRef patternSpace;// 2
    CGFloat         alpha = 1;// 3
//    CGFloat         width, height;// 4
    static const    CGPatternCallbacks callbacks = {0, // 5
                                                    &MyDrawColoredPattern,
                                                    NULL};
    
    CGContextSaveGState (myContext);
    patternSpace = CGColorSpaceCreatePattern (NULL);// 6
    CGContextSetFillColorSpace (myContext, patternSpace);// 7
    CGColorSpaceRelease (patternSpace);// 8
    
    pattern = CGPatternCreate (NULL, // 9
                               CGRectMake (0, 0, 10, 10),// 10
                               CGAffineTransformMake (1, 0, 0, 1, 0, 0),// 11
                               H_PATTERN_SIZE, // 12
                               V_PATTERN_SIZE, // 13
                               kCGPatternTilingConstantSpacing,// 14
                               true, // 15
                               &callbacks);// 16
    
    CGContextSetFillPattern (myContext, pattern, &alpha);// 17
    CGPatternRelease (pattern);// 18
    CGContextFillRect (myContext, self.bounds);// 19
    CGContextRestoreGState (myContext);
}

void MyDrawColoredPattern (void *info, CGContextRef myContext)
{
    CGFloat subunit = 5; // the pattern cell itself is 16 by 18
    
    CGRect  myRect1 = {{0,0}, {subunit, subunit}},
    myRect2 = {{subunit, subunit}, {subunit, subunit}},
    myRect3 = {{0,subunit}, {subunit, subunit}},
    myRect4 = {{subunit,0}, {subunit, subunit}};
    
    CGContextSetRGBFillColor (myContext, 0, 0, 1, 0.5);
    CGContextFillRect (myContext, myRect1);
    CGContextSetRGBFillColor (myContext, 1, 0, 0, 0.5);
    CGContextFillRect (myContext, myRect2);
    CGContextSetRGBFillColor (myContext, 0, 1, 0, 0.5);
    CGContextFillRect (myContext, myRect3);
    CGContextSetRGBFillColor (myContext, .5, 0, .5, 0.5);
    CGContextFillRect (myContext, myRect4);
}


#pragma mark -=====自定义截屏位置大小的逻辑代码=====-
static int ScreenshotIndex=0; //这里的逻辑直接采用上面博主的逻辑了
-(void)ScreenShot{
    //这里因为我需要全屏接图所以直接改了，宏定义iPadWithd为1024，iPadHeight为768，
    //    UIGraphicsBeginImageContextWithOptions(CGSizeMake(640, 960), YES, 0);     //设置截屏大小
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, YES, 0);     //设置截屏大小
    [[self layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    //    CGRect rect = CGRectMake(166, 211, 426, 320);//这里可以设置想要截图的区域
    CGRect rect = [UIScreen mainScreen].bounds;//这里可以设置想要截图的区域
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);//保存图片到照片库
    NSData *imageViewData = UIImagePNGRepresentation(sendImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pictureName= [NSString stringWithFormat:@"screenShow_%d.png",ScreenshotIndex];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:pictureName];
    NSLog(@"截屏路径打印: %@", savedImagePath);
    //这里我将路径设置为一个全局String，这里做的不好，我自己是为了用而已，希望大家别这么写
    [self SetPickPath:savedImagePath];
    
    [imageViewData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录
    CGImageRelease(imageRefRect);
    ScreenshotIndex++;
}
//设置路径
static NSString* _ScreenshotsPickPath = @"";
- (void)SetPickPath:(NSString *)PickImage {
    _ScreenshotsPickPath = PickImage;
}
//获取路径<这里我就直接用于邮件推送的代码中去了，能达到效果，但肯定有更好的写法>
- (NSString *)GetPickPath {
    return _ScreenshotsPickPath;
}





































/*
 https://developer.apple.com/library/ios/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_pdf/dq_pdf.html#//apple_ref/doc/uid/TP30001066-CH214-TPXREF101
 
 PDF 的读取和使用
 
 */
CGContextRef MyPDFContextCreate (const CGRect *inMediaBox, CFStringRef path) {
    CGContextRef myOutContext = NULL;
    CFURLRef url;
    
    url = CFURLCreateWithFileSystemPath (NULL, // 1
                                         path,
                                         kCFURLPOSIXPathStyle,
                                         false);
    CGDataConsumerRef   dataConsumer;
    
    if (url != NULL) {
        BOOL type = NO;//PDF context 的两种创建方式
        if (type) {
            myOutContext = CGPDFContextCreateWithURL (url, inMediaBox, NULL);
        } else {
            dataConsumer = CGDataConsumerCreateWithURL (url);// 2
            if (dataConsumer != NULL) {
                myOutContext = CGPDFContextCreate (dataConsumer, inMediaBox, NULL);
                CGDataConsumerRelease (dataConsumer);// 4
            }
        }
        
        CFRelease(url);// 3
    }
    return myOutContext;// 6
}



@end
