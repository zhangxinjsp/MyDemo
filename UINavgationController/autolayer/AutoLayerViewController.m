//
//  AutoLayerViewController.m
//  UINavgationController
//
//  Created by xsw on 14-10-20.
//  Copyright (c) 2014年 niexin. All rights reserved.
//

#import "AutoLayerViewController.h"

@interface AutoLayerViewController ()

@end

@implementation AutoLayerViewController

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

    self.view.backgroundColor = [UIColor whiteColor];
    LOGINFO(@"self view :%@", [NSString stringWithFormat:@"x:%.1f;y:%.1f;w:%.1f;h:%.1f;", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height]);
    
    _urlBtn = [[UIButton alloc]init];// WithFrame:CGRectMake(30, 160, 100, 60)];
    _urlBtn.backgroundColor = [UIColor grayColor];
    [_urlBtn setBackgroundImage:[UIImage imageNamed:@"btn_save.png"] forState:UIControlStateNormal];
    [_urlBtn setBackgroundImage:[UIImage imageNamed:@"btn_save_blue.png"] forState:UIControlStateHighlighted];
    [_urlBtn setTitle:@"call app" forState:UIControlStateNormal];
    _urlBtn.titleLabel.textColor = [UIColor blackColor];
    [_urlBtn addTarget:self action:@selector(callUrl) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_urlBtn];
    
    _urlEntryFeature = [[UIButton alloc]init];//WithFrame:CGRectMake(150, 160, 150, 60)];
    _urlEntryFeature.backgroundColor = [UIColor grayColor];
    [_urlEntryFeature setBackgroundImage:[UIImage imageNamed:@"btn_save.png"] forState:UIControlStateNormal];
    [_urlEntryFeature setBackgroundImage:[UIImage imageNamed:@"btn_save_blue.png"] forState:UIControlStateHighlighted];
    [_urlEntryFeature setTitle:@"entry feature" forState:UIControlStateNormal];
    _urlEntryFeature.titleLabel.textColor = [UIColor blackColor];
    [_urlEntryFeature addTarget:self action:@selector(entryFeatrue) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_urlEntryFeature];
    
    _nameLabel = [[UILabel alloc]init];//WithFrame:CGRectMake(2, 20, 100, 60)];
    _nameLabel.text = @"Name:";
    _nameLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.numberOfLines = 0;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_nameLabel];
    
    _passWordLabel = [[UILabel alloc]init];//WithFrame:CGRectMake(2, 90, 100, 60)];
    _passWordLabel.text = @"Password:";
    _passWordLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _passWordLabel.textColor = [UIColor blackColor];
    _passWordLabel.numberOfLines = 0;
    _passWordLabel.textAlignment = NSTextAlignmentLeft;
    _passWordLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:_passWordLabel];
    
//    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];//self.view设置之后自动布局会对他有影响，布局很难看
    [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_passWordLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_urlBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_urlEntryFeature setTranslatesAutoresizingMaskIntoConstraints:NO];
    
//    [self layoutSubviewTypeLandscape];
    [self layoutSubviewTypePortrait];
//    [self layoutSubviewTypeTest];
}

-(void)layoutSubviewTypeTest{
    NSDictionary *views = NSDictionaryOfVariableBindings(_nameLabel, _passWordLabel, _urlBtn, _urlEntryFeature);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[_nameLabel(>=50)]-(==10)-[_urlBtn(_nameLabel)]-(<=100)-|"
                                                                      options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=10,<=15)-[_nameLabel(>=100)]-(>=10,<=15)-[_passWordLabel(_nameLabel)]-(>=10,<=15)-|"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing|NSLayoutFormatAlignAllBaseline metrics:nil views:views]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passWordLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_nameLabel
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_nameLabel
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passWordLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_passWordLabel
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:0]];
    
    
    
    NSDictionary* metricsDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:30], @"value1", nil];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=10,<=15)-[_urlBtn(>=100)]-(==5)-[_urlEntryFeature(>=100)]-(10)-|"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing|NSLayoutFormatAlignAllBottom|NSLayoutFormatAlignAllTop metrics:metricsDict views:views]];
}

-(void)layoutSubviewTypePortrait{
    NSDictionary *views = NSDictionaryOfVariableBindings(_nameLabel, _passWordLabel, _urlBtn);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[_nameLabel(>=30)]-(10)-|"
                                                                      options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[_nameLabel(30)]-(10)-[_passWordLabel(300)]-(10)-[_urlBtn(30)]-(>=10)-|"
                                                                      options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passWordLabel
//                                                          attribute:NSLayoutAttributeTop
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:_nameLabel
//                                                          attribute:NSLayoutAttributeTop
//                                                         multiplier:1
//                                                           constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel
//                                                          attribute:NSLayoutAttributeHeight
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:_nameLabel
//                                                          attribute:NSLayoutAttributeWidth
//                                                         multiplier:1
//                                                           constant:0]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_passWordLabel
//                                                          attribute:NSLayoutAttributeHeight
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:_passWordLabel
//                                                          attribute:NSLayoutAttributeWidth
//                                                         multiplier:1
//                                                           constant:0]];
    
}

-(void)layoutSubviewTypeLandscape{
    NSDictionary *views = NSDictionaryOfVariableBindings(_nameLabel, _passWordLabel, _urlBtn);

    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[_passWordLabel(>=100)]-(10)-[_nameLabel(_passWordLabel)]-(10)-|"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing|NSLayoutFormatAlignAllTop metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[_passWordLabel(>=100)]-(10)-[_urlBtn(_passWordLabel)]-(10)-|"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[_passWordLabel(>=50)]-(10)-|"
                                                                      options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[_nameLabel(30)]-(10)-[_urlBtn(_nameLabel)]-(>=10)-|"
                                                                      options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
    
}

-(void)setValueText{
    _nameLabel.text = [NSString stringWithFormat:@"x:%.1f;y:%.1f;w:%.1f;h:%.1f;", _nameLabel.frame.origin.x, _nameLabel.frame.origin.y, _nameLabel.frame.size.width, _nameLabel.frame.size.height];
    _passWordLabel.text = [NSString stringWithFormat:@"x:%.1f;y:%.1f;w:%.1f;h:%.1f;", _passWordLabel.frame.origin.x, _passWordLabel.frame.origin.y, _passWordLabel.frame.size.width, _passWordLabel.frame.size.height];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setValueText];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
// Dispose of any resources that can be recreated.
}




-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    [self.view removeConstraints:[self.view constraints]];
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        [self layoutSubviewTypeLandscape];
    }else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
        [self layoutSubviewTypePortrait];
    }
    [self setValueText];
    return UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
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
