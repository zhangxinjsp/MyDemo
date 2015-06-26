//
//  RefreshHeadView.h
//  UINavgationController
//
//  Created by zhangxin on 12-11-16.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RefreshHeadViewProtocol <NSObject>
@required
-(void)beginRefresh;
//-(void)endRefresh;

@end


@interface RefreshHeadView : UIView{
    
    UIImageView* imageView;
    UILabel* label1;
    UILabel* label2;
    id<RefreshHeadViewProtocol> refreshDelegate;
}
@property(nonatomic,strong)id<RefreshHeadViewProtocol> refreshDelegate;


-(void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
-(void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

@end
