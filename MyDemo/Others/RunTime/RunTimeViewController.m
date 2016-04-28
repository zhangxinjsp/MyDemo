//
//  ViewController.m
//  Test
//
//  Created by 张鑫 on 16/3/15.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "RunTimeViewController.h"

#import "TestModel.h"

@interface RunTimeViewController ()

@end

@implementation RunTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString* a = @"0123456789";
    
    NSString* b = [a substringToIndex:a.length];
    
    NSLog(@"%@", b);
    
    NSString *girlFriend = @"白菜";
    id parmenters = @{
                      @"girlFriend":girlFriend,
                      @"age":@22.1,
                      @"name":@"Lastdays",
                      @"time":@"2016-03-18 5:55:49 +0000",
                      @"friends":@"11111111"
                      };
    
    TestModel* model = [[TestModel alloc]init];
    //设置model的值，属性名与key一致就可以
    [model setValuesForKeysWithDictionary:parmenters];
    
    NSLog(@"");
    
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 40)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton* btn1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 150, 100, 40)];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}

- (void)buttonAction:(id)sender {
    NSLog(@"button action");
    [self addMethod];
}


- (void)propertyAttribute {
    TestModel* model = [[TestModel alloc]init];
    
    Class cls = model.class;
    unsigned int count = 0;
    //    获取属性列表
    objc_property_t *propertys = class_copyPropertyList(cls,&count);
    for (unsigned int i = 0; i<count; i++) {
        NSLog(@"\n\n%d:%s", __LINE__, property_getName(propertys[i]));
        
        unsigned int attrCount;
        objc_property_attribute_t *attrs = property_copyAttributeList(propertys[i], &attrCount);
        for (unsigned int i = 0; i<attrCount; i++) {
            NSLog(@"%d:%s; %s", __LINE__, attrs[i].name, attrs[i].value);
            
            if (attrs[i].name[0] == 'T') {
                size_t len = strlen(attrs[i].value);
                if (len>3) {
                    char name1[len - 2];
                    name1[len - 3] = '\0';
                    memcpy(name1, attrs[i].value + 2, len - 3);
//                    NSLog(@"%s", name1);
//                    _typeClass = objc_getClass(name1);
                }
            }
        }
    }
}


- (void)replaceMethod {
    TestModel* model = [[TestModel alloc]init];
    
    ////源方法的SEL和Method
    SEL oriSEL = @selector(test1);
    
    ////交换方法的SEL和Method
    SEL cusSEL = @selector(replace);
    Method cusMethod = class_getInstanceMethod(self.class, cusSEL);
    
    class_replaceMethod(model.class, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
    
    [model test1];
    [self replace];
}

- (void)replace {
    NSLog(@"replace replace replace ");
}


- (void)exchangeMethod {
    TestModel* model = [[TestModel alloc]init];
    Method m1 = class_getInstanceMethod([model class], NSSelectorFromString(@"test1"));
    Method m2 = class_getInstanceMethod([model class], NSSelectorFromString(@"test2"));
    method_exchangeImplementations(m1, m2);
    
    [model test1];
    [model test2];
}

- (void)addMethod {
    TestModel* model = [[TestModel alloc]init];
    
    SEL sel = @selector(add);
    Method selMethod = class_getInstanceMethod(self.class, sel);
    class_addMethod([model class], sel, method_getImplementation(selMethod), method_getTypeEncoding(selMethod));
    
    if ([model respondsToSelector:sel]) {
//        [model performSelector:sel];
        SEL selector = NSSelectorFromString(@"add");
        IMP imp = [model methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(model, selector);
    } else{
        NSLog(@"Sorry,I don't know");
    }
}

- (void)add {
    NSLog(@"add add add ");
}



- (void)changeValue {
    
    TestModel* model = [[TestModel alloc]init];
    model.age = @10;
    
    unsigned int count = 0;
    //    获取成员变量列表
    Ivar *ivarList = class_copyIvarList(model.class, &count);
    for (unsigned int i = 0; i<count; i++) {
        NSLog(@"%d:%s", __LINE__, ivar_getName(ivarList[i]));
        NSString* name = [NSString stringWithFormat:@"%s", ivar_getName(ivarList[i])];
        if ([name isEqualToString:@"_age"]) {
            object_setIvar(model, ivarList[i], @20);
        }
    }
    NSLog(@"%@", model.age);
    
}




- (void)aaaaa{
    TestModel* model = [[TestModel alloc]init];
    
    Class cls = model.class;
    unsigned int count = 0;
    
    //    获得类方法
    Class Class1 = object_getClass([model class]);
    SEL oriSEL = NSSelectorFromString(@"classTest1");// @selector(test1);
    Method oriMethod = class_getInstanceMethod(Class1, oriSEL);
    NSLog(@"%d:%s", __LINE__, sel_getName(method_getName(oriMethod)));
    
    //    获得实例方法
    SEL cusSEL = NSSelectorFromString(@"test1");//@selector(test2);
    Method cusMethod = class_getInstanceMethod(model.class, cusSEL);
    NSLog(@"%d:%s", __LINE__, sel_getName(method_getName(cusMethod)));
    
    
    SEL testSEL = NSSelectorFromString(@"test");//@selector(test2);
    
    
    //    替换原方法实现
    class_replaceMethod(model.class, testSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    
    
    //    获取属性列表
    objc_property_t *propertys = class_copyPropertyList(cls,&count);
    for (unsigned int i = 0; i<count; i++) {
        NSLog(@"%d:%s", __LINE__, property_getName(propertys[i]));
    }
    
    //    获取成员变量列表
    Ivar *ivarList = class_copyIvarList(cls, &count);
    for (unsigned int i = 0; i<count; i++) {
        NSLog(@"%d:%s", __LINE__, ivar_getName(ivarList[i]));
    }
    
    //    获取方法列表
    Method *methodList = class_copyMethodList(cls, &count);
    for (unsigned int i = 0; i<count; i++) {
        NSLog(@"%d:%s", __LINE__, sel_getName(method_getName(methodList[i])));
    }
    
    //    获取协议列表
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(cls, &count);
    for (unsigned int i = 0; i<count; i++) {
        NSLog(@"%d:%s", __LINE__, protocol_getName(protocolList[i]));
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void) performSelectorWornning {
    
    /*
     SEL aselect = NSSelectorFromString(@"invocationUsing");
     [self performSelector:aselect];
     [self performSelector:@selector(invocationUsing)];
     
     performSelector may cause a leak because its selector is unknown
     警告的处理方法
     
     解决办法
     
     1.使用函数指针方式
     
     SEL selector = NSSelectorFromString(@"someMethod");
     IMP imp = [_controller methodForSelector:selector];
     void (*func)(id, SEL) = (void *)imp;
     func(_controller, selector);
     当有额外参数时，如
     
     SEL selector = NSSelectorFromString(@"processRegion:ofView:");
     IMP imp = [_controller methodForSelector:selector];
     CGRect (*func)(id, SEL, CGRect, UIView *) = (void *)imp;
     CGRect result = func(_controller, selector, someRect, someView);
     
     
     2.使用宏忽略警告
     
     #define SuppressPerformSelectorLeakWarning(Stuff) \
     do { \
     _Pragma("clang diagnostic push") \
     _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
     Stuff; \
     _Pragma("clang diagnostic pop") \
     } while (0)
     在产生警告也就是 performSelector 的地方用使用该宏，如
     
     SuppressPerformSelectorLeakWarning(
     [_target performSelector:_action withObject:self]
     );
     如果需要 performSelector 返回值的话，
     
     id result;
     SuppressPerformSelectorLeakWarning(
     result = [_target performSelector:_action withObject:self]
     );
     
     
     3.使用afterDelay
     
     [self performSelector:aSelector withObject:nil afterDelay:0.0];
     如果在接受范围内，允许在下一个runloop执行，可以这么做。xCode5没问题，但据反映，xcode6的话这个不能消除警告。
     
     */
    
    
}



@end
