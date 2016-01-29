//
//  TextAttributeViewController.m
//  MyDemo
//
//  Created by zhangxin on 16/1/29.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "TextAttributeViewController.h"

@interface TextAttributeViewController ()

@end

@implementation TextAttributeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self labelMutableAttributedString];
}



//label多字体多颜色
-(void)labelMutableAttributedString{
    //label多色的使用
    NSString* string1 = @"redblue<green>green</green>";
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc]initWithString:string1];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];//调整行间距
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string1 length])];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string1 rangeOfString:@"red"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[string1 rangeOfString:@"green"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[string1 rangeOfString:@"blue"]];
    
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:[string1 rangeOfString:@"red"]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[string1 rangeOfString:@"blue"]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[string1 rangeOfString:@"green"]];
    
//    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:[string rangeOfString:@"green"]];


//    [attributedString addAttribute:NSLinkAttributeName value:@"www.baidu.com" range:[string rangeOfString:@"green"]];
    [attributedString addAttribute:@"kWPAttributedMarkupLinkName" value:@"www.baidu.com" range:[string1 rangeOfString:@"green"]];
    
    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 85, 300, 20)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.attributedText = attributedString;
    [self.view addSubview:label1];
    
    /****************************************************************************************************************/
    
    NSString* str = @"test for baidu (1)\uFFFC baidu (2)\uFFFC baidu (3)\uFFFC baidu (4)\uFFFC!!";
    
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:str];
    
    [string addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"https://www.baidu.com/"] range:[str rangeOfString:@"baidu"]];
    
    NSShadow* shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor redColor];
    shadow.shadowOffset = CGSizeMake(1, 1);
    shadow.shadowBlurRadius = 0;
    [string addAttribute:NSShadowAttributeName value:shadow range:[str rangeOfString:@"test"]];
    
    NSInteger index = 0;
    while (YES) {
        index ++;
        NSString* repliceStr = [NSString stringWithFormat:@"(%d)", index];
        NSRange range = [str rangeOfString:repliceStr];
        if (range.location == NSNotFound) {
            break;
        } else {
            str = [str stringByReplacingOccurrencesOfString:repliceStr withString:@""];
            [string replaceCharactersInRange:range withAttributedString:[[NSAttributedString alloc]initWithString:@""]];
            range.length = 1;
            
            NSTextAttachment* textAttachment = [[NSTextAttachment alloc]init];
            [textAttachment setImage:[UIImage imageNamed:@"test"]];
            [string addAttribute:NSAttachmentAttributeName value:textAttachment range:range];//[str rangeOfString:@"\uFFFC"]
        }
    }
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, 300, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.attributedText = string;
    [self.view addSubview:label];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
