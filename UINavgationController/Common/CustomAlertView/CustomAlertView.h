//
//  InputAlertView.h
//  testUrl
//
//  Created by xsw on 14/11/4.
//  Copyright (c) 2014年 fdcz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAlertView.h"

typedef enum : NSUInteger {
    CustomAlertViewTypeDefault,
    CustomAlertViewTypePlainTextInput,
    CustomAlertViewTypeSecureTextInput,
    CustomAlertViewTypeLoginAndPasswordInput,
} CustomAlertViewType;

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
@property(nonatomic, strong)    NSString*                       title;
@property(nonatomic, strong)    NSString*                       message;

@property(nonatomic,readonly,getter=isVisible) BOOL visible;


-(instancetype)initWithTitle:(NSString*)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

-(void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex;

@end

@protocol CustomAlertViewDelegate <NSObject>
@required

@optional
- (void)customAlertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end





