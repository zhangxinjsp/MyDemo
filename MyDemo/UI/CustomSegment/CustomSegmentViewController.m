//
//  CustomSegmentViewController.m
//  MyDemo
//
//  Created by zhangxin on 16/1/27.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "CustomSegmentViewController.h"

@protocol CustomSegmentViewDelegate ;

@interface CustomSegmentView : UIView {
    UIView* selectedView;
    UIView* maskView;
}

@property (nonatomic, strong) NSArray* titles;
@property (nonatomic, readwrite) NSInteger selectedIndex;
@property (nonatomic, assign) id<CustomSegmentViewDelegate> delegate;

@end

@protocol CustomSegmentViewDelegate <NSObject>
@required

@optional
- (void)segmentValueChanged:(CustomSegmentView*)segment;

@end


@implementation CustomSegmentView

@synthesize titles;
@synthesize selectedIndex;
@synthesize delegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)initControls {
    
    NSMutableDictionary* viewsDict = [[NSMutableDictionary alloc]init];
    NSString* constraintFormatH = @"H:|-0-";
    for (NSString* title in self.titles) {
        UILabel* label = [[UILabel alloc]init];
        label.text = title;
        label.tag = [self.titles indexOfObject:title];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = self.backgroundColor;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:label];
        
        [viewsDict setObject:label forKey:title];
        
        constraintFormatH = [constraintFormatH stringByAppendingFormat:@"[%@(%@)]-0-", title, [self.titles indexOfObject:title] == 0 ? @">=0": self.titles[0]];
    }
    
    constraintFormatH = [constraintFormatH stringByAppendingString:@"|"];
    
    NSString* constraintFormatV = [NSString stringWithFormat:@"V:|-0-[%@(>=0)]-0-|", self.titles[0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintFormatH options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintFormatV options:0 metrics:nil views:viewsDict]];
}

- (void)initSelectView {
    
    selectedView = [[UIView alloc]init];
    selectedView.backgroundColor = [UIColor blackColor];
    selectedView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:selectedView];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[selectedView(>=0)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selectedView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[selectedView(>=0)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selectedView)]];
    
    NSMutableDictionary* viewsDict = [[NSMutableDictionary alloc]init];
    NSString* constraintFormatH = @"H:|-0-";
    for (NSString* title in self.titles) {
        UILabel* label = [[UILabel alloc]init];
        label.text = title;
        label.tag = [self.titles indexOfObject:title];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = self.backgroundColor;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [selectedView addSubview:label];
        
        [viewsDict setObject:label forKey:title];
        
        constraintFormatH = [constraintFormatH stringByAppendingFormat:@"[%@(%@)]-0-", title, [self.titles indexOfObject:title] == 0 ? @">=0": self.titles[0]];
    }
    
    constraintFormatH = [constraintFormatH stringByAppendingString:@"|"];
    
    NSString* constraintFormatV = [NSString stringWithFormat:@"V:|-0-[%@(>=0)]-0-|", self.titles[0]];
    [selectedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintFormatH options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:viewsDict]];
    [selectedView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintFormatV options:0 metrics:nil views:viewsDict]];
}

- (void)initSelectedMaskView {
    if (maskView == nil) {
        CGFloat width = self.frame.size.width / self.titles.count;
        maskView = [[UIView alloc]initWithFrame:CGRectMake(self.selectedIndex * width, 0, width, self.frame.size.height)];
        maskView.backgroundColor = [UIColor blackColor];
        selectedView.maskView = maskView;
    }
}


- (void)layoutSubviews {
    LOGINFO(@"");
    [super layoutSubviews];
    [self initSelectedMaskView];
}


- (void)setTitles:(NSArray *)_titles {
    titles = _titles;
    [self initControls];
    [self initSelectView];
    
}

- (void)tapAction:(UITapGestureRecognizer*)tapGesture {
    CGPoint tapPoint = [tapGesture locationInView:self];
    
    for (UIView* subview in self.subviews) {
        if ([subview isKindOfClass:[UILabel class]] && CGRectContainsPoint(subview.frame, tapPoint)) {
            selectedIndex = subview.tag;
            break;
        }
    }
    
    [UIView animateWithDuration:2 animations:^{
        CGFloat width = self.frame.size.width / self.titles.count;
        maskView.frame = CGRectMake(self.selectedIndex * width, 0, width, self.frame.size.height);
    }];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(segmentValueChanged:)]) {
        [self.delegate segmentValueChanged:self];
    }
    
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    LOGINFO(@"touchesBegan");
//}
//
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    LOGINFO(@"touchesEnded");
//}


@end



/******************************************************************************************************************************************************/

@interface CustomSegmentViewController () <CustomSegmentViewDelegate>{
    CustomSegmentView* segmentView;
}

@end

@implementation CustomSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    segmentView = [[CustomSegmentView alloc]init];
    segmentView.delegate = self;
    segmentView.backgroundColor = [UIColor redColor];
    segmentView.titles = @[@"testtest1111", @"testtest2222", @"testtest3333"];
    segmentView.selectedIndex = 2;
    [segmentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:segmentView];
    
    NSDictionary* viewDict = NSDictionaryOfVariableBindings(segmentView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[segmentView(>=0)]-10-|" options:0 metrics:nil views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[segmentView(==30)]-(>=0)-|" options:0 metrics:nil views:viewDict]];
    
}

- (void)segmentValueChanged:(CustomSegmentView*)sender {
    LOGINFO(@"selected index :%d", sender.selectedIndex);
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
