//
//  ViewController.m
//  SocketClient
//
//  Created by zhangxin on 16/2/24.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "SocketClientViewController.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

@interface SocketClientViewController () <NSStreamDelegate>{
    CFSocketRef _socket;
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}

@end

@implementation SocketClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Byte b = 0x01 ^ 0x83;
    NSLog(@"%x",b);
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initClientSocket];
//    [self searchForSite];
    // Dispose of any resources that can be recreated.
}

- (void)searchForSite
{
    NSString* urlStr = @"192.168.2.2";
        
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)urlStr, 8888, &readStream, &writeStream);
    
    inputStream = (__bridge_transfer NSInputStream *)readStream;
//    [inputStream setProperty:NSStreamSocketSecurityLevelTLSv1 forKey:NSStreamSocketSecurityLevelKey];
    [inputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    
    outputStream = (__bridge_transfer NSOutputStream *)writeStream;
    [outputStream setDelegate:self];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream open];
        
        /* Store a reference to the input and output streams so that
         they don't go away.... */
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
//    NSLog(@"%@ stream:handleEvent: is invoked...", stream);
    
    switch(eventCode) {
        case NSStreamEventHasSpaceAvailable:
        {
            if (stream == outputStream) {
                NSString * str = [NSString stringWithFormat:
                                  @"GET / HTTP/1.0\r\n\r\n"];
                const uint8_t * rawstring = (const uint8_t *)[str UTF8String];
                [outputStream write:rawstring maxLength:sizeof(rawstring)];
                [outputStream close];
            }
            break;
        }
            // continued ...
        case NSStreamEventNone: {
            NSLog(@"none");
            break;
        }
        case NSStreamEventOpenCompleted: {
            NSLog(@"Open Completed");
            break;
        }
        case NSStreamEventHasBytesAvailable: {
//            NSLog(@"HasBytesAvailable");
            if (stream == inputStream){
                uint8_t buffer[100];
                [inputStream read:buffer maxLength:100];
                NSLog(@"%s", buffer);
            }
            break;
        }
        case NSStreamEventErrorOccurred: {
            NSLog(@"ErrorOccurred");
            break;
        }
        case NSStreamEventEndEncountered: {
            NSLog(@"End Encountered");
            break;
        }
    }
}






#pragma mark ===================== CFSocketContext============

-(void)initClientSocket{
    NSString* strAddress = @"192.168.2.2";
    
    CFSocketContext sockContext = {0, // 结构体的版本，必须为0
        (__bridge void *)(self),  // 一个任意指针的数据，可以用在创建时CFSocket对象相关联。这个指针被传递给所有的上下文中定义的回调。
        NULL, // 一个定义在上面指针中的retain的回调， 可以为NULL
        NULL, NULL};
    
    _socket = CFSocketCreate(kCFAllocatorDefault, // 为新对象分配内存，可以为nil
                             PF_INET, // 协议族，如果为0或者负数，则默认为PF_INET
                             SOCK_STREAM, // 套接字类型，如果协议族为PF_INET,则它会默认为SOCK_STREAM
                             IPPROTO_TCP, // 套接字协议，如果协议族是PF_INET且协议是0或者负数，它会默认为IPPROTO_TCP
                             kCFSocketConnectCallBack | kCFSocketReadCallBack | kCFSocketWriteCallBack | kCFSocketDataCallBack | kCFSocketAcceptCallBack, // 触发回调函数的socket消息类型，具体见Callback Types
                             TCPClientConnectCallBack, // 上面情况下触发的回调函数
                             &sockContext // 一个持有CFSocket结构信息的对象，可以为nil
                             );
    
//    Tell Core Foundation that it is allowed to close the socket when the underlying Core Foundation object is invalidated.
    CFOptionFlags sockopt = CFSocketGetSocketFlags(_socket);
    sockopt |= kCFSocketCloseOnInvalidate | kCFSocketAutomaticallyReenableReadCallBack;
    CFSocketSetSocketFlags(_socket, sockopt);
    
    if (_socket != nil) {
        struct sockaddr_in addr4;   // IPV4
        memset(&addr4, 0, sizeof(addr4));
        addr4.sin_len = sizeof(addr4);
        addr4.sin_family = AF_INET;
        addr4.sin_port = htons(8888);
        addr4.sin_addr.s_addr = inet_addr([strAddress UTF8String]);  // 把字符串的地址转换为机器可识别的网络地址
        
        // 把sockaddr_in结构体中的地址转换为Data
        CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr4, sizeof(addr4));
        CFSocketConnectToAddress(_socket, // 连接的socket
                                 address, // CFDataRef类型的包含上面socket的远程地址的对象
                                 -1  // 连接超时时间，如果为负，则不尝试连接，而是把连接放在后台进行，如果_socket消息类型为kCFSocketConnectCallBack，将会在连接成功或失败的时候在后台触发回调函数
                                 );
        
        CFRunLoopRef cRunRef = CFRunLoopGetCurrent();    // 获取当前线程的循环
        // 创建一个循环，但并没有真正加如到循环中，需要调用CFRunLoopAddSource
        CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socket, 0);
        CFRunLoopAddSource(cRunRef, // 运行循环
                           sourceRef,  // 增加的运行循环源, 它会被retain一次
                           kCFRunLoopCommonModes  // 增加的运行循环源的模式
                           );
        CFRunLoopRun();
        CFRelease(sourceRef);
    }
}

-(int) socknumForNSInputStream: (NSStream *)stream
{
    int sock = -1;
    NSData *sockObj = [stream propertyForKey:
                       (__bridge NSString *)kCFStreamPropertySocketNativeHandle];
    if ([sockObj isKindOfClass:[NSData class]] &&
        ([sockObj length] == sizeof(int)) ) {
        const int *sockptr = (const int *)[sockObj bytes];
        sock = *sockptr;
    }
    return sock;
}

// socket回调函数的格式：
static void TCPClientConnectCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
    
    NSLog(@"%s[line:%d] info:%@", __FUNCTION__, __LINE__, info);
    switch (type) {
        case kCFSocketNoCallBack: {
            NSLog(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"kCFSocketNoCallBack");
            break;
        }
        case kCFSocketReadCallBack: {
            NSLog(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"kCFSocketReadCallBack");
            break;
        }
        case kCFSocketAcceptCallBack: {
            NSLog(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"kCFSocketAcceptCallBack");
            break;
        }
        case kCFSocketDataCallBack: {
            NSLog(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"kCFSocketDataCallBack");
            char buffer[1024];
            recv(CFSocketGetNative(socket), buffer, sizeof(buffer), 0);
            NSLog(@"%@", [NSString stringWithUTF8String:buffer]);
            break;
        }
        case kCFSocketConnectCallBack: {
            if (data != NULL) {
                // 当socket为kCFSocketConnectCallBack时，失败时回调失败会返回一个错误代码指针，其他情况返回NULL
                NSLog(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"连接失败");
            } else {
                NSLog(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"连接成功");
             
                SocketClientViewController *client = (__bridge SocketClientViewController *)info;
                // 读取接收的数据,（TCPClient 是自己的类，就是初始化是设置的self）
                [client performSelectorInBackground:@selector(sendMessage) withObject:nil];
            }
            break;
        }
        case kCFSocketWriteCallBack: {
            NSLog(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"kCFSocketWriteCallBack");
            break;
        }
        default:
            
            break;
    }
}

// 读取接收的数据
- (void)readStream {
    char buffer[1024];
    //    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    @autoreleasepool {
        while (recv(CFSocketGetNative(_socket), //与本机关联的Socket 如果已经失效返回－1:INVALID_SOCKET
                    buffer, sizeof(buffer), 0)) {
            NSLog(@"%@", [NSString stringWithUTF8String:buffer]);
        }
    }
}

// 发送数据
- (void)sendMessage {
    NSString *stringTosend = @"你好";
    char *data = (char*)[stringTosend UTF8String];
    send(CFSocketGetNative(_socket), data, strlen(data) + 1, 0);
//    send(SFSocketGetNative(_socket), data, strlen(data) + 1, 0);
//    [self readStream];
}


@end
