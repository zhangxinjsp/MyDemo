//
//  LastViewController.m
//  UINavgationController
//
//  Created by niexin on 12-10-26.
//  Copyright (c) 2012年 niexin. All rights reserved.
//

#import "LastViewController.h"
#import "UILabel-LineHeigh.h"




@interface LastViewController ()

@end

@implementation LastViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
            canAutorotate = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"last View Controller";
    
//    com.huawei.ott.hosting${PRODUCT_NAME:rfc1034identifier}
    
    UITextField* asdf = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, 60,30)];
    asdf.backgroundColor = [UIColor redColor];
    [self.view addSubview:asdf];
    
    
    UIImage* image = [[UIImage imageNamed:@"bubble_blue_recieve_doctor.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(53.0f,34.0f,20.0f,34.0f)];
    UIImageView* imageview = [[UIImageView alloc]initWithImage:image];
    imageview.frame = CGRectMake(100, 100, 100, 70);
    [self.view addSubview:imageview];
    
    //item按下是会有高亮效果的
    UIToolbar *tools = [[UIToolbar alloc]initWithFrame: CGRectMake(0.0f, 0.0f, 44.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
    tools.clipsToBounds = NO;
    tools.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateNewsBtnPressed:)];
    [tools setItems:[NSArray arrayWithObject:item]];
    UIBarButtonItem *updateBtn = [[UIBarButtonItem alloc]initWithCustomView:tools];
    [self.navigationItem setRightBarButtonItem:updateBtn];
    
    UIButton* channelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [channelBtn setBackgroundImage:[UIImage imageNamed:@"dragDown.png"] forState:UIControlStateNormal];
    [channelBtn setBackgroundImage:[UIImage imageNamed:@"logo.png.png"] forState:UIControlStateHighlighted];
    [channelBtn setBackgroundImage:[UIImage imageNamed:@"dragUp.png"] forState:UIControlStateSelected];
    [channelBtn setBackgroundImage:[UIImage imageNamed:@"paletta_icon.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [channelBtn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [channelBtn setTag:0];
    [self.view addSubview:channelBtn];
    
    UIButton* purchaseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 50, 40, 20)];
    [purchaseBtn setBackgroundImage:[UIImage imageNamed:@"dragUp.png"] forState:UIControlStateNormal];
    [purchaseBtn setBackgroundImage:[UIImage imageNamed:@"logo.png.png"] forState:UIControlStateHighlighted];
    [purchaseBtn setBackgroundImage:[UIImage imageNamed:@"dragDown.png"] forState:UIControlStateSelected];
    [purchaseBtn setBackgroundImage:[UIImage imageNamed:@"paletta_icon.png"] forState:UIControlStateReserved];
    [purchaseBtn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [purchaseBtn setTag:1];
    [self.view addSubview:purchaseBtn];
    
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 200, 300, 40)];
    //	searchBar.backgroundColor = [UIColor clearColor];
    searchBar.backgroundImage = nil;
	searchBar.placeholder = @"SearchBarPlaceHolder";
    
	searchBar.keyboardType = UIKeyboardTypeDefault;
    //	searchBar.tintColor = [UIColor clearColor];
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
	// 去掉Searchbar的背景
    //    if (1) {
    [searchBar setBarTintColor:[UIColor clearColor]];
    for (UIView *view in searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    [self.view addSubview:searchBar];
    
    NSString* string = @"redbluegreen";
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"red"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[string rangeOfString:@"green"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[string rangeOfString:@"blue"]];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 250, 300, 40)];
    
    label.textAlignment = NSTextAlignmentRight;
    label.attributedText = attributedString;
    
    [self.view addSubview:label];



}

-(void)btnSelected:(id)sender{

    
    NSInteger tag = ((UIButton*)sender).tag;
    if (tag == 0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"alert view" message:@"asdfadsf" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:@"cancel", nil];
        alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        
        [alert show];
        
    }else if (tag == 1){
//        UIAlertController* alertCtl = [UIAlertController alertControllerWithTitle:@"alert controller" message:@"asdghkajsdhkasf" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [self alertActionHandle:action];
//        }];
//        [alertCtl addAction:okAction];
//
//        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//            [self alertActionHandle:action];
//        }];
//        [alertCtl addAction:cancelAction];
//        
//        UIAlertAction* caAction = [UIAlertAction actionWithTitle:@"ca" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//            [self alertActionHandle:action];
//        }];
//        [alertCtl addAction:caAction];
//
//        [self presentViewController:alertCtl animated:YES completion:^{
//            
//        }];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    LOGINFO(@"alert view index %d", buttonIndex);
}

//-(void)alertActionHandle:(UIAlertAction*)alertAction{
//    LOGINFO(@"alert controller action title is %@", alertAction.title);
//}

-(void)updateNewsBtnPressed:(id)sender{
    
    
    LOGINFO(@"%@",@"updateNewsBtnPressed");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backAction:(id)sender{
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tapAction:(id)sender{
    
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    
}
             




-(void)viewWillDisappear:(BOOL)animated{
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    self.navigationController.navigationBarHidden = NO;
}


-(void)viewWillAppear:(BOOL)animated{
    LOGINFO(@"viewWillAppear");
}

-(void)viewDidAppear:(BOOL)animated{
    LOGINFO(@"viewDidAppear");
//    [UIApplication sharedApplication].statusBarHidden = NO;
    canAutorotate = YES;
    
    
}





-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    textField.inputView.transform = CGAffineTransformMakeRotation(M_PI / 2);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    textField.inputView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return YES;
}


-(BOOL)shouldAutorotate{
    return YES;
    return canAutorotate;
}

-(NSUInteger)supportedInterfaceOrientations{
    
//    if (canAutorotate && ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ||
//        [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight)) {
//        self.view.transform = CGAffineTransformMakeRotation(0);
//        self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
//    }
    
    
    return UIInterfaceOrientationMaskLandscape;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}







@end
