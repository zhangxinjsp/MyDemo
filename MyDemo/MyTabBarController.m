//
//  MyTabBarController.m
//  MyDemo
//
//  Created by 张鑫 on 16/1/14.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "MyTabBarController.h"

#import "UIMenuViewController.h"
#import "OtherMenuViewController.h"
#import "TestViewController.h"
#import "MyNavigationController.h"

@interface MyTabBarController () {
    
    UIMenuViewController* uiMenuViewController;
    OtherMenuViewController* otherViewController;
    TestViewController* testViewControler;
    
    MyNavigationController* uiMenuNavigation;
    MyNavigationController* otherNavigation;
    MyNavigationController* testNavigation;
    
    UIView* maskView;
}

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    uiMenuViewController = [[UIMenuViewController alloc]init];
    uiMenuNavigation = [[MyNavigationController alloc]initWithRootViewController:uiMenuViewController];
    uiMenuNavigation.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    uiMenuNavigation.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"ui" image:[UIImage imageNamed:@""] tag:0];
    
    otherViewController = [[OtherMenuViewController alloc]init];
    otherNavigation = [[MyNavigationController alloc]initWithRootViewController:otherViewController];
    otherNavigation.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"other" image:[UIImage imageNamed:@""] tag:1];
    
    testViewControler = [[TestViewController alloc]init];
    testNavigation = [[MyNavigationController alloc]initWithRootViewController:testViewControler];
    testNavigation.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"test" image:[UIImage imageNamed:@""] tag:2];
    
    [self setViewControllers:@[uiMenuNavigation, otherNavigation, testNavigation]];
    
    [self setupColorView];
}

- (void)setupColorView {
    NSArray* colors = @[[UIColor redColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor brownColor], [UIColor yellowColor]];
    
    UIView * colorfulView = [[UIView alloc]initWithFrame:self.tabBar.bounds];
    NSString* colorFormatStr = @"H:|-0-";
    NSMutableDictionary* colorViewDict = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < self.viewControllers.count; i ++) {
        UIView* colorView = [[UIView alloc]init];
        colorView.backgroundColor = colors[i];
        [colorView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [colorfulView addSubview:colorView];
        
        NSString* colorViewName = [NSString stringWithFormat:@"colorView_%d", i];
        [colorViewDict setObject:colorView forKey:colorViewName];
        colorFormatStr = [colorFormatStr stringByAppendingFormat:@"[%@(%@)]-0-", colorViewName, i == 0 ? @">=0" : @"colorView_0"];
    }
    colorFormatStr = [colorFormatStr stringByAppendingString:@"|"];
    
    [colorfulView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:colorFormatStr options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:colorViewDict]];
    [colorfulView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[colorView_0(>=0)]-0-|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:colorViewDict]];
    
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tabBar.bounds.size.width / self.viewControllers.count, self.tabBar.bounds.size.height)];
    maskView.backgroundColor = [UIColor blackColor];
    
    if ([UIDevice currentDevice].systemVersion.floatValue > 8.0) {
        colorfulView.maskView = maskView;//ios8才有的；
    } else {
        colorfulView.layer.mask = maskView.layer;
    }
    [self.tabBar addSubview:colorfulView];

    [self.tabBar sendSubviewToBack:colorfulView];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = maskView.frame;
        rect.origin.x = self.tabBar.bounds.size.width / self.viewControllers.count * item.tag;
        maskView.frame = rect;
    }];
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
