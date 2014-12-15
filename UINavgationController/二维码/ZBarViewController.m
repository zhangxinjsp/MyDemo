//
//  ZBarViewController.m
//  UINavgationController
//
//  Created by xsw on 14/12/12.
//  Copyright (c) 2014年 niexin. All rights reserved.
//

#import "ZBarViewController.h"

@interface ZBarViewController ()<UITextFieldDelegate>{
    UIImageView* imageView;
    UIButton* makeQRCodeBtn;
    
    UIButton* scanQRCodeBtn;
    UIButton* readAlbumsQRCodeBtn;
    UIButton* catchQRCodeBtn;
    UITextField* textField;
    UILabel* label;
}

@end

@implementation ZBarViewController

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
    [scanQRCodeBtn addTarget:self action:@selector(scanQRCode) forControlEvents:UIControlEventTouchUpInside];
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
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[textField(==height)]-10-[makeQRCodeBtn(height)]-10-[imageView(200)]-10-[label(>=height)]-10-|" options:NSLayoutFormatAlignAllLeft metrics:metricsDict views:viewsDict]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[textField(>=0)]-10-|" options:NSLayoutFormatAlignAllTop metrics:metricsDict views:viewsDict]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[makeQRCodeBtn(>=0)]-10-[scanQRCodeBtn(makeQRCodeBtn)]-10-[readAlbumsQRCodeBtn(makeQRCodeBtn)]-10-[catchQRCodeBtn(makeQRCodeBtn)]-10-|" options:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom metrics:metricsDict views:viewsDict]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:textField attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
}

#pragma mark －－－－－－－－－－－－－－－生成二维码－－－－－－－－－－

-(void)makeQRCode{
//    imageView.image = [QRCodeGenerator qrImageForString:textField.text imageSize:imageView.frame.size.width];
    
    imageView.image = [QRCodeGenerator qrImageForString:textField.text imageSize:imageView.frame.size.width withPointType:QRPointRound withPositionType:QRPositionRound withColor:[UIColor redColor]];    
}

#pragma mark －－－－－－－－－－－－－－－扫描二维码－－－－－－－－－－
//扫描二维码图片
-(void)scanQRCode{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
    [self presentViewController:reader animated:YES completion:^{
        
    }];
}
//从相册中读取二维码图片
- (void)readFromAlbums {
    ZBarReaderController *reader = [ZBarReaderController new];
    reader.allowsEditing = YES;
    reader.readerDelegate = self;
    reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:reader animated:YES completion:^{
        
    }];
}
//捕捉二维码
- (void)catchQRCode {
    ZBarReaderController *reader = [ZBarReaderController new];
    reader.delegate = self;
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    [self presentViewController:reader animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    if ([info count]>2) {
        int quality = 0;
        ZBarSymbol *bestResult = nil;
        for(ZBarSymbol *sym in results) {
            int q = sym.quality;
            if(quality < q) {
                quality = q;
                bestResult = sym;
            }
        }
        [self performSelector: @selector(presentResult:) withObject: bestResult afterDelay: .001];
    }else {
        ZBarSymbol *symbol = nil;
        for(symbol in results)
            break;
        [self performSelector: @selector(presentResult:) withObject: symbol afterDelay: .001];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) presentResult: (ZBarSymbol*)sym {
    if (sym) {
        NSString *tempStr = sym.data;
        if ([sym.data canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
            tempStr = [NSString stringWithCString:[tempStr cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        label.text =  tempStr;
    }
}







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
