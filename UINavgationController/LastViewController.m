//
//  LastViewController.m
//  UINavgationController
//
//  Created by niexin on 12-10-26.
//  Copyright (c) 2012年 niexin. All rights reserved.
//

#import "LastViewController.h"
#import "UILabel-LineHeigh.h"
#import <AVFoundation/AVFoundation.h>

typedef NSInteger (^TestAnimation)(NSString* str);

@interface LastViewController (){
    
}

@end

@implementation LastViewController

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
    
    self.title = @"last View Controller";
    
    //item按下是会有高亮效果的
    UIToolbar *tools = [[UIToolbar alloc]initWithFrame: CGRectMake(0.0f, 0.0f, 44.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
    tools.clipsToBounds = NO;
    tools.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateNewsBtnPressed:)];
    [tools setItems:[NSArray arrayWithObject:item]];
    UIBarButtonItem *updateBtn = [[UIBarButtonItem alloc]initWithCustomView:tools];
    [self.navigationItem setRightBarButtonItem:updateBtn];
    
    
//    com.huawei.ott.hosting${PRODUCT_NAME:rfc1034identifier}
    
    UITextField* asdf = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 60,30)];
    asdf.backgroundColor = [UIColor redColor];
    [self.view addSubview:asdf];
    
    UIButton* channelBtn = [[UIButton alloc]initWithFrame:CGRectMake(80, 10, 40, 20)];
    [channelBtn setBackgroundImage:[UIImage imageNamed:@"dragDown.png"] forState:UIControlStateNormal];
    [channelBtn setBackgroundImage:[UIImage imageNamed:@"logo.png.png"] forState:UIControlStateHighlighted];
    [channelBtn setBackgroundImage:[UIImage imageNamed:@"dragUp.png"] forState:UIControlStateSelected];
    [channelBtn setBackgroundImage:[UIImage imageNamed:@"paletta_icon.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [channelBtn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [channelBtn setTag:0];
    [self.view addSubview:channelBtn];
    
    UIButton* purchaseBtn = [[UIButton alloc]initWithFrame:CGRectMake(130, 10, 40, 20)];
    [purchaseBtn setBackgroundImage:[UIImage imageNamed:@"dragUp.png"] forState:UIControlStateNormal];
    [purchaseBtn setBackgroundImage:[UIImage imageNamed:@"logo.png.png"] forState:UIControlStateHighlighted];
    [purchaseBtn setBackgroundImage:[UIImage imageNamed:@"dragDown.png"] forState:UIControlStateSelected];
    [purchaseBtn setBackgroundImage:[UIImage imageNamed:@"paletta_icon.png"] forState:UIControlStateReserved];
    [purchaseBtn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [purchaseBtn setTag:1];
    [self.view addSubview:purchaseBtn];
    
    UIImage* image = [[UIImage imageNamed:@"bubble_blue_recieve_doctor.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(53.0f,34.0f,20.0f,34.0f)];
    UIImageView* imageview = [[UIImageView alloc]initWithImage:image];
    imageview.frame = CGRectMake(10, 110, 100, 70);
    [self.view addSubview:imageview];
    
    SEL selector = @selector(alertView:clickedButtonAtIndex:);
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[LastViewController instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:self];
    UIAlertView *val = [[UIAlertView alloc]init];
    [invocation setArgument:&val atIndex:2];
    NSInteger index = 90;
    [invocation setArgument:&index atIndex:3];
    [invocation invoke];
    
    
    [self searchBarClearBackground];
    [self labelMutableAttributedString];

}
//search bar 去除背景色
-(void)searchBarClearBackground{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 40, 300, 40)];
    //	searchBar.backgroundColor = [UIColor clearColor];
    searchBar.backgroundImage = nil;
	searchBar.placeholder = @"SearchBarPlaceHolder";
    
	searchBar.keyboardType = UIKeyboardTypeDefault;
    //	searchBar.tintColor = [UIColor clearColor];
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
	// 去掉Searchbar的背景
    //    if (1) {
    [searchBar setBarTintColor:[UIColor clearColor]];
    for (UIView *view in searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    [self.view addSubview:searchBar];
}

//label多字体多颜色
-(void)labelMutableAttributedString{
    //label多色的使用
    NSString* string = @"redbluegreen";
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"red"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[string rangeOfString:@"green"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[string rangeOfString:@"blue"]];
    
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:[string rangeOfString:@"red"]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[string rangeOfString:@"blue"]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[string rangeOfString:@"green"]];
    
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 85, 300, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.attributedText = attributedString;
    [self.view addSubview:label];
}



-(void)btnSelected:(id)sender{

    
    NSInteger tag = ((UIButton*)sender).tag;
    [self coreImageFilterUsing];
    if (tag == 0) {
        
    }else if (tag == 1){
        
    }
}

//CIFilter Name define
#define CIGaussianBlur          @"CIGaussianBlur" //高斯模糊
#define CISepiaTone             @"CISepiaTone" //棕褐色色调
-(void)coreImageFilterUsing{
    NSArray* arrarCategory = [NSArray arrayWithObjects: kCICategoryDistortionEffect, kCICategoryGeometryAdjustment, kCICategoryCompositeOperation, kCICategoryHalftoneEffect, kCICategoryColorAdjustment, kCICategoryColorEffect, kCICategoryTransition, kCICategoryTileEffect, kCICategoryGenerator, kCICategoryReduction, kCICategoryGradient, kCICategoryStylize, kCICategorySharpen, kCICategoryBlur, kCICategoryVideo, kCICategoryStillImage, kCICategoryInterlaced, kCICategoryNonSquarePixels, kCICategoryHighDynamicRange , kCICategoryBuiltIn, nil];
    
    for (NSString* category in arrarCategory) {
        NSArray* names = [CIFilter filterNamesInCategory:category];
        LOGINFO(@"-----%@------",category);
        for (NSString* str in names) {
            LOGINFO(@"%@", str);
        }
    }
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [[CIImage alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [filter setValue:image forKey:kCIInputImageKey];

//    [filter setDefaults];
    [filter setValue:[[CIColor alloc]initWithColor:[UIColor yellowColor]] forKey:kCIInputColorKey];//(__MAC_10_5, __IPHONE_7_0);
    
    CIImage *result = [filter outputImage];//    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];

    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 110, 100, 70)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.backgroundColor = [UIColor redColor];;
    [self.view addSubview:imageView];
    imageView.image = blurImage;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    LOGINFO(@"aljkshdgkajsdghklasdjgh%d", buttonIndex);
}

-(void)updateNewsBtnPressed:(id)sender{
    
    
    LOGINFO(@"%@",@"updateNewsBtnPressed");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backAction:(id)sender{

    [self.navigationController popViewControllerAnimated:YES];
}
             




-(void)viewWillDisappear:(BOOL)animated{

}


-(void)viewWillAppear:(BOOL)animated{
    LOGINFO(@"viewWillAppear");
}

-(void)viewDidAppear:(BOOL)animated{
    LOGINFO(@"viewDidAppear");

}





-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    return YES;
}


-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{

    return UIInterfaceOrientationMaskLandscape;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}







@end
