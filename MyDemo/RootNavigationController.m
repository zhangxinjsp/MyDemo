//
//  NavigationController.m
//  UINavgationController
//
//  Created by zhangxin on 12-9-12.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import "RootNavigationController.h"

@interface RootNavigationController ()

@end

@implementation RootNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBarHidden = YES;
    // Do any additional setup after loading the view from its nib.
    
#ifdef __IPHONE_6_0
    
    LOGINFO(@"%@",@"this is ios 6.0");
    
#elif __IPHONE_5_0
    
    LOGINFO(@"%@",@"this is ios 5.0");
#elif __IPHONE_4_0
    
    LOGINFO(@"%@",@"this is ios 4.0");
#endif
    
#if TARGET_IPHONE_SIMULATOR
    LOGINFO(@"run on simulator");
#else
    LOGINFO(@"run on device");
#endif
    
    LOGINFO(NSLocalizedString(@"key", @""));
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

-(BOOL)shouldAutorotate{
    return [self.topViewController shouldAutorotate];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{

    return [self.topViewController supportedInterfaceOrientations];
}


@end
