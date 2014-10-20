//
//  AutoLayerViewController.h
//  UINavgationController
//
//  Created by xsw on 14-10-20.
//  Copyright (c) 2014年 niexin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AutoLayerViewController : BaseViewController{
    UIButton *_urlBtn;
    
    UIButton *_urlEntryFeature;
    
    
}

@property(nonatomic,strong)UITextField *passWordField;
@property(nonatomic,strong)UITextField *nameField;
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)UILabel *passWordLabel;

@end
