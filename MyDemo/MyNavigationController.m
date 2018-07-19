//
//  MyNavigationController.m
//  MyDemo
//
//  Created by 张鑫 on 16/1/14.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "MyNavigationController.h"


@interface PopAnimation : NSObject <UIViewControllerAnimatedTransitioning, CAAnimationDelegate>{
    id<UIViewControllerContextTransitioning> _transitionContext;
}

@property (nonatomic, readwrite) UINavigationControllerOperation operation;

@end

@implementation PopAnimation

@synthesize operation;

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    
    UIViewController* from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController* to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView* contenterView = [transitionContext containerView];
    
    _transitionContext = transitionContext;
    [contenterView insertSubview:to.view aboveSubview:from.view];
    
//当需要两种效果之间切换的时候，使用contenter view（即navigation的view）同时toView要在上面
    [contenterView.layer addAnimation:[self transitionWithSystemType] forKey:@"" ];
    
//    NSTimeInterval duration = [self transitionDuration:transitionContext];
//    [UIView animateWithDuration:duration animations:^{
//        from.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
//    } completion:^(BOOL finished) {
//        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
//    }];
    
}

-(CATransition*)transitionWithSystemType{
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:@"cube"];
    if (self.operation == UINavigationControllerOperationPop) {
        [animation setSubtype:kCATransitionFromLeft];
    } else {
        [animation setSubtype:kCATransitionFromRight];
    }
    animation.fillMode = kCAFillModeBoth;
    animation.removedOnCompletion = NO;
//    animation.filter = nil;
    [animation setDuration:[self transitionDuration:nil]];
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    return animation;
}

-(void)animationDidStart:(CAAnimation *)anim{
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
}
@end




@interface MyNavigationController () <UINavigationControllerDelegate> {
    UIPercentDrivenInteractiveTransition* interactiveTransition;
}


@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureHandle:)];
    [self.view addGestureRecognizer:pan];

    self.delegate = self;
}

#pragma mark navigation pop animation
-(void)panGestureHandle:(UIPanGestureRecognizer*)gesture{
    
    CGFloat progress = [gesture translationInView:self.view].x / self.view.bounds.size.width;
    
    progress = MIN(1.0, MAX(0, progress));
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self popViewControllerAnimated:YES];
        
    }else if (gesture.state == UIGestureRecognizerStateChanged){
        [interactiveTransition updateInteractiveTransition:progress];
    }else if (gesture.state == UIGestureRecognizerStateEnded ||
              gesture.state == UIGestureRecognizerStateCancelled){
        
        if (progress > 0.5) {
            [interactiveTransition finishInteractiveTransition];
        }else{
            [interactiveTransition cancelInteractiveTransition];
        }
        interactiveTransition = nil;
    }
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if ([navigationController isEqual:self]) {
        PopAnimation* animation = [[PopAnimation alloc]init];
        animation.operation = operation;
        return animation;
    }
    return nil;
}


-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    
    if ([animationController isKindOfClass:[PopAnimation class]]) {
        return interactiveTransition;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end






