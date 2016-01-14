//
//  FirstViewController.m
//  UINavgationController
//
//  Created by zhangxin on 12-10-26.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import "UIMenuViewController.h"

#import "CoreDataViewController.h"
#import "FileManagerReadAndWriteViewController.h"
#import "TestViewController.h"
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
#import "CameraViewController.h"
#import "QRCodeViewController.h"
#import "CoreImageFilterViewController.h"
#import "VideoToolViewController.h"

@interface UIMenuViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    
    UICollectionView* collection;
    
    NSArray* titleArray;
}

@end

@implementation UIMenuViewController


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
    self.navigationItem.title = @"ui menu";
    
    titleArray = [[NSArray alloc]initWithObjects:@"webView", @"transform", @"正则md5", @"drawrect", @"下拉刷新", @"CoreData", @"文件读写", @"SQLite", @"短信和邮件",@"分享", @"request", @"socket", @"Auto Layer", @"map,location", @"addressBook", @"motion", @"camera", @"ZBar", @"ZXing", @"filter", @"videoTool", nil];
    
//    collection = [[UICollectionView alloc]init];
//    collection.delegate = self;
//    collection.dataSource = self;
//    collection.backgroundColor = [UIColor redColor];
//    collection.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:collection];
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collection(>=0)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collection)]];
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collection(>=0)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collection)]];
}

-(void)viewWillAppear:(BOOL)animated{
    LOGINFO(@"%@",@"view will appear ");
}

-(void)viewWillDisappear:(BOOL)animated{
    LOGINFO(@"%@",@"view will disappear");
}

#pragma mark collection view delegate and data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc]init];
        cell.backgroundColor = [UIColor greenColor];
    }
    
    return cell;
}



-(void)itemButtonPressed:(id)sender{
    LOGINFO(@"menu button pressed!!");
    NSInteger tag = ((UIButton*)sender).tag;
    switch (tag) {
        case 0:{
            WebViewViewController* ctl = [[WebViewViewController alloc]init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 1:{
            TransformViewController* ctl = [[TransformViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 2:{
            RegexAndMd5ViewController* ctl = [[RegexAndMd5ViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 3:{
            DrawRectViewController* ctl = [[DrawRectViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 4:{
            RefreshViewController* ctl = [[RefreshViewController alloc]init];
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
            FileManagerReadAndWriteViewController* ctl = [[FileManagerReadAndWriteViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 7:{
            SQLiteViewController* ctl = [[SQLiteViewController alloc]init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 8:{
            SendMessageAndEMailViewController* ctl = [[SendMessageAndEMailViewController alloc]init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 9:{
            ShareTofaceBookViewController* ctl = [[ShareTofaceBookViewController alloc] init];
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
            AutoLayerViewController* ctl = [[AutoLayerViewController alloc] init];
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
            CameraViewController* ctl = [[CameraViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 17:{
//            ZBarViewController* ctl = [[ZBarViewController alloc] init];
//            ctl.title = [titleArray objectAtIndex:tag];
//            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 18:{
            QRCodeViewController* ctl = [[QRCodeViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 19:{
            CoreImageFilterViewController* ctl = [[CoreImageFilterViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case 20:{
            VideoToolViewController* ctl = [[VideoToolViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        default:
            break;
    }
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}
@end
