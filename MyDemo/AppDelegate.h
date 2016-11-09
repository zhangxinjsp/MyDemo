//
//  AppDelegate.h
//  UINavgationController
//
//  Created by zhangxin on 12-9-12.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

#import "MyTabBarController.h"
#import "RootNavigationController.h"




@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) MyTabBarController* tabBarController;
@property (strong, nonatomic) RootNavigationController* navigationController;

//@property (strong, nonatomic) ViewController * asdvi;

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) FBSession *session;

@property (copy) void (^backgroundSessionCompletionHandler)(); 

@end
