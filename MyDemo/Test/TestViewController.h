//
//  LastViewController.h
//  UINavgationController
//
//  Created by zhangxin on 12-10-26.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"



@interface TestViewController : BaseViewController<UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>{
    
    NSString* webContent;
    
    UITextField* textFields;
    UIButton* btn;
    
    
    
}
@end
