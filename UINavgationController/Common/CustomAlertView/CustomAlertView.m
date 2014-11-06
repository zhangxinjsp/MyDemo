//
//  InputAlertView.m
//  testUrl
//
//  Created by xsw on 14/11/4.
//  Copyright (c) 2014年 fdcz. All rights reserved.
//


#define ALERT_LEFT_GAP              25

#define BUTTON_HEIGHT               43
#define TEXTFIELD_HEIGHT            25
#define LEFT_GAP_WIDTH              17
#define TOP_GAP_HEIGHT              20
#define MESSAGE_GAP_HEIGHT          5
#define TEXTFIELD_GAP_HEIGHT        10
#define BUTTON_GAP_HEIGHT           20


#define GAP_HEIGHT                  10

#define TITLE_FONT                  [UIFont boldSystemFontOfSize:16]
#define MESSAGE_FONT                [UIFont systemFontOfSize:13]
#define BUTTON_FONT                 [UIFont systemFontOfSize:16]
#define TEXTFIELD_FONT              [UIFont systemFontOfSize:14]

#define MAX_OTHER_BTN_COUNT         4

#define POP_ALL_ALERT_NOTIFUCATION_NAME         @"POP_ALL_CUSTOM_ALERT_VIEW"

#import "CustomAlertView.h"

@interface CustomAlertStack : NSObject{
    NSMutableArray* alertList;
}

@property (nonatomic, strong, readonly) NSMutableArray* alertList;
+(instancetype)sharedInstance;

-(void)pushCustomAlertView:(CustomAlertView*)alertView;
-(void)popCustomAlertView;

@end

@implementation CustomAlertStack

@synthesize alertList;

+(instancetype)sharedInstance{
    static CustomAlertStack *instance;
    if (instance == nil) {
        @synchronized(self){//同步块
            if (instance == nil) {
                instance= [[CustomAlertStack alloc] init];
            }
        }
    }
    return instance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        alertList = [[NSMutableArray alloc]init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popAllCustomAlertView) name:POP_ALL_ALERT_NOTIFUCATION_NAME object:nil];
    }
    return self;
}

-(void)pushCustomAlertView:(CustomAlertView *)alertView{
    @synchronized(self){
        if (self.alertList.count > 0) {
            CustomAlertView* currentShowAlert = self.alertList.firstObject;
            if ([currentShowAlert respondsToSelector:@selector(temporaryDismiss)]) {
                [currentShowAlert performSelector:@selector(temporaryDismiss)];
            }
        }
        [self.alertList insertObject:alertView atIndex:0];
    }
}

-(void)popCustomAlertView{
    @synchronized(self){
        @try {
            [self.alertList removeObjectAtIndex:0];
        }
        @catch (NSException *exception) {
            LOGINFO(@"%@", exception);
        }
        if (self.alertList.count > 0) {
            CustomAlertView* currentShowAlert = self.alertList.firstObject;
            [currentShowAlert show];
        }
    }
}

-(void)popAllCustomAlertView{
    @synchronized(self){
        if (self.alertList.count > 0) {
            CustomAlertView* currentShowAlert = self.alertList.firstObject;
            if ([currentShowAlert respondsToSelector:@selector(temporaryDismiss)]) {
                [currentShowAlert performSelector:@selector(temporaryDismiss)];
            }
        }
        [self.alertList removeAllObjects];
    }
}

@end



@interface CustomAlertView(){
    CGFloat             titleHeight;
    CGFloat             messageHeight;
    NSMutableArray*     otherBtnTitles;
    NSString*           cancelTitle;
}

@end


@implementation CustomAlertView

@synthesize delegate;
@synthesize alertType;
@synthesize title;
@synthesize message;
@synthesize visible;

-(instancetype)initWithTitle:(NSString*)_title message:(NSString *)_message delegate:(id)_delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    self.title = _title;
    self.message = _message;
    cancelTitle = cancelButtonTitle;
    
    if (otherButtonTitles != nil) {
        otherBtnTitles = [[NSMutableArray alloc]initWithObjects:otherButtonTitles, nil];
        id sender;
        va_list ap;
        va_start(ap, otherButtonTitles);
        while ((sender = va_arg(ap, id))) {
            if ([sender isKindOfClass:[NSString class]]) {
                [otherBtnTitles addObject:sender];
                if (otherBtnTitles.count >= MAX_OTHER_BTN_COUNT) {
                    break;
                }
            }
        }
    }

    titleHeight = [self stringHeight:title font:TITLE_FONT];
    messageHeight = [self stringHeight:message font:MESSAGE_FONT];
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
        self.delegate = _delegate;
        [self initControls];
        self.alertType = CustomAlertViewTypeDefault;
    }
    return self;
}

-(void)initControls{
    titleLabel = [[UILabel alloc]init];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = TITLE_FONT;
    titleLabel.text = title;
    
    messageLabel = [[UILabel alloc]init];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = MESSAGE_FONT;
    messageLabel.text = message;
    
    UIColor* btnTitleColor = [UIColor colorWithRed:12.0/255.0f green:96.0/255.0f blue:253.0/255.0f alpha:1.0];
    UIImage* btnBGImage = [[UIImage imageNamed:@"customAlertButtonBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4) ];
    cancelButton = [[UIButton alloc]init];
    cancelButton.tag = 0;
    cancelButton.titleLabel.font = BUTTON_FONT;
    [cancelButton setTitleColor:btnTitleColor forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:btnBGImage forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(buttonActions:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:cancelTitle forState:UIControlStateNormal];

    otherButton1 = [[UIButton alloc]init];
    otherButton1.tag = 1;
    otherButton1.titleLabel.font = BUTTON_FONT;
    [otherButton1 setTitleColor:btnTitleColor forState:UIControlStateNormal];
    [otherButton1 setBackgroundImage:btnBGImage forState:UIControlStateNormal];
    [otherButton1 addTarget:self action:@selector(buttonActions:) forControlEvents:UIControlEventTouchUpInside];

    otherButton2 = [[UIButton alloc]init];
    otherButton2.tag = 2;
    otherButton2.titleLabel.font = BUTTON_FONT;
    [otherButton2 setTitleColor:btnTitleColor forState:UIControlStateNormal];
    [otherButton2 setBackgroundImage:btnBGImage forState:UIControlStateNormal];
    [otherButton2 addTarget:self action:@selector(buttonActions:) forControlEvents:UIControlEventTouchUpInside];

    otherButton3 = [[UIButton alloc]init];
    otherButton3.tag = 3;
    otherButton3.titleLabel.font = BUTTON_FONT;
    [otherButton3 setTitleColor:btnTitleColor forState:UIControlStateNormal];
    [otherButton3 setBackgroundImage:btnBGImage forState:UIControlStateNormal];
    [otherButton3 addTarget:self action:@selector(buttonActions:) forControlEvents:UIControlEventTouchUpInside];

    otherButton4 = [[UIButton alloc]init];
    otherButton4.tag = 4;
    otherButton4.titleLabel.font = BUTTON_FONT;
    [otherButton4 setTitleColor:btnTitleColor forState:UIControlStateNormal];
    [otherButton4 setBackgroundImage:btnBGImage forState:UIControlStateNormal];
    [otherButton4 addTarget:self action:@selector(buttonActions:) forControlEvents:UIControlEventTouchUpInside];

    m_textField1 = [[UITextField alloc]init];
    m_textField1.font = TEXTFIELD_FONT;
    m_textField1.borderStyle = UITextBorderStyleNone;
    m_textField1.layer.borderWidth = 0.5;
    m_textField1.layer.borderColor = [[UIColor colorWithWhite:0.2 alpha:1]CGColor];
    m_textField1.secureTextEntry = NO;
    
    m_textField2 = [[UITextField alloc]init];
    m_textField2.font = TEXTFIELD_FONT;
    m_textField2.borderStyle = UITextBorderStyleNone;
    m_textField2.layer.borderWidth = 0.5;
    m_textField2.layer.borderColor = [[UIColor colorWithWhite:0.2 alpha:1]CGColor];
    m_textField2.secureTextEntry = YES;
}

-(void)setAlertType:(CustomAlertViewType)_alertType{
    alertType = _alertType;
    [self addUsingControls];
    [self manageUsingAutoLayoutControls];
    [self layoutControlsV];
}

-(void)addUsingControls{
    [self addSubview:titleLabel];

    if (self.message.length > 0) {
        [self addSubview:messageLabel];
    }
    if (alertType == CustomAlertViewTypePlainTextInput || alertType == CustomAlertViewTypeSecureTextInput) {
        [self addSubview:m_textField1];
        [m_textField1 setSecureTextEntry:(alertType == CustomAlertViewTypeSecureTextInput)];
    } else if (alertType == CustomAlertViewTypeLoginAndPasswordInput) {
        [self addSubview:m_textField1];
        [self addSubview:m_textField2];
    }
    if (otherBtnTitles.count == 1) {
        UIImage* btnBGImage = [[UIImage imageNamed:@"customAlertButtonBG_cancel.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4) ];
        [cancelButton setBackgroundImage:btnBGImage forState:UIControlStateNormal];
    }
    [self addSubview:cancelButton];
    
    switch (otherBtnTitles.count) {
        case 4:{
            [self addSubview:otherButton4];
        }
        case 3:{
            [self addSubview:otherButton3];
        }
        case 2:{
            [self addSubview:otherButton2];
        }
        case 1:{
            [self addSubview:otherButton1];
        }
            break;
            
        default:
            break;
    }
}

-(void)manageUsingAutoLayoutControls{
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [messageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cancelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [otherButton1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [otherButton2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [otherButton3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [otherButton4 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [m_textField1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [m_textField2 setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)layoutControlsV{
    [self removeConstraints:[self constraints]];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(titleLabel, messageLabel, cancelButton, m_textField1, m_textField2, otherButton1, otherButton2, otherButton3, otherButton4);
    
    NSDictionary* metricsDictH = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithFloat:LEFT_GAP_WIDTH], @"leftGap", nil];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftGap)-[titleLabel(>=50)]-(leftGap)-|" options:0 metrics:metricsDictH views:views]];
    
    NSMutableDictionary* metricsDict = [[NSMutableDictionary alloc]init];
    
    
    [metricsDict setObject:[NSNumber numberWithFloat:TOP_GAP_HEIGHT] forKey:@"topGap"];
    
    [metricsDict setObject:[NSNumber numberWithFloat:titleHeight] forKey:@"titleHeight"];
    
    if (self.title.length == 0) {
        [metricsDict setObject:[NSNumber numberWithFloat:0.001] forKey:@"messageGap"];
    }else{
        [metricsDict setObject:[NSNumber numberWithFloat:MESSAGE_GAP_HEIGHT] forKey:@"messageGap"];
    }
    
    [metricsDict setObject:[NSNumber numberWithFloat:messageHeight] forKey:@"messageHeight"];
    
    [metricsDict setObject:[NSNumber numberWithFloat:TEXTFIELD_GAP_HEIGHT] forKey:@"textFieldGap"];
    [metricsDict setObject:[NSNumber numberWithFloat:TEXTFIELD_HEIGHT] forKey:@"textFieldHeight"];
    
    [metricsDict setObject:[NSNumber numberWithFloat:BUTTON_GAP_HEIGHT] forKey:@"cancelBtnGap"];
    [metricsDict setObject:[NSNumber numberWithFloat:BUTTON_HEIGHT] forKey:@"cancelBtnHeight"];
    
    [self setOtherButtonTitles];
    
    NSString* formatStr = [self createFormateString];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatStr options:0 metrics:metricsDict views:views]];
    
    
    if (otherBtnTitles.count == 1){
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[cancelButton(>=50)]-(0)-[otherButton1(cancelButton)]-(0)-|" options:0 metrics:nil views:views]];
    }else{
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[cancelButton(>=50)]-(0)-|" options:0 metrics:nil views:views]];
    }
    [self layoutControlsH];
    
    [self setSelfFrame];
}

-(NSString*)createFormateString{
    NSString* str = @"V:|-";
    str = [str stringByAppendingString:@"(topGap)-[titleLabel(titleHeight)]-"];

    if (self.message.length > 0) {
        str = [str stringByAppendingString:@"(messageGap)-[messageLabel(messageHeight)]-"];
    }
    if (alertType == CustomAlertViewTypePlainTextInput || alertType == CustomAlertViewTypeSecureTextInput) {
        str = [str stringByAppendingString:@"(textFieldGap)-[m_textField1(textFieldHeight)]-"];
    } else if (alertType == CustomAlertViewTypeLoginAndPasswordInput) {
        str = [str stringByAppendingString:@"(textFieldGap)-[m_textField1(textFieldHeight)]-"];
        str = [str stringByAppendingString:@"(0)-[m_textField2(textFieldHeight)]-"];
    }
    
    if (otherBtnTitles.count <= 1) {
        str = [str stringByAppendingString:@"(cancelBtnGap)-[cancelButton(cancelBtnHeight)]-"];
    }
    
    switch (otherBtnTitles.count) {
        case 2:{
            str = [str stringByAppendingString:@"(cancelBtnGap)-[otherButton1(cancelButton)]-"];
            str = [str stringByAppendingString:@"(0)-[otherButton2(cancelButton)]-"];
            str = [str stringByAppendingString:@"(0)-[cancelButton(cancelBtnHeight)]-"];
        }
            break;
        case 3:{
            str = [str stringByAppendingString:@"(cancelBtnGap)-[otherButton1(cancelButton)]-"];
            str = [str stringByAppendingString:@"(0)-[otherButton2(cancelButton)]-"];
            str = [str stringByAppendingString:@"(0)-[otherButton3(cancelButton)]-"];
            str = [str stringByAppendingString:@"(0)-[cancelButton(cancelBtnHeight)]-"];
        }
            break;
        case 4:{
            str = [str stringByAppendingString:@"(cancelBtnGap)-[otherButton1(cancelButton)]-"];
            str = [str stringByAppendingString:@"(0)-[otherButton2(cancelButton)]-"];
            str = [str stringByAppendingString:@"(0)-[otherButton3(cancelButton)]-"];
            str = [str stringByAppendingString:@"(0)-[otherButton4(cancelButton)]-"];
            str = [str stringByAppendingString:@"(0)-[cancelButton(cancelBtnHeight)]-"];
        }
            break;
        default:
            break;
    }
    str = [str stringByAppendingString:@"(0)-|"];
    return str;
}

-(void)layoutControlsH{
    if (self.message.length > 0) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    }
    
    if (alertType == CustomAlertViewTypePlainTextInput || alertType == CustomAlertViewTypeSecureTextInput) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:m_textField1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:m_textField1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
    } else if (alertType == CustomAlertViewTypeLoginAndPasswordInput) {
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:m_textField1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:m_textField1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:m_textField2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:m_textField2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    }
    if (otherBtnTitles.count == 1) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:otherButton1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cancelButton attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:otherButton1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cancelButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    }else if (otherBtnTitles.count > 1){
        switch (otherBtnTitles.count) {
            case 4:{
                [self addConstraint:[NSLayoutConstraint constraintWithItem:otherButton4 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cancelButton attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                
                [self addConstraint:[NSLayoutConstraint constraintWithItem:otherButton4 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cancelButton attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
            }
            case 3:{
                [self addConstraint:[NSLayoutConstraint constraintWithItem:otherButton3 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cancelButton attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                
                [self addConstraint:[NSLayoutConstraint constraintWithItem:otherButton3 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cancelButton attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
            }
            case 2:{
                [self addConstraint:[NSLayoutConstraint constraintWithItem:otherButton2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cancelButton attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                
                [self addConstraint:[NSLayoutConstraint constraintWithItem:otherButton2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cancelButton attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
                
                [self addConstraint:[NSLayoutConstraint constraintWithItem:otherButton1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cancelButton attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                
                [self addConstraint:[NSLayoutConstraint constraintWithItem:otherButton1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cancelButton attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
            }
                break;
            default:
                break;
        }
    }

}

-(void)setSelfFrame{
    CGFloat totalHeight = TOP_GAP_HEIGHT;
    
    if (self.title.length > 0) {
        totalHeight += titleHeight;
    }
    if (self.message.length > 0) {
        totalHeight += messageHeight;
    }
    if (alertType == CustomAlertViewTypePlainTextInput || alertType == CustomAlertViewTypeSecureTextInput) {
        totalHeight += (TEXTFIELD_HEIGHT + TEXTFIELD_GAP_HEIGHT);
    } else if (alertType == CustomAlertViewTypeLoginAndPasswordInput) {
        totalHeight += (TEXTFIELD_HEIGHT + TEXTFIELD_GAP_HEIGHT) * 2;
    }
    
    totalHeight += BUTTON_GAP_HEIGHT + BUTTON_HEIGHT;
    
    if (otherBtnTitles.count > 1) {
        totalHeight += BUTTON_HEIGHT * otherBtnTitles.count;
    }
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    self.frame = CGRectMake(0, 0, 320 - ALERT_LEFT_GAP * 2, totalHeight);
}

-(void)setOtherButtonTitles{
    switch (otherBtnTitles.count) {
        case 4:{
            [otherButton4 setTitle:[otherBtnTitles objectAtIndex:3] forState:UIControlStateNormal];
            [self addSubview:otherButton4];
        }
        case 3:{
            [otherButton3 setTitle:[otherBtnTitles objectAtIndex:2] forState:UIControlStateNormal];
            [self addSubview:otherButton3];
        }
        case 2:{
            [otherButton2 setTitle:[otherBtnTitles objectAtIndex:1] forState:UIControlStateNormal];
            [self addSubview:otherButton2];
        }
        case 1:{
            [otherButton1 setTitle:[otherBtnTitles objectAtIndex:0] forState:UIControlStateNormal];
            [self addSubview:otherButton1];
        }
            break;
            
        default:
            break;
    }
}



-(CGFloat)stringHeight:(NSString*)string font:(UIFont*)font{
    if (string.length == 0) {
        return 1;
    }
    CGSize strsize = [string sizeWithFont:font constrainedToSize:CGSizeMake(320 - (LEFT_GAP_WIDTH + ALERT_LEFT_GAP) * 2, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return strsize.height + 1;
}

-(BOOL)isVisible{
    return visible;
}

-(UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex{
    if (textFieldIndex == 0 && (alertType != CustomAlertViewTypeDefault)) {
        return m_textField1;
    }else if (textFieldIndex == 1 && (alertType == CustomAlertViewTypeLoginAndPasswordInput)){
        return m_textField2;
    }
    return nil;
}

-(void)buttonActions:(id)sender{
    NSInteger tag = ((UIButton*)sender).tag;
    [self dismissWithClickedButtonIndex:tag animated:YES];
}

-(void)show{
    if (m_cAlertView == nil) {
        m_cAlertView = [[CAlertView alloc]initWithAlertView:self andAnimationType:AlertAnimationType];
        [[CustomAlertStack sharedInstance]pushCustomAlertView:self];
    }
    [m_cAlertView show];
    visible = YES;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated{
    [m_cAlertView dismissAlertView];
    [[CustomAlertStack sharedInstance]popCustomAlertView];
    visible = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)]) {
        [self.delegate customAlertView:self clickedButtonAtIndex:buttonIndex];
    }
}


//私有方法
-(void)temporaryDismiss{
    visible = NO;
    [m_cAlertView dismissAlertView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
