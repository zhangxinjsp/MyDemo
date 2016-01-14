//
//  MyNavigationController.m
//  MyDemo
//
//  Created by 张鑫 on 16/1/14.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

    
//    view 定义xib文件的方法
//        NSArray* array = [[NSBundle mainBundle]loadNibNamed:@"ItemView" owner:nil options:nil];
//        ItemView* tempView = [array objectAtIndex:0];
    
    
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
