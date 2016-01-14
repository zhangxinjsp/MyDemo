//
//  WHScrollAndPageView.h
//  ChinaExpress
//
//  Created by Perry on 15/8/6.
//  Copyright (c) 2015年 zhangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollCycleViewDelegate;

@interface ScrollCycleView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) id <ScrollCycleViewDelegate> delegate;

@property (nonatomic, strong) NSArray *showItemArray;



- (void)layoutScrollView;

- (void)shouldAutoShow:(BOOL)shouldStart;

@end



@protocol ScrollCycleViewDelegate <NSObject>

@optional

- (void)didSelectAtIndex:(NSInteger)index;

@required

@end