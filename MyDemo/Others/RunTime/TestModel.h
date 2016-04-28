//
//  TestModel.h
//  Test
//
//  Created by 张鑫 on 16/4/15.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>
#import <objc/message.h>

@protocol TestModelDelegate;

@interface TestModel : NSObject

@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *girlFriend;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSDictionary *time;

- (void) test1;

- (void) test2;

@end

@protocol TestModelDelegate <NSObject>

-(void)testDelegate1;

@end
