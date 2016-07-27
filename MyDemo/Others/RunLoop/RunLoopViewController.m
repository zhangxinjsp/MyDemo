//
//  RunLoopViewController.m
//  MyDemo
//
//  Created by 张鑫 on 16/7/27.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "RunLoopViewController.h"

@interface RunLoopViewController () {
    CFRunLoopRef cRunRef;
}

@end

@implementation RunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
}


- (void)memoryTest {
    for (int i = 0; i < 100000; ++i) {
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
        [thread start];
        [self performSelector:@selector(stopThread) onThread:thread withObject:nil waitUntilDone:YES];
    }
}

- (void)run {
    @autoreleasepool {
        
        
        NSLog(@"current thread = %@", [NSThread currentThread]);
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
        /*
         NSRunLoop的几种启动法：
         1.run 方法的本质就是无限调用 runMode:beforeDate
         无条件进入是最简单的做法，但也最不推荐。这会使线程进入死循环，从而不利于控制 runloop，结束 runloop 的唯一方式是 kill 它
         
         2.runUntilDate: 也会重复调用 runMode:beforeDate，区别在于它超时后就不会再调用
         如果我们设置了超时时间，那么 runloop 会在处理完事件或超时后结束，此时我们可以选择重新开启 runloop。这种方式要由于前一种
         
         3.runMode:beforeDate
         这是相对来说最优秀的方式，相比于第二种启动方式，我们可以指定 runloop 以哪种模式运行
         
         总结：如果你还想从 runloop 里面退出来，就不能用 run 方法。根据实践结果和文档，另外两种启动方法也无法手动退出。
         */
        
        /*
         1.[NSMachPort port] 要使用一个对象，否则每次调用 [NSMachPort port] 方法都会占用内存
         2.在子线程中runloop 如果没有item的话就会直接退出，（item包括source,observer或者timer）addPort方法添加source
         2.在此情况下内存会不停的上涨，开启 runloop 导致了内存泄漏，也就是 thread 对象无法释放。
         3.使用CFRunLoopStop 无法停止runloop， thread依然没有释放。
         4.CFRunLoopStop() 方法只会结束当前的 runMode:beforeDate: 调用，而不会结束后续的调用。
         */
    }
}


- (void)stopThread {
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSThread *thread = [NSThread currentThread];
    [thread cancel];
}




/*
 想要正确的停止runnloop 可以使用：
 CFRunLoopRun()启动的runloop；
 这样就可以用 CFRunLoopStop(cRunRef);来停止runloop
 
 还有就是人为控制runMode:beforeDate:方法
 
 如下方法：
 */
- (void) startCFRunLoop {
    cRunRef = CFRunLoopGetCurrent();
    CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, nil, 0);
    CFRunLoopAddSource(cRunRef, sourceRef, kCFRunLoopDefaultMode);
    CFRunLoopRun();
    LOGINFO(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"run loop stoped");
    
    CFRunLoopRemoveSource(cRunRef, sourceRef, kCFRunLoopCommonModes);
    cRunRef = nil;
    
    if (CFRunLoopSourceIsValid(sourceRef)) {
        CFRunLoopSourceInvalidate(sourceRef);
    }
    CFRelease(sourceRef);
    sourceRef = nil;
}

- (void) stopCFRunLoop {
    CFRunLoopStop(cRunRef);
}

- (void)cccc{
    BOOL shouldKeepRunning = YES;
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    while (shouldKeepRunning && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
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
