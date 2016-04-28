//
//  FirstViewController.h
//  UINavgationController
//
//  Created by zhangxin on 12-10-26.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface UIMenuViewController : BaseViewController


@end

@interface MyCollectionViewCell :UICollectionViewCell {
    
    UIImageView* imageView;
    UILabel* label;
}

- (void)setName:(NSString*)name;
@end

@interface CollectionViewLayout :UICollectionViewLayout {
    NSMutableArray* _cellXArray;
    NSMutableArray* _cellYArray;
    NSMutableArray* _cellHeightArray;
    
    
    NSInteger _numberOfSections;
    NSInteger _numberOfCellsInSections;
    
    NSInteger _columnCount;
    NSInteger _padding;
    NSInteger _cellMinHeight;
    NSInteger _cellMaxHeight;
    NSInteger _cellWidth;
    
}

@end