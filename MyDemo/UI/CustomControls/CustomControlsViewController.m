//
//  CustomControlsViewController.m
//  MyDemo
//
//  Created by zhangxin on 16/1/21.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "CustomControlsViewController.h"

#import "CustomAlertView.h"

@interface CustomControlsViewController ()

@end

@implementation CustomControlsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}



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
