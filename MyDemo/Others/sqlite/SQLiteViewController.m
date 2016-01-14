//
//  SQLiteViewController.m
//  UINavgationController
//
//  Created by zhangxin on 12-12-21.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import "SQLiteViewController.h"

#import "Skintone.h"
#import "Area.h"

@interface SQLiteViewController ()

@end

@implementation SQLiteViewController

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
    
    self.title = @"SQLite";
    
    Area* area = [[Area alloc]init];
    area.Areaid     = @"100000";
    area.Usetype    = @"1000";
    area.Name       = @"testtest";
    area.Upid       = @"1000";
    area.Level      = @"1000";
    
    
    Area* area1 = [[Area alloc]init];
    area1.Areaid     = @"100001";
    area1.Usetype    = @"1000";
    area1.Name       = @"testtest";
    area1.Upid       = @"1000";
    area1.Level      = @"1000";
    
    [Area inserts:@[area, area1]];
    

//    [Area insert:area];

    // Do any additional setup after loading the view from its nib.
}

-(void)set{
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end