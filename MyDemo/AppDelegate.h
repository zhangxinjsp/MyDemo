//
//  AppDelegate.h
//  UINavgationController
//
//  Created by zhangxin on 12-9-12.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "NavRootViewController.h"
#import "RootNavigationController.h"




@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) NavRootViewController* firstView;
@property (strong, nonatomic) RootNavigationController* nav;

//@property (strong, nonatomic) ViewController * asdvi;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FBSession *session;

@property (copy) void (^backgroundSessionCompletionHandler)(); 

@end
