//
//  FirstViewController.m
//  UINavgationController
//
//  Created by niexin on 12-10-26.
//  Copyright (c) 2012年 niexin. All rights reserved.
//

#import "NavRootViewController.h"

#import "CoreDataViewController.h"
#import "FileManagerReadAndWriteViewController.h"
#import "LastViewController.h"
#import "WebViewViewController.h"
#import "RefreshViewController.h"
#import "SQLiteViewController.h"
#import "SendMessageAndEMailViewController.h"
#import "ShareTofaceBookViewController.h"
#import "URLRequestViewController.h"
#import "AutoLayerViewController.h"
#import "SocketViewController.h"
#import "MapAndLocationViewController.h"
#import "ContactsViewController.h"
#import "MotionViewController.h"
#import "CameraPhotoViewController.h"
#import "ZBarViewController.h"
#import "ZXingViewController.h"
#import "CoreImageFilterViewController.h"


#import "CustomAlertView.h"

@interface NavRootViewController ()<CustomAlertViewDelegate>{
    NSArray* titleArray;
}

@end

@implementation NavRootViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"root";
    
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

    LOGINFO(NSLocalizedString(@"key", @""));
    
//    view 定义xib文件的方法
//        NSArray* array = [[NSBundle mainBundle]loadNibNamed:@"ItemView" owner:nil options:nil];
//        ItemView* tempView = [array objectAtIndex:0];

//#define __IPHONE_7_0
    
#ifdef __IPHONE_6_0
    
    LOGINFO(@"%@",@"this is ios 6.0");
    
#elif __IPHONE_5_0
    
    LOGINFO(@"%@",@"this is ios 5.0");
#elif __IPHONE_4_0
    
    LOGINFO(@"%@",@"this is ios 4.0");
#endif
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"run on simulator");
#else
    NSLog(@"run on device");
#endif
    
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    
    
    [self.view addSubview:scrollView];
    
    NSInteger menuItemViewHight = 72;
    NSInteger menuItemViewWidth = 57;
    NSInteger upDownGap = 15;
    NSInteger leftRightGap = 18;
    
    titleArray = [[NSArray alloc]initWithObjects:@"webView", @"transform", @"正则md5", @"drawrect", @"下拉刷新", @"CoreData", @"文件读写", @"SQLite", @"短信和邮件",@"分享", @"request", @"socket", @"Auto Layer", @"map,location", @"addressBook", @"motion", @"camera", @"ZBar", @"ZXing", @"filter", nil];
    
    for (int i = 0; i < titleArray.count; i++) {
        NSInteger x = (i % 4) * (menuItemViewWidth + leftRightGap) + leftRightGap;
        NSInteger y = (i / 4) * (menuItemViewHight + upDownGap) + upDownGap;
        
        UIButton* itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, menuItemViewWidth, menuItemViewHight)];
        itemBtn.tag = i;
        itemBtn.backgroundColor = [UIColor lightGrayColor];
        [itemBtn addTarget:self action:@selector(itemButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [itemBtn setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
        [itemBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 10, 0)];
        [scrollView addSubview:itemBtn];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, menuItemViewHight - 25, menuItemViewWidth, 20)];
        label.text = [titleArray objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12];
        [itemBtn addSubview:label];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    LOGINFO(@"%@",@"view will appear ");
    
   
    
}

-(void)viewWillDisappear:(BOOL)animated{
    LOGINFO(@"%@",@"view will disappear");
}

-(void)itemButtonPressed:(id)sender{
    LOGINFO(@"menu button pressed!!");
    NSInteger tag = ((UIButton*)sender).tag;
    switch (tag) {
        case 0:{
            WebViewViewController* ctl = [[WebViewViewController alloc]initWithNibName:@"WebViewViewController" bundle:nil];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 1:{
            TransformViewController* ctl = [[TransformViewController alloc] initWithNibName:@"TransformViewController" bundle:nil];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 2:{
            RegexAndMd5ViewController* ctl = [[RegexAndMd5ViewController alloc] initWithNibName:@"RegexAndMd5ViewController" bundle:nil];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 3:{
            DrawRectViewController* ctl = [[DrawRectViewController alloc] initWithNibName:@"DrawRectViewController" bundle:nil];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 4:{
            RefreshViewController* ctl = [[RefreshViewController alloc]initWithNibName:@"RefreshViewController" bundle:nil];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 5:{
            CoreDataViewController* ctl = [[CoreDataViewController alloc] initWithNibName:nil bundle:nil];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 6:{
            FileManagerReadAndWriteViewController* ctl = [[FileManagerReadAndWriteViewController alloc] initWithNibName:@"FileManagerReadAndWriteViewController" bundle:nil];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 7:{
            SQLiteViewController* ctl = [[SQLiteViewController alloc]initWithNibName:@"SQLiteViewController" bundle:nil];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 8:{
            SendMessageAndEMailViewController* ctl = [[SendMessageAndEMailViewController alloc]initWithNibName:@"SendMessageAndEMailViewController" bundle:nil];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 9:{
            ShareTofaceBookViewController* ctl = [[ShareTofaceBookViewController alloc] initWithNibName: @"ShareTofaceBookViewController" bundle:nil];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 10:{
            URLRequestViewController* ctl = [[URLRequestViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 11:{
            SocketViewController* ctl = [[SocketViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 12:{
            AutoLayerViewController* ctl = [[AutoLayerViewController alloc] initWithNibName:@"AutoLayerViewController" bundle:nil];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 13:{
            MapAndLocationViewController* ctl = [[MapAndLocationViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 14:{
            ContactsViewController* ctl = [[ContactsViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 15:{
            MotionViewController* ctl = [[MotionViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 16:{
            CameraPhotoViewController* ctl = [[CameraPhotoViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 17:{
            ZBarViewController* ctl = [[ZBarViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 18:{
            ZXingViewController* ctl = [[ZXingViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 19:{
            CoreImageFilterViewController* ctl = [[CoreImageFilterViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        default:
            break;
    }
}
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

-(void)customAlertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    LOGINFO(@"aaaaaaa%d", buttonIndex);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}
@end
