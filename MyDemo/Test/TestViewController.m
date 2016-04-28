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


    
//    com.huawei.ott.hosting${PRODUCT_NAME:rfc1034identifier}
    
    UIImage* image = [[UIImage imageNamed:@"bubble_blue_recieve_doctor.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(53.0f,34.0f,20.0f,34.0f)];
    UIImageView* imageview = [[UIImageView alloc]initWithImage:image];
    imageview.frame = CGRectMake(10, 110, 100, 70);
    [self.view addSubview:imageview];
    

    
    
    [self searchBarClearBackground];
    
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




-(void)btnSelected:(id)sender{

    NSInteger tag = ((UIButton*)sender).tag;
    if (tag == 0) {
        
    }else if (tag == 1){
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    LOGINFO(@"aljkshdgkajsdghklasdjgh%d", buttonIndex);
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

- (void)setOrientationPortrait {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)invocationUsing {
    SEL selector = @selector(alertView:clickedButtonAtIndex:);
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[TestViewController instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:self];
    UIAlertView *val = [[UIAlertView alloc]init];
    [invocation setArgument:&val atIndex:2];
    NSInteger index = 90;
    [invocation setArgument:&index atIndex:3];
    [invocation invoke];
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
