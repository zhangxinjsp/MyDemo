//
//  ScrollViewCycleController.m
//  UINavgationController
//
//  Created by zhangxin on 13-1-6.
//  Copyright (c) 2013年 zhangxin. All rights reserved.
//

#import "ScrollViewCycleController.h"

#import "ScrollCycleView.h"

@interface ScrollViewCycleController () <ScrollCycleViewDelegate>

@end

@implementation ScrollViewCycleController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        ScrollCycleView *cycle = [[ScrollCycleView alloc]init];
        [cycle setShowItemArray:nil];
        cycle.delegate = self;
        [self.view addSubview:cycle];
        
    }
    return self;
}

- (void)viewDidLoad
{
        // Do any additional setup after loading the view from its nib.
}

@end
