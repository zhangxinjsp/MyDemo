//
//  NaviBarViewController.m
//  MyDemo
//
//  Created by 张鑫 on 16/1/14.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "NaviBarViewController.h"

#import "CustomAlertView.h"

@interface NaviBarViewController ()

@end

@implementation NaviBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton* logoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];//rect是必须的
    [logoBtn setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    [logoBtn addTarget:self action:@selector(logoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* itemButton = [[UIBarButtonItem alloc]initWithCustomView:logoBtn];//只有initWithCustomView才可以改变大小
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];//view也是可以的
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"logo.png"]];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoViewTapped:)];
    [view addGestureRecognizer:tap];
    UIBarButtonItem* itemView = [[UIBarButtonItem alloc]initWithCustomView:view];//只有initWithCustomView才可以改变大小
    
    UILabel* _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    _label.text = @"1383";
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor redColor];
    _label.font = [UIFont systemFontOfSize:12];
    UIBarButtonItem* itemLabel = [[UIBarButtonItem alloc]initWithCustomView:_label];
    
    self.navigationItem.leftBarButtonItems = [[NSArray alloc]initWithObjects:itemButton, itemLabel, nil];
    
    UIBarButtonItem* item1 = [[UIBarButtonItem alloc]initWithTitle:@"返回1" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonPressed:)];//backBarButtonItem必须设置一个UIBarButtonItem才能修改标题，而且事件添加无效！且只有在上一个界面添加返回按钮
    self.navigationItem.backBarButtonItem = item1;
    
    //右键
    UIBarButtonItem* item2 = [[UIBarButtonItem alloc]initWithTitle:@"next"style:UIBarButtonItemStyleBordered target:self action:@selector(nextStep:)];
    self.navigationItem.rightBarButtonItem = item2;
    
}

-(void)nextStep:(id)sender{
    
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
    
    
#ifdef __IPHONE_8_0
    
    UIAlertController* alertCtl = [UIAlertController alertControllerWithTitle:@"alert controller" message:@"asdghkajsdhkasf" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self alertActionHandle:action];
    }];
    [alertCtl addAction:okAction];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self alertActionHandle:action];
    }];
    [alertCtl addAction:cancelAction];
    
    UIAlertAction* caAction = [UIAlertAction actionWithTitle:@"ca" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self alertActionHandle:action];
    }];
    [alertCtl addAction:caAction];
    
    [self presentViewController:alertCtl animated:YES completion:^{
        
    }];
#endif
}

#ifdef __IPHONE_8_0
-(void)alertActionHandle:(UIAlertAction*)alertAction{
    LOGINFO(@"alert controller action title is %@", alertAction.title);
}
#endif


-(void)logoButtonPressed:(id)sender{
    LOGINFO(@"%@",@"logo button pressed!!");
    LOGINFO(@"%@", NSLocalizedString(@"key", @""));
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"title" message:@"aklsjdghklasjdghlaksjdgha;sdklgh;asdghas;ldgjha;sdghas;dglhas;dg" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok0",@"ok1", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert show];
    
}

-(void)logoViewTapped:(id)sender{
    LOGINFO(@"%@",@"logo view tapped!!");
}

-(void)backButtonPressed:(id)sender{
    LOGINFO(@"%@",@"back button pressed!!");
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