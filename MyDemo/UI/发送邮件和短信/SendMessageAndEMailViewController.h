//
//  sendMessageAndEMailViewController.h
//  UINavgationController
//
//  Created by zhangxin on 12-12-22.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import<MessageUI/MFMailComposeViewController.h>
#import "TestViewController.h"
#import "BaseViewController.h"

@interface SendMessageAndEMailViewController : BaseViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>{
    
    NSString* address;
    
}

@end
