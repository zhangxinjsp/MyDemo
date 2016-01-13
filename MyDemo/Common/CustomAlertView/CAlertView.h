/*************************************************
 Copyright © Huawei Technologies Co., Ltd. 2011-2012. All rights reserved.  
 File name: CAlertView.h
 Author: xu_chuanyong ID:      Version:       Date:2012/02/12
 Description: 自定义弹出框类
 Others:
 History:
 *************************************************/

#import <UIKit/UIKit.h>

typedef enum {
    AlertAnimationType,
    NaviAnimationType,
    NoneAnimationType
}AnimationType;

@interface CAlertView : UIView <UITextFieldDelegate>{
    UIView *m_AlertView;
    UIControl *m_AlertSuperView;
    CGFloat backAlpha;
    CGFloat kTransitionDuration;
    BOOL    isBackPress;
    AnimationType mType;
}
@property BOOL    isBackPress;
@property CGFloat backAlpha;
@property CGFloat kTransitionDuration;
@property (retain,nonatomic) UIView *m_AlertView;

- (id)initWithAlertView:(UIView*)alertView andAnimationType:(AnimationType)aType;
- (void)show;
- (void)dismissAlertView;
- (void)backPress;@end
