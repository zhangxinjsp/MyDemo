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
#import "DrawRectViewController.h"
#import "MapAndLocationViewController.h"
#import "NaviBarViewController.h"
#import "TransformViewController.h"
#import "ScrollViewCycleController.h"
#import "VideoToolViewController.h"
#import "WebViewViewController.h"
#import "RefreshViewController.h"
#import "QRCodeViewController.h"
#import "SendMessageAndEMailViewController.h"
#import "CustomControlsViewController.h"


#define CellIdentity @"identity"

@interface MyCollectionViewCell :UICollectionViewCell {
    
    UIImageView* imageView;
    UILabel* label;
}

- (void)setName:(NSString*)name;
@end


@implementation MyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initControls];
    }
    return self;
}

- (void)initControls {
    self.contentView.layer.masksToBounds = YES;
    
    imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:@"logo.png"];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:imageView];
    
    label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:11];
    label.numberOfLines = 2;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:label];
    
    NSDictionary* viewDict = NSDictionaryOfVariableBindings(imageView, label);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView(>=0)]-3-[label(>=0)]-0-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView(>=0)]-0-|" options:0 metrics:nil views:viewDict]];
}

- (void)setName:(NSString*)name {
    label.text = name;
}


@end


typedef NS_ENUM(NSInteger, MenuType) {
    AutoLayerTag,
    CameraTag,
    CoreImageFilterTag,
    DrawRectTag,
    MapAndLocationTag,
    NaviBarTag,
    TransformTag,
    ScrollViewCycleTag,
    VideoToolTag,
    WebViewTag,
    RefreshTag,
    QRCodeTag,
    SendMessageAndEMailTag,
    CustomControlsTag
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
    
    titleArray = [[NSArray alloc]initWithObjects:@"Auto Layer", @"camera", @"filter", @"drawrect", @"map,location", @"naviBar", @"transform", @"scroll", @"videoTool", @"webView", @"下拉刷新", @"QRCode", @"短信和邮件", @"customControl", nil];
    
    
    UICollectionViewFlowLayout* collectionLayout = [[UICollectionViewFlowLayout alloc]init];
//与下面的代理的返回值有相同的效果
//    collectionLayout.minimumLineSpacing = 30;
//    collectionLayout.minimumInteritemSpacing = 30;
//    collectionLayout.itemSize = CGSizeMake(50, 50);
    
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
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LOGINFO(@"select at section %d, row %d", indexPath.section, indexPath.row);

    NSInteger tag = indexPath.row;
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
        case DrawRectTag:{
            DrawRectViewController* ctl = [[DrawRectViewController alloc] init];
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
        case CustomControlsTag:{
            CustomControlsViewController* ctl = [[CustomControlsViewController alloc]init];
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
