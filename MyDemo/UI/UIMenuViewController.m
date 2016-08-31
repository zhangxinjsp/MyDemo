//
//  FirstViewController.m
//  UINavgationController
//
//  Created by zhangxin on 12-10-26.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import "UIMenuViewController.h"

#import "AutoLayerViewController.h"
#import "CameraViewController.h"
#import "CoreImageFilterViewController.h"
#import "CoreGraphicsViewController.h"
#import "MapAndLocationViewController.h"
#import "NaviBarViewController.h"
#import "TransformViewController.h"
#import "ScrollViewCycleController.h"
#import "VideoToolViewController.h"
#import "WebViewViewController.h"
#import "RefreshViewController.h"
#import "QRCodeViewController.h"
#import "SendMessageAndEMailViewController.h"
#import "CustomAlertViewController.h"
#import "CustomSegmentViewController.h"
#import "TextAttributeViewController.h"
#import "CollectionViewViewController.h"

#define CellIdentity @"identity"

typedef NS_ENUM(NSInteger, MenuType) {
    AutoLayerTag,
    CameraTag,
    CoreImageFilterTag,
    CoreGraphicsTag,
    MapAndLocationTag,
    NaviBarTag,
    TransformTag,
    ScrollViewCycleTag,
    VideoToolTag,
    WebViewTag,
    RefreshTag,
    QRCodeTag,
    SendMessageAndEMailTag,
    CustomAlertTag,
    CustomSegmentTag,
    TextAttributeTag,
    CollectionViewTag,
};
@interface UIMenuViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    
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
    
    titleArray = [[NSArray alloc]initWithObjects:@"Auto Layer", @"camera", @"filter", @"CoreGraphics", @"map,location", @"naviBar", @"transform", @"scroll", @"videoTool", @"webView", @"下拉刷新", @"QRCode", @"短信和邮件", @"alert", @"segment", @"TextAttribute", @"collectionView", nil];
    
    
    UICollectionViewFlowLayout* collectionLayout = [[UICollectionViewFlowLayout alloc]init];
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:collectionLayout];
    [collection registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:CellIdentity];
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor lightGrayColor];
    collection.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:collection];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collection(>=0)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collection)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collection(>=0)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collection)]];
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
    return titleArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 60);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 15, 5, 15);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentity forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    [cell setName:titleArray[indexPath.row]];
    
//    cell.highlighted
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LOGINFO(@"select at section %d, row %d", indexPath.section, indexPath.row);

    MenuType tag = indexPath.row;
    switch (tag) {
        case AutoLayerTag:{
            AutoLayerViewController* ctl = [[AutoLayerViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case CameraTag:{
            CameraViewController* ctl = [[CameraViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case CoreImageFilterTag:{
            CoreImageFilterViewController* ctl = [[CoreImageFilterViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case CoreGraphicsTag:{
            CoreGraphicsViewController* ctl = [[CoreGraphicsViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case MapAndLocationTag:{
            MapAndLocationViewController* ctl = [[MapAndLocationViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case NaviBarTag:{
            NaviBarViewController* ctl = [[NaviBarViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case TransformTag:{
            TransformViewController* ctl = [[TransformViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case ScrollViewCycleTag:{
            ScrollViewCycleController* ctl = [[ScrollViewCycleController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case VideoToolTag:{
            VideoToolViewController* ctl = [[VideoToolViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case WebViewTag:{
            WebViewViewController* ctl = [[WebViewViewController alloc]init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case RefreshTag:{
            RefreshViewController* ctl = [[RefreshViewController alloc]init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case QRCodeTag:{
            QRCodeViewController* ctl = [[QRCodeViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case SendMessageAndEMailTag:{
            SendMessageAndEMailViewController* ctl = [[SendMessageAndEMailViewController alloc]init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case CustomAlertTag:{
            CustomAlertViewController* ctl = [[CustomAlertViewController alloc]init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
            
        case CustomSegmentTag: {
            CustomSegmentViewController* ctl = [[CustomSegmentViewController alloc]init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case TextAttributeTag: {
            TextAttributeViewController* ctl = [[TextAttributeViewController alloc]init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case CollectionViewTag: {
            CollectionViewViewController* ctl = [[CollectionViewViewController alloc]init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
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


