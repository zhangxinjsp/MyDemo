//
//  InputAlertView.h
//  testUrl
//
//  Created by xsw on 14/11/4.
//  Copyright (c) 2014年 fdcz. All rights reserved.
/*
 CustomAlertView 不能在UIAlertView的AlertView: clickedButtonAtIndex:方法中调用
 
 
 
 */

#import <UIKit/UIKit.h>
#import "CAlertView.h"

typedef enum : NSUInteger {
    CustomAlertViewTypeDefault = 0,
    CustomAlertViewTypeSecureTextInput,
    CustomAlertViewTypePlainTextInput,
    CustomAlertViewTypeLoginAndPasswordInput,
} CustomAlertViewType;

typedef enum{
    AlertActionUserActionPrompt   = 3000,     // 用户操作提示
    AlertActionSessionTimeOut     = 3001,     // seesion过期
    AlertActionHttpTimeOut        = 3002,     // http超时
    AlertActionMemErrorPrompt     = 3003,     // 中间件错误码
    AlertActionDefault            = 4000,
}CustomAlertActionType;

@protocol CustomAlertViewDelegate;

@interface CustomAlertView : UIView{
    UILabel* titleLabel;
    UILabel* messageLabel;
    UIButton* cancelButton;
    UIButton* otherButton1;
    UIButton* otherButton2;
    UIButton* otherButton3;
    UIButton* otherButton4;
    UITextField* m_textField1;
    UITextField* m_textField2;
    CAlertView* m_cAlertView;
}
@property(nonatomic, assign)    id<CustomAlertViewDelegate>     delegate;
@property(nonatomic)            CustomAlertViewType              alertType;
@property(nonatomic)            CustomAlertActionType            alertActionType;
@property(nonatomic, strong)    NSString*                       title;
@property(nonatomic, strong)    NSString*                       message;

@property(nonatomic,readonly,getter=isVisible) BOOL visible;//当前视图上显示的alert为yes 其他的为no


-(instancetype)initWithTitle:(NSString*)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

-(void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex;
/*
 判断customalert是否已经展示，展示是指customalert show了之后还没有dismiss的alert，（被其他的alert挤到后面的也算show）
 */
+ (BOOL)checkCustomAlertIsShowWithTag:(NSInteger)tag;

+ (void)dismissAllCustomAlert;
+ (void)dismissCustomAlertWithDelegate:(id)delegate;
+ (BOOL)hasCustomAlertShow;

@end

@protocol CustomAlertViewDelegate <NSObject>
@required

@optional

@optional
- (void)customAlertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;


@end





