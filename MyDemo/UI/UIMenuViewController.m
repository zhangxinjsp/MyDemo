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
    
    titleArray = [[NSArray alloc]initWithObjects:@"Auto Layer", @"camera", @"filter", @"CoreGraphics", @"map,location", @"naviBar", @"transform", @"scroll", @"videoTool", @"webView", @"下拉刷新", @"QRCode", @"短信和邮件", @"alert", @"segment", @"TextAttribute", nil];
    
    
    UICollectionViewFlowLayout* collectionLayout = [[UICollectionViewFlowLayout alloc]init];
//    CollectionViewLayout* collectionLayout = [[CollectionViewLayout alloc]init];
//与下面的代理的返回值有相同的效果
//    collectionLayout.minimumLineSpacing = 30;
//    collectionLayout.minimumInteritemSpacing = 30;
//    collectionLayout.itemSize = CGSizeMake(50, 50);
    
    collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:collectionLayout];
    [collection registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:CellIdentity];
//    [collection registerClass:<#(nullable Class)#> forSupplementaryViewOfKind:<#(nonnull NSString *)#> withReuseIdentifier:<#(nonnull NSString *)#>]
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

@implementation CollectionViewLayout

/**
 * 该方法是预加载layout, 只会被执行一次
 */
- (void)prepareLayout{
    [super prepareLayout];
    
    [self initData];
    
    [self initCellWidth];
    
    [self initCellHeight];
    
}

/**
 * 该方法返回CollectionView的ContentSize的大小
 */
- (CGSize)collectionViewContentSize {
    CGFloat height = [self maxCellYArrayWithArray:_cellYArray];
    return CGSizeMake(320, height);
}

/**
 * 该方法为每个Cell绑定一个Layout属性~
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    [self initCellYArray];
    
    NSMutableArray *array = [NSMutableArray array];
    
    //add cells
    for (int i = 0; i < _numberOfCellsInSections; i ++ ) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [array addObject:attributes];
    }
    return array;
}

/**
 * 该方法为每个Cell绑定一个Layout属性~
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect frame = CGRectZero;
    
    CGFloat cellHeight = [_cellHeightArray[indexPath.row] floatValue];
    
    NSInteger minYIndex = [self minCellYArrayWithArray:_cellYArray];
    
    CGFloat tempX = [_cellXArray[minYIndex] floatValue];
    
    CGFloat tempY = [_cellYArray[minYIndex] floatValue];
    
    frame = CGRectMake(tempX, tempY, _cellWidth, cellHeight);
    NSLog(@"%f:%f", tempX, tempY);
    //更新相应的Y坐标
    _cellYArray[minYIndex] = @(tempY + cellHeight + _padding);
    
    //计算每个Cell的位置
    attributes.frame = frame;
    
    return attributes;
}

/**
 * 初始化相关数据
 */
- (void) initData{
    _numberOfSections = [self.collectionView numberOfSections];
    _numberOfCellsInSections = [self.collectionView numberOfItemsInSection:0];
    
    //通过回调获取列数
    _columnCount = 5;
    _padding = 5;
    _cellMinHeight = 50;
    _cellMaxHeight = 150;
}

/**
 * 根据Cell的列数求出Cell的宽度
 */
- (void) initCellWidth{
    //计算每个Cell的宽度
    _cellWidth = (320 - (_columnCount +1) * _padding) / _columnCount;
    
    //为每个Cell计算X坐标
    _cellXArray = [[NSMutableArray alloc] initWithCapacity:_columnCount];
    for (int i = 0; i < _columnCount; i ++  ) {
        
        CGFloat tempX = i * (_cellWidth + _padding) + _padding;
        
        [_cellXArray addObject:@(tempX)];
    }
}

/**
 * 随机生成Cell的高度
 */
- (void) initCellHeight{
    //随机生成Cell的高度
    _cellHeightArray = [[NSMutableArray alloc] initWithCapacity:_numberOfCellsInSections];
    for (int i = 0; i < _numberOfCellsInSections; i ++ ) {
        
        CGFloat cellHeight = arc4random() % (_cellMaxHeight - _cellMinHeight) + _cellMinHeight;
        
        [_cellHeightArray addObject:@(cellHeight)];
    }
}

/**
 * 初始化每列Cell的Y轴坐标
 */
- (void) initCellYArray{
    _cellYArray = [[NSMutableArray alloc] initWithCapacity:_columnCount];
    
    for (int i = 0; i < _columnCount; i ++ ) {
        [_cellYArray addObject:@(_padding)];
    }
}

/**
 * 求CellY数组中的最大值并返回
 */
- (CGFloat) maxCellYArrayWithArray: (NSMutableArray *) array{
    if (array.count == 0) {
        return 0.0f;
    }
    
    CGFloat max = [array[0] floatValue];
    for (NSNumber *number in array) {
        
        CGFloat temp = [number floatValue];
        
        if (max <= temp) {
            max = temp;
        }
    }
    
    return max;
}

/**
 * 求CellY数组中的最小值的索引
 */
- (CGFloat) minCellYArrayWithArray: (NSMutableArray *) array{
    
    if (array.count == 0) {
        return 0.0f;
    }
    
    NSInteger minIndex = 0;
    CGFloat min = [array[0] floatValue];
    
    for (int i = 0; i < _columnCount; i++ ) {
        CGFloat temp = [array[i] floatValue];
        
        if (min > temp) {
            min = temp;
            minIndex = i;
        }
    }
    
    return minIndex;
}




@end

