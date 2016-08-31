//
//  CollectionViewViewController.m
//  MyDemo
//
//  Created by 张鑫 on 16/8/30.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "CollectionViewViewController.h"

@interface CollectionViewViewController () <UICollectionViewDelegate, UICollectionViewDataSource> {
    UICollectionView* flowCollection;
    UICollectionView* collection;
}


@end

@implementation CollectionViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
    
    CollectionViewFlowLayout* flowLayout = [[CollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    flowCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [flowCollection registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    flowCollection.delegate = self;
    flowCollection.dataSource = self;
    [flowCollection setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:flowCollection];
    
    CollectionViewLayout* layout = [[CollectionViewLayout alloc]init];
    
    collection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [collection registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    collection.delegate = self;
    collection.dataSource = self;
    [collection setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:collection];
    
    NSDictionary* viewDict = NSDictionaryOfVariableBindings(flowCollection, collection);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[flowCollection(>=0)]-0-|" options:0 metrics:nil views:viewDict]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[flowCollection(==100)]-10-[collection(>=0)]-0-|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:viewDict]];
}

#pragma mark flow layout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    
//}





#pragma mark collection view deletage 







#pragma mark collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    [cell setName:@"11111"];
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    
//}




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

@implementation CollectionViewFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [super layoutAttributesForElementsInRect:rect];
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
}

@end

@implementation CollectionViewLayout

/**
 * 该方法是预加载layout, 只会被执行一次
 */
- (void)prepareLayout{
    [super prepareLayout];
    
    [self initData];
    
    [self initCellYArray];
    
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
 *  数据可以通过delegate的方式或者，初始化方式传参
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

