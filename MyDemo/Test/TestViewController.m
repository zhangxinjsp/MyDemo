//
//  LastViewController.m
//  UINavgationController
//
//  Created by zhangxin on 12-10-26.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import "TestViewController.h"
#import "UILabel-LineHeigh.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreText/CoreText.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

typedef NSInteger (^TestAnimation)(NSString* str);

@interface TestViewController () {
    
}

@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//    view 定义xib文件的方法
//        NSArray* array = [[NSBundle mainBundle]loadNibNamed:@"ItemView" owner:nil options:nil];
//        ItemView* tempView = [array objectAtIndex:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"test11";

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
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[TestViewController instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:self];
    UIAlertView *val = [[UIAlertView alloc]init];
    [invocation setArgument:&val atIndex:2];
    NSInteger index = 90;
    [invocation setArgument:&index atIndex:3];
    [invocation invoke];
    
    
    [self searchBarClearBackground];
    [self labelMutableAttributedString];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIDeviceOrientationPortrait] forKey:@"orientation"];

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
    NSString* string = @"redblue<green>green</green>";
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];//调整行间距
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"red"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[string rangeOfString:@"green"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[string rangeOfString:@"blue"]];
    
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:[string rangeOfString:@"red"]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[string rangeOfString:@"blue"]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[string rangeOfString:@"green"]];
    
//    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:[string rangeOfString:@"green"]];
    
    
//    [attributedString addAttribute:NSLinkAttributeName value:@"www.baidu.com" range:[string rangeOfString:@"green"]];
    [attributedString addAttribute:@"kWPAttributedMarkupLinkName" value:@"www.baidu.com" range:[string rangeOfString:@"green"]];

    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 85, 300, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.attributedText = attributedString;
    [self.view addSubview:label];
}


-(void)btnSelected:(id)sender{

    NSInteger tag = ((UIButton*)sender).tag;
    if (tag == 0) {
        
    }else if (tag == 1){
        
    }
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
             


-(NSDictionary*)textAttributesAtPoint:(CGPoint)pt
{
    UILabel* label111111 = nil;
    
    // Locate the attributes of the text within the label at the specified point
    NSDictionary* dictionary = nil;
    
    // First, create a CoreText framesetter
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)label111111.attributedText);
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, CGRectMake(0, 0, label111111.frame.size.width, label111111.frame.size.height));
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get each of the typeset lines
    NSArray *lines = (__bridge id)CTFrameGetLines(frameRef);
    
    CFIndex linesCount = [lines count];
    CGPoint *lineOrigins = (CGPoint *) malloc(sizeof(CGPoint) * linesCount);
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, linesCount), lineOrigins);
    
    CTLineRef line = NULL;
    CGPoint lineOrigin = CGPointZero;
    
    // Correct each of the typeset lines (which have origin (0,0)) to the correct orientation (typesetting offsets from the bottom of the frame)
    
    CGFloat bottom = label111111.frame.size.height;
    for(CFIndex i = 0; i < linesCount; ++i) {
        lineOrigins[i].y = label111111.frame.size.height - lineOrigins[i].y;
        bottom = lineOrigins[i].y;
    }
    
    // Offset the touch point by the amount of space between the top of the label frame and the text
    pt.y -= (label111111.frame.size.height - bottom)/2;
    
    
    // Scan through each line to find the line containing the touch point y position
    for(CFIndex i = 0; i < linesCount; ++i) {
        line = (__bridge CTLineRef)[lines objectAtIndex:i];
        lineOrigin = lineOrigins[i];
        CGFloat descent, ascent;
        CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, nil);
        
        if(pt.y < (floor(lineOrigin.y) + floor(descent))) {
            
            // Cater for text alignment set in the label itself (not in the attributed string)
            if (label111111.textAlignment == NSTextAlignmentCenter) {
                pt.x -= (label111111.frame.size.width - width)/2;
            } else if (label111111.textAlignment == NSTextAlignmentRight) {
                pt.x -= (label111111.frame.size.width - width);
            }
            
            // Offset the touch position by the actual typeset line origin. pt is now the correct touch position with the line bounds
            pt.x -= lineOrigin.x;
            pt.y -= lineOrigin.y;
            
            // Find the text index within this line for the touch position
            CFIndex i = CTLineGetStringIndexForPosition(line, pt);
            
            // Iterate through each of the glyph runs to find the run containing the character index
            NSArray* glyphRuns = (__bridge id)CTLineGetGlyphRuns(line);
            CFIndex runCount = [glyphRuns count];
            for (CFIndex run=0; run<runCount; run++) {
                CTRunRef glyphRun = (__bridge CTRunRef)[glyphRuns objectAtIndex:run];
                CFRange range = CTRunGetStringRange(glyphRun);
                if (i >= range.location && i<= range.location+range.length) {
                    dictionary = (__bridge NSDictionary*)CTRunGetAttributes(glyphRun);
                    break;
                }
            }
            if (dictionary) {
                break;
            }
        }
    }
    
    free(lineOrigins);
    CFRelease(frameRef);
    CFRelease(framesetter);
    
    
    return dictionary;
}


-(void)viewWillDisappear:(BOOL)animated{
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

#pragma  mark run loop
- (void)runLoop {
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    BOOL aa = NO;
    while (!aa) {
        for (NSString *mode in (__bridge NSArray *)allModes) {
            CFRunLoopRunInMode((__bridge CFStringRef)mode, 0.001, false);
        }
    }
    
    CFRelease(allModes);
}

static BOOL pageStillLoading = NO;

- (IBAction)start:(id)sender
{
    pageStillLoading = YES;
    [NSThread detachNewThreadSelector:@selector(loadPageInBackground:)toTarget:self withObject:nil];

    NSLog(@"start  start  start  start  start  start  start  start  ");
    while (pageStillLoading) {
        NSLog(@"run loop");
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
    NSLog(@"end   end   end   end   end   end   end   end   end   ");

}

-(void)loadPageInBackground:(id)sender{
    for (int i = 0; i < 1000; i ++) {
        NSLog(@"%d <%@>", i, [NSDate distantFuture]);
    }
    pageStillLoading = NO;
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

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{

    return UIInterfaceOrientationMaskLandscape;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}







@end
