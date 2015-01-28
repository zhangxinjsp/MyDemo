//
//  ThirdViewController.m
//  UINavgationController
//
//  Created by niexin on 12-11-7.
//  Copyright (c) 2012年 niexin. All rights reserved.
//

#import "TransformViewController.h"

@interface TransformViewController (){
    CALayer* layer;
    UILabel* label;
    UILabel* label1;
}

@end

@implementation TransformViewController

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
    self.title = @"transform";
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 120, 40)];
    label.textColor = [UIColor redColor];
    label.backgroundColor = [UIColor blueColor];
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
    
    [self.view addSubview:label];
    
    
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 120, 40)];
    label1.textColor = [UIColor redColor];
    label1.backgroundColor = [UIColor redColor];
    label1.layer.cornerRadius = 10;
    label1.layer.masksToBounds = YES;
    label1.hidden = YES;
    [self.view addSubview:label1];
    
    
    layer = [CALayer layer];
    layer.frame = CGRectMake(100, 100, 120, 40);
    layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    
    
    
    NSArray* transArray = [[NSArray alloc]initWithObjects:@"AffineTransform", @"Transform3D", @"Transition", @"TransitionFilter", @"BasicAnimation", @"transaction", @"viewAnimation", @"test", nil];
    NSInteger itemsInRow = 3;
    NSDictionary* metrics = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithFloat:90], @"width",
                             [NSNumber numberWithFloat:20], @"height",
                             [NSNumber numberWithFloat:240], @"topMargins",
                             [NSNumber numberWithFloat:10], @"gapH",
                             [NSNumber numberWithFloat:10], @"gapV",
                             nil];
    
    NSMutableDictionary* viewsDict = [[NSMutableDictionary alloc]init];
    
    for (NSString* str in transArray) {
        UIButton* btn = [[UIButton alloc]init];
        btn.tag = [transArray indexOfObject:str];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setBackgroundColor:[UIColor blueColor]];
        [btn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [viewsDict setObject:btn forKey:[NSString stringWithFormat:@"btn_%@",str]];
    }
    
    NSMutableArray* constraints = [[NSMutableArray alloc]init];
    NSInteger rowCount = (transArray.count + itemsInRow - 1)/itemsInRow;
    
    NSString* formateStrV = @"V:|-topMargins-";
    for (NSInteger i = 0; i < rowCount; i++) {
        NSString* btnName = [NSString stringWithFormat:@"btn_%@", [transArray objectAtIndex:i * itemsInRow ]];
        formateStrV = [formateStrV stringByAppendingFormat:@"[%@(height)]-gapV-", btnName];
        
        NSString* formateStrH = @"H:|-gapH-";
        for (NSInteger j = 0; j < itemsInRow; j++) {
            if (i * itemsInRow + j >= transArray.count) {
                break;
            }
            btnName = [NSString stringWithFormat:@"btn_%@", [transArray objectAtIndex:i * itemsInRow + j]];
            formateStrH = [formateStrH stringByAppendingFormat:@"[%@(width)]-gapH-", btnName];
        }
        formateStrH = [formateStrH stringByAppendingString:@"|"];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:formateStrH options:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom metrics:metrics views:viewsDict]];
    }
    formateStrV = [formateStrV stringByAppendingString:@"|"];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:formateStrV options:NSLayoutFormatAlignAllLeft|NSLayoutFormatAlignAllRight metrics:metrics views:viewsDict]];
    
    
    [self.view addConstraints:constraints];
    // Do any additional setup after loading the view from its nib.
}

-(void)buttonAction:(id)sender{
    NSInteger tag = ((UIButton*)sender).tag;
    switch (tag) {
        case 0:{
            label.transform = [self setTransform];
        }
            break;
        
        case 1:{
            label.layer.transform = [self setCATransform3D];
        }
            break;
        case 2:{
            [label.layer addAnimation:[self transitionWithSystemType] forKey:@"Transition"];
        }
            break;
        case 3:{
            [label.layer addAnimation:[self transitionWithFilter] forKey:@"TransitionFilter"];
            label.hidden = !label.hidden;
        }
            break;
        case 4:{
            [label.layer addAnimation:[self basicAnimation] forKey:@"BasicAnimation"];
        }
            break;
        case 5:{
            [self transaction];
        }
            break;
        case 6:{
            [self viewAnimation];
        }
            break;
        default:
            [self test];
            break;
    }
}

-(void)test{
    
    // Create the Core Image filter, setting several key parameters.
    CIFilter* aFilter = [CIFilter filterWithName:@"CIBarsSwipeTransition"];
    [aFilter setValue:[NSNumber numberWithFloat:3.14] forKey:@"inputAngle"];
    [aFilter setValue:[NSNumber numberWithFloat:30.0] forKey:@"inputWidth"];
    [aFilter setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputBarOffset"];
    
    // Create the transition object
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.startProgress = 0;
    transition.endProgress = 1.0;
//    transition.filter = [self copyMachineTransitionFilter:0.4];
    transition.duration = 1.0;

    [layer addAnimation:transition forKey:@"transition"];
//    [label setHidden:!label.hidden];
    
    
//    [label1 setHidden:!label1.hidden];
//    [label.layer addAnimation:transition forKey:@"transition"];
//    [label1.layer addAnimation:transition forKey:@"transition"];
//    [label setHidden:!label.hidden];
}


#pragma mark -- 静态效果
//平面的效果
-(CGAffineTransform)sizeTransform{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 1.5, 1.5);//2d在xy方向上进行缩放！
    return transform;
}

-(CGAffineTransform)rotationTransform{
    CGFloat aa = rand() % 360;
    float value = aa * M_PI / 180;
    CGAffineTransform transform = CGAffineTransformMakeRotation(value);
    return transform;
}

-(CGAffineTransform)setTransform{
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGAffineTransform rotationTransform = [self rotationTransform];
    CGAffineTransform sizeTransform = [self sizeTransform];

    transform = CGAffineTransformConcat(transform, sizeTransform);//transform的添加先后顺序对效果是有影响的
    transform = CGAffineTransformConcat(transform, rotationTransform);
    
    return transform;
}
//3d变化效果
-(CATransform3D)setCATransform3D{
    //定义一个新的transform 没有任何效果！
    CATransform3D transform = CATransform3DIdentity;
    //旋转3d的以圆心到x,y,z的直线为周现转一定的角度
    CATransform3D rotationTransform = CATransform3DMakeRotation((M_PI / 180.0) * 90.0f, 0.0f, 0.0f, 0.50f);
    //按比例在xyz方向上放大
    CATransform3D sizeTransform = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
    //移动到xyz的坐标点上
    CATransform3D translationTransform = CATransform3DMakeTranslation(1.0f, 1.0f, 1.0f);

    //东环效果一CGAffineTransform的只为准，可以使用组合效果
//    layer.transform = CATransform3DMakeAffineTransform([self setTransform]);
    
    transform = CATransform3DConcat(transform, rotationTransform);
    transform = CATransform3DConcat(transform, sizeTransform);
    transform = CATransform3DConcat(transform, translationTransform);
    
    return transform;
}

#pragma mark -- 动态效果

-(void)viewAnimationBlock{
    [UIView animateWithDuration:3 animations:^{
        //两种状态 ，开始和结束状态
        label.layer.transform = [self setCATransform3D];
    }];
}

-(void)viewAnimation{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:3];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(stopAnimation)];
    //两种状态 ，开始和结束状态
    label.layer.transform = [self setCATransform3D];
    
    [UIView commitAnimations];
}

-(void)transaction{
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [CATransaction setAnimationDuration:10.0f];
    /*  两种状态 ，开始和结束状态 
     
     只能针对layer而且不是root layer */
#if 1
    layer.transform = [self setCATransform3D];
#else
    //BasicAnimation本身就是动画，不违背上面的结论
    CABasicAnimation *FlipAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    FlipAnimation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    FlipAnimation.toValue= [NSNumber numberWithFloat:M_PI];
    FlipAnimation.duration=1;
    FlipAnimation.fillMode=kCAFillModeForwards;
    FlipAnimation.removedOnCompletion=NO;
    [label.layer addAnimation:FlipAnimation forKey:@"flip"];
#endif
    [CATransaction commit];
}

-(CATransition*)transitionWithSystemType{
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    /* 设定动画类型
     
     *  kCATransitionFade            交叉淡化过渡
     *  kCATransitionMoveIn          新视图移到旧视图上面
     *  kCATransitionPush            新视图把旧视图推出去
     *  kCATransitionReveal          将旧视图移开,显示下面的新视图
     *  @"push"
     *  @"fade"                     交叉淡化过渡(不支持过渡方向)             (默认为此效果)
     *  @"moveIn"                   新视图移到旧视图上面
     *  @"reveal"                   显露效果(将旧视图移开,显示下面的新视图)
     以下是私有效果审核时回被打回来
     * mapUnCurl
     *  @"cube"                     立方体翻滚效果
     *  @"pageCurl"                 向上翻一页
     *  @"pageUnCurl"               向下翻一页
     *  @"suckEffect"               收缩效果，类似系统最小化窗口时的神奇效果(不支持过渡方向)
     *  @"rippleEffect"             滴水效果,(不支持过渡方向)
     *  @"oglFlip"                  上下左右翻转效果
     *  @"rotate"                   旋转效果
     *  @"cameraIrisHollowOpen"     相机镜头打开效果(不支持过渡方向)
     *  @"cameraIrisHollowClose"    相机镜头关上效果(不支持过渡方向)
     */
    [animation setType:@"rotate"];
    
    /** subtype
     *
     *  各种动画方向
     *
     *  kCATransitionFromRight;      同字面意思(下同)
     *  kCATransitionFromLeft;
     *  kCATransitionFromTop;
     *  kCATransitionFromBottom;
     *  当type为@"rotate"(旋转)的时候,它也有几个对应的subtype,分别为:
     *  90cw    逆时针旋转90°
     *  90ccw   顺时针旋转90°
     *  180cw   逆时针旋转180°
     *  180ccw  顺时针旋转180°
     */
    [animation setSubtype:@"90cw"];//方向
    
    animation.fillMode = kCAFillModeBoth;
    //这个属性默认为YES.一般情况下,不需要设置这个属性. 但如果是CAAnimation动画,并且需要设置 fillMode 属性,那么需要将 removedOnCompletion 设置为NO,否则fillMode无效
    animation.removedOnCompletion = NO;
    
    animation.filter = nil;//CIFilter, 设置之后只有简单的可以使用复杂的需要filter自己做定时效果
    
    [animation setDuration:1.5f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    return animation;
}

-(CATransition*)transitionWithFilter{

    CIFilter* filter = [CIFilter filterWithName:@"CIBarSwipeTransition"];
    [filter setValue:[NSNumber numberWithFloat:3.14] forKey:@"inputAngle"];
    [filter setValue:[NSNumber numberWithFloat:30.0] forKey:@"inputWidth"];
    [filter setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputBarOffset"];
    
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    
    [animation setType:@"rotate"];
    [animation setSubtype:@"90cw"];//方向
    
    [animation setDuration:3];
    [animation setFilter:filter];//如果指定，那么指定的filter必须同时支持x和y，否则该filter将不起作用。
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    return animation;
}

/*
 animationWithKeyPath的值：
 官方链接：https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/AnimatableProperties/AnimatableProperties.html
 
 属性                说明                                                                                                  是否支持隐式动画
 anchorPoint        和中心点position重合的一个点，称为“锚点”，锚点的描述是相对于x、y位置比例而言的默认在图像中心点(0.5,0.5)的位置        是
 backgroundColor	图层背景颜色                                                                                            是
 borderColor        边框颜色                                                                                                是
 borderWidth        边框宽度                                                                                                是
 bounds             图层大小                                                                                                是
 contents           图层显示内容，例如可以将图片作为图层内容显示                                                                  是
 contentsRect       图层显示内容的大小和位置                                                                                   是
 cornerRadius       圆角半径                                                                                                是
 doubleSided        图层背面是否显示，默认为YES                                                                                否
 frame              图层大小和位置，不支持隐式动画，所以CALayer中很少使用frame，通常使用bounds和position代替                          否
 hidden             是否隐藏                                                                                                 是
 mask               图层蒙版                                                                                                 是
 maskToBounds       子图层是否剪切图层边界，默认为NO                                                                             是
 masksToBounds
 opacity            透明度 ，类似于UIView的alpha                                                                               是
 position           图层中心点位置，类似于UIView的center                                                                        是
 shadowColor        阴影颜色                                                                                                 是
 shadowOffset       阴影偏移量                                                                                                是
 shadowOpacity      阴影透明度，注意默认为0，如果设置阴影必须设置此属性                                                              是
 shadowPath         阴影的形状                                                                                                是
 shadowRadius       阴影模糊半径                                                                                              是
 sublayers          子图层                                                                                                   是
 sublayerTransform	子图层形变                                                                                                是
 
 zPosition
 
 backgroundFilters
 Uses the default implied CATransition object, described in Table B-3. Sub-properties of the filters are animated using the default implied CABasicAnimation object, described in Table B-2.
 compositingFilter
 Uses the default implied CATransition object, described in Table B-3. Sub-properties of the filters are animated using the default implied CABasicAnimation object, described in Table B-2.
 filters
 Uses the default implied CABasicAnimation object, described in Table B-2. Sub-properties of the filters are animated using the default implied CABasicAnimation object, described in Table B-2.
 
 transform          图层形变(使用的是 CATransform3D或CGAffineTransform)                                                         是
 
 transform.rotation.x
 transform.rotation.y
 transform.rotation.z           平面圖的旋轉
 transform.rotation
 transform.scale.x              闊的比例轉換
 transform.scale.y              高的比例轉換
 transform.scale.z
 transform.scale                比例轉換
 transform.translation.x        移动
 transform.translation.y
 transform.translation.z
 transform.translation

 */
-(CABasicAnimation*)basicAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];//可以从上面找到相关值
//    animation.fromValue = [NSNumber numberWithFloat:1.0f];
//    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.byValue = [NSNumber numberWithDouble:3];
    animation.autoreverses = YES;//是可以反向动画的
    animation.duration = 3;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

#pragma mark =====组合动画-=============
-(CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes
{
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = animationAry;
    animation.duration = time;
    animation.removedOnCompletion = NO;
    animation.repeatCount = repeatTimes;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

#pragma mark =====路径动画-=============
-(CAKeyframeAnimation *)keyframeAnimation:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.autoreverses = NO;
    animation.duration = time;
    animation.repeatCount = repeatTimes;
    return animation;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
