//
//  AppDelegate.m
//  UINavgationController
//
//  Created by zhangxin on 12-9-12.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import "AppDelegate.h"

#import "TestViewController.h"

@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.tabBarController = [[MyTabBarController alloc] init];

    self.navigationController = [[RootNavigationController alloc]initWithRootViewController:self.tabBarController];
    self.window.rootViewController = self.navigationController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //register Notification
    [self registerNotification];
    
    // installs HandleExceptions as the Uncaught Exception Handler
    NSSetUncaughtExceptionHandler(&HandleExceptions);
    // create the signal action structure
    struct sigaction newSignalAction;
    // initialize the signal action structure
    memset(&newSignalAction, 0, sizeof(newSignalAction));
    // set SignalHandler as the handler in the signal action structure
    newSignalAction.sa_handler = &SignalHandler;
    // set SignalHandler as the handlers for SIGABRT, SIGILL and SIGBUS
    sigaction(SIGABRT, &newSignalAction, NULL);
    sigaction(SIGILL, &newSignalAction, NULL);
    sigaction(SIGBUS, &newSignalAction, NULL);
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    LOGINFO(@"");
}

static UIBackgroundTaskIdentifier backgroundTask;
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
        LOGINFO(@"background task expiration handler");
    }];
    /*
     do something 
     end task after finish something
     */
    backgroundTask = UIBackgroundTaskInvalid;
    [application endBackgroundTask:backgroundTask];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    LOGINFO(@"facebook handle become active!");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
//    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:self.session];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    LOGINFO(@"我的设备ID: %@", newDeviceToken);
}

-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    LOGINFO(@"注册失败，无法获取设备ID, 具体错误: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //    [PFPush handlePush:userInfo];
    for (id key in userInfo) {
        LOGINFO(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
}
/**
 ios10 的方法
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    LOGINFO(@"%@" ,notification);
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler {
    self.backgroundSessionCompletionHandler = completionHandler;
    //add notification
    [self presentNotification];
}

/*
 My Apps Custom uncaught exception catcher, we do special stuff here, and TestFlight takes care of the rest
 */
void HandleExceptions(NSException *exception) {
    LOGINFO(@"This is where we save the application data during a exception");
    LOGINFO([NSString stringWithFormat:@"%@",exception]);
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    BOOL finish = NO;//可以定义为全局变量，来决定是否完成某些事
    while (finish) {
        for (NSString *mode in (__bridge NSArray *)allModes) {
            CFRunLoopRunInMode((__bridge CFStringRef)mode, 0.001, false);
        }
    }
    
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    [exception raise];
    // Save application data on crash
}

/*
 My Apps Custom signal catcher, we do special stuff here, and TestFlight takes care of the rest
 */
void SignalHandler(int sig) {
    LOGINFO(@"This is where we save the application data during a signal");
    // Save application data on crash
}

- (void)registerNotification {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        UNAuthorizationOptions op = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
        
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:op completionHandler:^(BOOL granted, NSError * _Nullable error) {
            NSLog(@"%@", error.description);
            // Enable or disable features based on authorization.
            UNNotificationCategory* generalCategory = [UNNotificationCategory
                                                       categoryWithIdentifier:@"GENERAL"
                                                       actions:@[]
                                                       intentIdentifiers:@[]
                                                       options:UNNotificationCategoryOptionCustomDismissAction];
            
            // Create the custom actions for expired timer notifications.
            UNNotificationAction* snoozeAction = [UNNotificationAction
                                                  actionWithIdentifier:@"SNOOZE_ACTION"
                                                  title:@"Snooze"
                                                  options:UNNotificationActionOptionNone];
            
            UNNotificationAction* stopAction = [UNNotificationAction
                                                actionWithIdentifier:@"STOP_ACTION"
                                                title:@"Stop"
                                                options:UNNotificationActionOptionForeground];
            
            // Create the category with the custom actions.
            UNNotificationCategory* expiredCategory = [UNNotificationCategory
                                                       categoryWithIdentifier:@"TIMER_EXPIRED"
                                                       actions:@[snoozeAction, stopAction]
                                                       intentIdentifiers:@[]
                                                       options:UNNotificationCategoryOptionNone];
            
            // Register the notification categories.
            [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:generalCategory, expiredCategory, nil]];
            
            [[UNUserNotificationCenter currentNotificationCenter]getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                
            }];
            
            [[UNUserNotificationCenter currentNotificationCenter]getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
                
            }];
            
        }];
    } else if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UIApplication sharedApplication]registerForRemoteNotifications];
        //categories 初始化方法iOS10 的一致，注意类的不同
        UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeBadge| UIUserNotificationTypeSound| UIUserNotificationTypeAlert categories:nil];
        
        [[UIApplication sharedApplication]registerUserNotificationSettings:settings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    }
    
}

-(void)presentNotification{
    //后台下载的通知
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"Download Complete!";
    localNotification.alertAction = @"Background Transfer Download!";
    //On sound
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    //increase the badge number of application plus 1
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Update the app interface directly.
    
    // Play a sound.
    completionHandler(UNNotificationPresentationOptionSound);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    if ([response.actionIdentifier isEqualToString:UNNotificationDismissActionIdentifier]) {
        // The user dismissed the notification without taking action.
    }
    else if ([response.actionIdentifier isEqualToString:UNNotificationDefaultActionIdentifier]) {
        // The user launched the app.
    }
    
    if ([response.notification.request.content.categoryIdentifier isEqualToString:@"TIMER_EXPIRED"]) {
        // Handle the actions for the expired timer.
        if ([response.actionIdentifier isEqualToString:@"SNOOZE_ACTION"])
        {
            // Invalidate the old timer and create a new one. . .
        }
        else if ([response.actionIdentifier isEqualToString:@"STOP_ACTION"])
        {
            // Invalidate the timer. . .
        }
        
    }
    
    // Else handle actions for other notification types. . .
}



@end
