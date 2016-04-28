//
//  TestModel.m
//  Test
//
//  Created by 张鑫 on 16/4/15.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "TestModel.h"

@interface TestModel () <TestModelDelegate>

@end

@implementation TestModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
    [super setValuesForKeysWithDictionary:keyedValues];
}

- (void)setFriends:(NSArray *)friends {
    NSLog(@"%@", friends);
    if ([friends isKindOfClass:[NSArray class]]) {
        NSLog(@"is array");
    } else {
        NSLog(@"is not array");
    }
}


+ (void) classTest1 {
    NSLog(@"class Test1");
}

- (void) test1 {
    NSLog(@"test1");
}

- (void) test2 {
    NSLog(@"test2");
}

-(void)testDelegate1 {
    
}


@end




