//
//  SixthViewController.h
//  UINavgationController
//
//  Created by zhangxin on 12-11-16.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshHeadView.h"
#import "TestViewController.h"
#import "BaseViewController.h"

@interface RefreshViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,RefreshHeadViewProtocol>{
    UITableView* tableview;
    RefreshHeadView* refreshView;
    NSInteger index;
}
@property(nonatomic ,strong) UITableView* tableview;
@end
