//
//  OtherMenuViewController.m
//  MyDemo
//
//  Created by 张鑫 on 16/1/14.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "OtherMenuViewController.h"

#import "BluetoothViewController.h"
#import "ContactsViewController.h"
#import "CoreDataViewController.h"
#import "MotionViewController.h"
#import "APLViewController.h"
#import "URLRequestViewController.h"
#import "SocketViewController.h"
#import "SQLiteViewController.h"
#import "ShareTofaceBookViewController.h"
#import "FileManagerReadAndWriteViewController.h"
#import "RegexAndMd5ViewController.h"

@interface OtherMenuViewController () <UITableViewDelegate, UITableViewDataSource>{
    UITableView* tableV;
    NSArray* titleArray;
}

@end

@implementation OtherMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"other";
    
    titleArray = [[NSArray alloc]initWithObjects:@"ble", @"contacs", @"coredata", @"motion", @"reachaboloty", @"request", @"socket", @"SQLite", @"share",@"file read write", @"regex md5", nil];
    
    tableV = [[UITableView alloc]init];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.backgroundColor = [UIColor lightGrayColor];
    tableV.translatesAutoresizingMaskIntoConstraints = NO;
    tableV.separatorInset = UIEdgeInsetsZero;
    tableV.layoutMargins = UIEdgeInsetsZero;
    [self.view addSubview:tableV];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableV(>=0)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableV)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableV(>=0)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableV)]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    cell.textLabel.text = titleArray[indexPath.row];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LOGINFO(@"select at section %d, row %d", indexPath.section, indexPath.row);
    
    NSInteger tag = indexPath.row;
    switch (tag) {
        case 0:{
            BluetoothViewController* ctl = [[BluetoothViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 1:{
            ContactsViewController* ctl = [[ContactsViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 2:{
            CoreDataViewController* ctl = [[CoreDataViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 3:{
            MotionViewController* ctl = [[MotionViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 4:{
            APLViewController* ctl = [[APLViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 5:{
            URLRequestViewController* ctl = [[URLRequestViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 6:{
            SocketViewController* ctl = [[SocketViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 7:{
            SQLiteViewController* ctl = [[SQLiteViewController alloc]init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 8:{
            ShareTofaceBookViewController* ctl = [[ShareTofaceBookViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 9:{
            FileManagerReadAndWriteViewController* ctl = [[FileManagerReadAndWriteViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 10:{
            RegexAndMd5ViewController* ctl = [[RegexAndMd5ViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        default:
            break;
    }
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
