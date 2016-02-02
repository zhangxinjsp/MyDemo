//
//  CoreGraphicsViewController.m
//  MyDemo
//
//  Created by 张鑫 on 16/2/2.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "CoreGraphicsViewController.h"

#import "CoreGraphicsView.h"

@interface CoreGraphicsViewController () {
    CoreGraphicsView* cgView;
}

@end

@implementation CoreGraphicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    cgView = [[CoreGraphicsView alloc]init];
    cgView.backgroundColor = [UIColor lightGrayColor];
    cgView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:cgView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[cgView(>=0)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cgView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[cgView(>=0)]-100-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cgView)]];
    
    NSArray* titles = [[NSArray alloc]initWithArray:[CoreGraphicsView titles]];
    for (int i = 0; i < titles.count; i++) {
        
        NSString* title = [titles objectAtIndex:i];
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(i % 5 * 61 + 11, (self.view.bounds.size.height - 200) + (i / 5) * 40, 50, 30)];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(drawImageRect:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
}

-(void)drawImageRect:(id)sender{
    cgView.type = ((UIButton*)sender).tag;
    [cgView setNeedsDisplay];
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
