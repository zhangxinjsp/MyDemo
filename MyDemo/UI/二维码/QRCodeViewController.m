//
//  ZXingViewController.m
//  UINavgationController
//
//  Created by 张鑫 on 14/12/15.
//  Copyright (c) 2014年 zhangxin. All rights reserved.
//

#import "QRCodeViewController.h"


@interface QRCodeViewController ()<UITextFieldDelegate>{
    UIImageView* imageView;
    UIButton* makeQRCodeBtn;
    
    UIButton* scanQRCodeBtn;
    UIButton* readAlbumsQRCodeBtn;
    UIButton* catchQRCodeBtn;
    UITextField* textField;
    UILabel* label;
    
}

@end

@implementation QRCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControls];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)initControls{
    textField = [[UITextField alloc]init];
    textField.backgroundColor = [UIColor lightGrayColor];
    textField.delegate = self;
    textField.placeholder = @"输入生成二维码的内容";
    textField.text = @"zhangxin张鑫";
    textField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textField];
    
    makeQRCodeBtn = [[UIButton alloc]init];
    makeQRCodeBtn.backgroundColor = [UIColor lightGrayColor];
    [makeQRCodeBtn setTitle:@"生成二维码" forState:UIControlStateNormal];
    [makeQRCodeBtn addTarget:self action:@selector(makeQRCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:makeQRCodeBtn];
    
    scanQRCodeBtn = [[UIButton alloc]init];
    scanQRCodeBtn.backgroundColor = [UIColor lightGrayColor];
    [scanQRCodeBtn setTitle:@"扫描二维码" forState:UIControlStateNormal];
    [scanQRCodeBtn addTarget:self action:@selector(scanQRCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanQRCodeBtn];
    
    readAlbumsQRCodeBtn = [[UIButton alloc]init];
    readAlbumsQRCodeBtn.backgroundColor = [UIColor lightGrayColor];
    [readAlbumsQRCodeBtn setTitle:@"相册二维码" forState:UIControlStateNormal];
    [readAlbumsQRCodeBtn addTarget:self action:@selector(readFromAlbums) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:readAlbumsQRCodeBtn];
    
    catchQRCodeBtn = [[UIButton alloc]init];
    catchQRCodeBtn.backgroundColor = [UIColor lightGrayColor];
    [catchQRCodeBtn setTitle:@"捕获二维码" forState:UIControlStateNormal];
    [catchQRCodeBtn addTarget:self action:@selector(catchQRCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:catchQRCodeBtn];
    
    imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:imageView];
    
    label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor lightGrayColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scanQRCodeBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [makeQRCodeBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [readAlbumsQRCodeBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [catchQRCodeBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    
    NSDictionary* viewsDict = NSDictionaryOfVariableBindings(textField, makeQRCodeBtn, scanQRCodeBtn, readAlbumsQRCodeBtn, catchQRCodeBtn, imageView, label);
    
    NSDictionary* metricsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:30], @"height", nil];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[textField(==height)]-10-[makeQRCodeBtn(height)]-10-[imageView(150)]-10-[label(>=height)]-10-|" options:NSLayoutFormatAlignAllLeft metrics:metricsDict views:viewsDict]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[textField(>=0)]-10-|" options:NSLayoutFormatAlignAllTop metrics:metricsDict views:viewsDict]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[makeQRCodeBtn(>=0)]-10-[scanQRCodeBtn(makeQRCodeBtn)]-10-[readAlbumsQRCodeBtn(makeQRCodeBtn)]-10-[catchQRCodeBtn(makeQRCodeBtn)]-10-|" options:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom metrics:metricsDict views:viewsDict]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:textField attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
}

#pragma mark －－－－－－－－－－－－－－－生成二维码－－－－－－－－－－

-(void)makeQRCode{

}

-(UIImage *)addSubImage:(UIImage *)img sub:(UIImage *) subImage
{
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    int subWidth = subImage.size.width;
    int subHeight = subImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextDrawImage(context, CGRectMake( (w-subWidth)/2, (h - subHeight)/2, subWidth, subHeight), [subImage CGImage]);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
    //  CGContextDrawImage(contextRef, CGRectMake(100, 50, 200, 80), [smallImg CGImage]);
}

#pragma mark －－－－－－－－－－－－－－－扫描二维码－－－－－－－－－－
//扫描二维码图片
-(void)scanQRCode:(id)sender{
    

}
//从相册中读取二维码图片
- (void)readFromAlbums {
    

}
//捕捉二维码
- (void)catchQRCode {
    
}


# pragma mark ZXcapture 代理方法






-(BOOL)textFieldShouldReturn:(UITextField *)_textField{
    return [_textField resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
