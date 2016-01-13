//
//  FileManagerReadAndWriteViewController.h
//  UINavgationController
//
//  Created by zhangxin on 12-12-20.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LastViewController.h"
#import "BaseViewController.h"

@interface FileManagerReadAndWriteViewController : BaseViewController<UITextFieldDelegate>{
    NSFileManager* fileManager;
    
    UILabel* label;
    
    UITextField* textField1;
    UITextField* textField2;
    UITextField* textField3;
    UITextField* textField4;
    UITextField* textField5;
    UIButton* button1;
    UIButton* button2;
    UIButton* button3;
    UIButton* button4;
    UIButton* button5;
}


@end
