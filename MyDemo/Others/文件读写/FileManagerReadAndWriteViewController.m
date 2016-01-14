//
//  FileManagerReadAndWriteViewController.m
//  UINavgationController
//
//  Created by zhangxin on 12-12-20.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import "FileManagerReadAndWriteViewController.h"

@interface FileManagerReadAndWriteViewController ()

@end

@implementation FileManagerReadAndWriteViewController

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
    self.title = @"文件读写";
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"nextStep" style:UIBarButtonItemStyleDone target:self action:@selector(nextStep:)];
    self.navigationItem.rightBarButtonItem = item;
    
    fileManager = [NSFileManager defaultManager];
    //更改filemanager的操作路径
//    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    
    textField1 = [[UITextField alloc]init];
    textField1.delegate = self;
    textField1.backgroundColor = [UIColor grayColor];
    textField1.placeholder = @"title";
    [self.view addSubview:textField1];
    
    textField2 = [[UITextField alloc]init];
    textField2.delegate = self;
    textField2.backgroundColor = [UIColor grayColor];
    textField2.placeholder = @"title";
    [self.view addSubview:textField2];
    
    textField3 = [[UITextField alloc]init];
    textField3.delegate = self;
    textField3.backgroundColor = [UIColor grayColor];
    textField3.placeholder = @"title";
    [self.view addSubview:textField3];
    
    textField4 = [[UITextField alloc]init];
    textField4.delegate = self;
    textField4.backgroundColor = [UIColor grayColor];
    textField4.placeholder = @"title";
    [self.view addSubview:textField4];
    
    textField5 = [[UITextField alloc]init];
    textField5.delegate = self;
    textField5.backgroundColor = [UIColor grayColor];
    textField5.placeholder = @"title";
    [self.view addSubview:textField5];
    
    
    
    button1 = [[UIButton alloc]init];
    button1.backgroundColor = [UIColor grayColor];
    [button1 setTitle:@"creat" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(fileManagerCreat) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    button2 = [[UIButton alloc]init];
    button2.backgroundColor = [UIColor grayColor];
    [button2 setTitle:@"write" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(fileManagerWrite) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    button3 = [[UIButton alloc]init];
    button3.backgroundColor = [UIColor grayColor];
    [button3 setTitle:@"add" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(appString) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    button4 = [[UIButton alloc]init];
    button4.backgroundColor = [UIColor grayColor];
    [button4 setTitle:@"delete" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(fileManagerDelete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    button5 = [[UIButton alloc]init];
    button5.backgroundColor = [UIColor grayColor];
    [button5 setTitle:@"read" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(fileManagerRead) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];
    
    label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor redColor];
    [self.view addSubview:label];
    
    [textField1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [textField2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [textField3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [textField4 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [textField5 setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [button1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button4 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button5 setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];

    
    NSDictionary *views = NSDictionaryOfVariableBindings(textField1, textField2, textField3, textField4, textField5, button1, button2, button3, button4, button5, label);
    
    NSDictionary* metricsDictV = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:10], @"gap",
                                  [NSNumber numberWithFloat:30], @"height",
                                  [NSNumber numberWithFloat:240], @"width",
                                  nil];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(gap)-[textField1(height)]-(gap)-[textField2(textField1)]-(gap)-[textField3(textField1)]-(gap)-[textField4(textField1)]-(gap)-[textField5(textField1)]-(gap)-[label(>=0)]-(==10)-|" options:NSLayoutFormatAlignAllLeft metrics:metricsDictV views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[textField1(width)]-(5)-[button1(>=0)]-(10)-|" options:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom metrics:metricsDictV views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[textField2(width)]-(5)-[button2(>=0)]-(10)-|" options:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom metrics:metricsDictV views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[textField3(width)]-(5)-[button3(>=0)]-(10)-|" options:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom metrics:metricsDictV views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[textField4(width)]-(5)-[button4(>=0)]-(10)-|" options:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom metrics:metricsDictV views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[textField5(width)]-(5)-[button5(>=0)]-(10)-|" options:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom metrics:metricsDictV views:views]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:button1
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0]];
    
    
    
    
}
-(void)nextStep:(id)sender{
    TestViewController* lastView = [[TestViewController alloc] initWithNibName:@"LastViewController" bundle:nil];
    
    [self.navigationController pushViewController:lastView animated:YES];
}

-(NSString*)getFilePathWithFileName:(NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//取出需要的路径
    NSString* filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    LOGINFO(@"file path is :%@", filePath);
    //    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return filePath;
}

-(BOOL)isExitOfFile:(NSString*)fileName{
    
    NSString* filePath = [self getFilePathWithFileName:fileName];
    BOOL isExists = [fileManager fileExistsAtPath:filePath isDirectory:NO];
    LOGINFO(@"file is %@ exists", isExists ? @"" : @"not");
    return isExists;
}

//创建一个新的文件覆盖原有的同名文件
-(void)fileManagerCreat{
    [textField1 resignFirstResponder];
    NSString* fileName = textField1.text;
    [fileManager createFileAtPath:[self getFilePathWithFileName:fileName] contents:nil attributes:nil];
}

//创建一个新的文件覆盖原有的同名文件，同时写入相关数据
-(void)fileManagerWrite{
    [textField2 resignFirstResponder];
    NSString *path = [self getFilePathWithFileName:textField1.text];
    NSString *temp = textField2.text;
    NSMutableData *writer = [[NSMutableData alloc] init];
    [writer appendData:[temp dataUsingEncoding:NSUTF8StringEncoding]];
    //将缓冲的数据写入到文件中
    [writer writeToFile:path atomically:YES];
    
}

//在原有的文件中添加数据
-(void) appString
{
    BOOL isExist = [self isExitOfFile:textField1.text];
    
    NSString *filePath = [self getFilePathWithFileName:textField1.text];
    if (!isExist) {
        NSString *s = [NSString stringWithFormat:@"开始了:\r"];
        [s writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSFileHandle  * outFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if(outFile == nil) {
        LOGINFO(@"Open of file for writing failed");
    }
    
    //找到并定位到outFile的末尾位置(在此后追加文件)
    [outFile seekToEndOfFile];
    
    //读取inFile并且将其内容写到outFile中
    NSString* string = textField3.text;
    NSData *buffer = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    [outFile writeData:buffer];  
    
    //关闭读写文件  
    [outFile closeFile];  
    
}

//删除文件
-(void)fileManagerDelete{
    [textField4 resignFirstResponder];
    NSString* fileName = textField4.text;
    [fileManager removeItemAtPath:[self getFilePathWithFileName:fileName] error:nil];
}

//读取文件中的数据
-(void)fileManagerRead{
    
    [textField5 resignFirstResponder];
    NSString* fileName = textField5.text;
    NSString *path = [self getFilePathWithFileName:fileName];
    
    NSData *reader = [NSData dataWithContentsOfFile:path];
    NSString *gData2 = [[NSString alloc] initWithData:reader encoding:NSUTF8StringEncoding];
    
    label.text = gData2;
    
    //    读取工程中的文件：
    //    读取数据时，要看待读取的文件原有的文件格式，是字节码还是文本，我经常需要重文件中读取字节码，所以我写的是读取字节文件的方式。
    //用于存放数据的变量，因为是字节，所以是ＵInt8
    
    //获取字节的个数
    int length = [reader length];
    Byte b;
    LOGINFO(@"——->bytesLength:%d", length);
    for(int i = 0; i < length; i++) { //读取数据
        [reader getBytes:&b range:NSMakeRange(i, sizeof(b))];
        LOGINFO(@"——–>data%d:%d", i, b);
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
