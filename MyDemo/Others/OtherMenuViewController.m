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
#import "URLConnectionViewController.h"
#import "URLSessionViewController.h"
#import "SocketViewController.h"
#import "SQLiteViewController.h"
#import "ShareTofaceBookViewController.h"
#import "FileManagerReadAndWriteViewController.h"
#import "RegexViewController.h"
#import "SecurityViewController.h"
#import "RunTimeViewController.h"
#import "RunLoopViewController.h"


typedef NS_ENUM(NSInteger, OtherMenuType) {
    BluetoothTag,
    ContactsTag,
    CoreDataTag,
    MotionTag,
    APLTag,
    URLConnectionTag,
    URLSessionTag,
    SocketTag,
    SQLiteTag,
    ShareTofaceBookTag,
    FileManagerReadAndWriteTag,
    RegexTag,
    SecurityTag,
    RunTime,
    RunLoop,
};

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
    
    titleArray = [[NSArray alloc]initWithObjects:@"ble", @"contacs", @"coredata", @"motion", @"reachaboloty", @"connection", @"session", @"socket", @"SQLite", @"share",@"file read write", @"regex", @"Security", @"RunTime",  @"RunLoop", nil];
    
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
    
    OtherMenuType tag = indexPath.row;
    switch (tag) {
        case BluetoothTag: {
            BluetoothViewController* ctl = [[BluetoothViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case ContactsTag: {
            ContactsViewController* ctl = [[ContactsViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case CoreDataTag: {
            CoreDataViewController* ctl = [[CoreDataViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case MotionTag: {
            MotionViewController* ctl = [[MotionViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case APLTag: {
            APLViewController* ctl = [[APLViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case URLConnectionTag: {
            URLConnectionViewController* ctl = [[URLConnectionViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case URLSessionTag: {
            URLSessionViewController* ctl = [[URLSessionViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case SocketTag: {
            SocketViewController* ctl = [[SocketViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case SQLiteTag: {
            SQLiteViewController* ctl = [[SQLiteViewController alloc]init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case ShareTofaceBookTag: {
            ShareTofaceBookViewController* ctl = [[ShareTofaceBookViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case FileManagerReadAndWriteTag: {
            FileManagerReadAndWriteViewController* ctl = [[FileManagerReadAndWriteViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case RegexTag: {
            RegexViewController* ctl = [[RegexViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case SecurityTag: {
            SecurityViewController* ctl = [[SecurityViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case RunTime: {
            RunTimeViewController* ctl = [[RunTimeViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case RunLoop: {
            RunLoopViewController* ctl = [[RunLoopViewController alloc] init];
            ctl.title = [titleArray objectAtIndex:tag];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
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
