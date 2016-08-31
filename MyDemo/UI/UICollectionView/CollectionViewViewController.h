//
//  CollectionViewViewController.h
//  MyDemo
//
//  Created by 张鑫 on 16/8/30.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "BaseViewController.h"

@interface CollectionViewViewController : BaseViewController

@end


@interface MyCollectionViewCell :UICollectionViewCell {
    
    UIImageView* imageView;
    UILabel* label;
}

- (void)setName:(NSString*)name;

@end


@interface CollectionViewFlowLayout :UICollectionViewFlowLayout {
    
    
}

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
