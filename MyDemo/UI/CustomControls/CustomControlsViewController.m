//
//  CustomControlsViewController.m
//  MyDemo
//
//  Created by zhangxin on 16/1/21.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "CustomControlsViewController.h"

#import "CustomAlertView.h"

@interface CustomControlsViewController () <CustomAlertViewDelegate> {
    UIButton* alertShowBtn;
}

@end

@implementation CustomControlsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    alertShowBtn = [[UIButton alloc]init];
    alertShowBtn.backgroundColor = [UIColor redColor];
    [alertShowBtn setTitle:@"show alert" forState:UIControlStateNormal];
    [alertShowBtn addTarget:self action:@selector(customAlert) forControlEvents:UIControlEventTouchUpInside];
    [alertShowBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:alertShowBtn];
    
    NSDictionary* viewDict = NSDictionaryOfVariableBindings(alertShowBtn);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[alertShowBtn(>=0)]-10-|" options:0 metrics:nil views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[alertShowBtn(==30)]-(>=0)-|" options:0 metrics:nil views:viewDict]];
    
}


#pragma mark Alert
-(void)customAlert{
    CustomAlertView* inputalert = [[CustomAlertView alloc]initWithTitle:@"000000" message:@"mmmmmmmmmmmmmmmm" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok0", nil];
    inputalert.alertType = CustomAlertViewTypeSecureTextInput;
    inputalert.alertActionType = AlertActionDefault;
    [inputalert show];
    
    CustomAlertView* inputalert1 = [[CustomAlertView alloc]initWithTitle:@"111111" message:@"mmmmmmmmmmmmmmmm11111" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok0", nil];
    inputalert1.alertType = CustomAlertViewTypeSecureTextInput;
    inputalert1.alertActionType = AlertActionDefault;
    [inputalert1 show];
    
    CustomAlertView* inputalert2 = [[CustomAlertView alloc]initWithTitle:@"222222" message:@"mmmmmmmmmmmmmmmm2222222" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok0", nil];
    inputalert2.alertType = CustomAlertViewTypeSecureTextInput;
    inputalert2.alertActionType = AlertActionDefault;
    [inputalert2 show];
    
    CustomAlertView* inputalert3 = [[CustomAlertView alloc]initWithTitle:@"333333" message:@"mmmmmmmmmmmmmmmm3333333" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok0", nil];
    inputalert3.alertType = CustomAlertViewTypeSecureTextInput;
    inputalert3.alertActionType = AlertActionUserActionPrompt;
    [inputalert3 show];
}

-(void)customAlertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

#pragma mark Segment
static UIView* segmentView = nil;
static UIView* segmentMaskView = nil;
- (void)customSegmentView {
    segmentView = [[UIView alloc]init];
    
    
    
    
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
