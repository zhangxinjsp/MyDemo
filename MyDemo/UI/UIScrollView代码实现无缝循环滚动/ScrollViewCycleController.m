//
//  ScrollViewCycleController.m
//  UINavgationController
//
//  Created by zhangxin on 13-1-6.
//  Copyright (c) 2013年 zhangxin. All rights reserved.
//

#import "ScrollViewCycleController.h"

#import "ScrollCycleView.h"

@interface ScrollViewCycleController () <ScrollCycleViewDelegate> {
    ScrollCycleView *cycle;
}

@end

@implementation ScrollViewCycleController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [cycle layoutScrollView];
}

- (void)viewDidLoad
{
        // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    
    cycle = [[ScrollCycleView alloc]init];
    cycle.needAutoCycle = YES;
    [cycle setShowItemArray:@[[UIImage imageNamed:@"boots"], [UIImage imageNamed:@"head_fair"], [UIImage imageNamed:@"redFlower"]]];
    
    cycle.delegate = self;
    [cycle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:cycle];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[cycle(>=0)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cycle)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[cycle(>=0)]-100-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cycle)]];
}

-(void)didSelectAtIndex:(NSInteger)index {
    
}

@end
