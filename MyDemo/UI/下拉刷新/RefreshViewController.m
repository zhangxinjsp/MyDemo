//
//  SixthViewController.m
//  UINavgationController
//
//  Created by zhangxin on 12-11-16.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import "RefreshViewController.h"

@interface RefreshViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshHeadViewProtocol>{
    UITableView* tableview;
    RefreshHeadView* refreshView;
    NSInteger totalCount;
}

@end

@implementation RefreshViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        totalCount = 10;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"下拉刷新";
    
    tableview = [[UITableView alloc]init];
    tableview.delegate = self;
    tableview.dataSource = self;
    [tableview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:tableview];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[tableview(>=0)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableview)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[tableview(>=0)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableview)]];
    
    refreshView = [[RefreshHeadView alloc]initWithFrame:CGRectMake(0, -120, 320, 120)];
    refreshView.refreshDelegate = self;
    refreshView.backgroundColor = [UIColor whiteColor];
    [tableview addSubview:refreshView];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)refresh{
    LOGINFO(@"%@",@"refresh");
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return totalCount;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identify = @"identify";
    
//    FDFundGradeCell *cell = (FDFundGradeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (nil == cell) {
//        NSArray *a = [[NSBundle mainBundle] loadNibNamed:@"FDFundGradeCell" owner:self options:nil];
//        cell = [a objectAtIndex:0];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }

    cell.textLabel.text = @"textLabel";
    cell.detailTextLabel.text = @"detailTextLabel";
    cell.imageView.image = [UIImage imageNamed:@"logo.png"];
    return cell;
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableview deselectRowAtIndexPath:indexPath animated:YES];

    totalCount--;
    
    [tableview deleteRowsAtIndexPaths:[[NSArray alloc]initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
//    [tableView reloadRowsAtIndexPaths:[[NSArray alloc]initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    
//    LOGINFO(@"section = %d , row = %d",indexPath.section,indexPath.row);
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    LOGINFO(@"%@,,contentOffset = %f,,",@"scrollViewDidScroll",scrollView.contentOffset.y);
    [refreshView refreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [refreshView refreshScrollViewDidEndDragging:scrollView];
}

-(void)beginRefresh{
//    [NSTimer timerWithTimeInterval:3 target:self selector:@selector(finishLoad) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(finishLoad) userInfo:nil repeats:NO];
    
    LOGINFO(@"%@",@"刷新成功");
    
}

-(void)finishLoad{
    [tableview setContentInset:UIEdgeInsetsZero];
}








@end
