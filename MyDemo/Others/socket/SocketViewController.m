//
//  SocketViewController.m
//  UINavgationController
//
//  Created by 张鑫 on 14-9-15.
//  Copyright (c) 2014年 zhangxin. All rights reserved.
//
/*
 https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/NetworkingTopics/Articles/UsingSocketsandSocketStreams.html#//apple_ref/doc/uid/CH73-SW1
 https://developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/NetworkingOverview/SocketsAndStreams/SocketsAndStreams.html#//apple_ref/doc/uid/TP40010220-CH203-CJBEFGHG
 https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/Streams/Articles/NetworkStreams.html#//apple_ref/doc/uid/20002277-BCIDFCDI
 */


#import "SocketViewController.h"

@interface SocketViewController () <NSStreamDelegate>{
    CFSocketRef _socket;
    NSThread* socketThread;
    NSThread* sendThread;
    CFDataRef addressData;
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    UIButton* clientBtn;
    UIButton* serverBtn;
}

@end

@implementation SocketViewController

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
    
    
    [self streamSocket];
    
    // Do any additional setup after loading the view.
}

#pragma mark stream 形式的socket
- (void)streamSocket
{
    NSString* urlStr = @"10.178.6.103";
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)urlStr, 8001, &readStream, &writeStream);
    
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
                
                NSString * str = [NSString stringWithFormat:@"zhangxin tet"];
                const uint8_t * rawstring = (const uint8_t *)[str UTF8String];
                [outputStream write:rawstring maxLength:sizeof(rawstring)];
//                [outputStream close];
                LOGINFO(@"send message is :%@ status is :%d", str, outputStream.streamStatus);
                
            }
            break;
        }
            // continued ...
        case NSStreamEventNone: {
            LOGINFO(@"none");
            break;
        }
        case NSStreamEventOpenCompleted: {
            LOGINFO(@"Open Completed");
            break;
        }
        case NSStreamEventHasBytesAvailable: {
            //            NSLog(@"HasBytesAvailable");
            if (stream == inputStream){
                uint8_t buffer[100];
                [inputStream read:buffer maxLength:sizeof(buffer)];
                LOGINFO(@"%s", buffer);
            }
            break;
        }
        case NSStreamEventErrorOccurred: {
            LOGINFO(@"ErrorOccurred");
            break;
        }
        case NSStreamEventEndEncountered: {
            LOGINFO(@"End Encountered");
            break;
        }
    }
}

#pragma mark 客户端

-(void)socketWithIPAddress:(NSString*)address port:(NSInteger)port {
    
    if (/* DISABLES CODE */ (1)) {
        struct sockaddr_in addr4;   // IPV4
        memset(&addr4, 0, sizeof(addr4));
        addr4.sin_len = sizeof(addr4);
        addr4.sin_family = AF_INET;
        addr4.sin_port = htons(port);
        addr4.sin_addr.s_addr = inet_addr([address UTF8String]);  // 把字符串的地址转换为机器可识别的网络地址
        addressData = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr4, sizeof(addr4));// 把sockaddr_in结构体中的地址转换为Data
        [self startSocket:NO];
    } else {
        struct sockaddr_in6 addr6;   // IPV6
        memset(&addr6, 0, sizeof(addr6));
        addr6.sin6_len = sizeof(addr6);
        addr6.sin6_family = AF_INET6;
        addr6.sin6_port = htons(port);
        
        inet_pton(AF_INET6, [address UTF8String], &addr6.sin6_addr);
        
        addressData = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr6, sizeof(addr6));
        [self startSocket:YES];
    }
}

- (void)startSocket:(BOOL)isIPv6 {
    
    CFSocketContext sockContext = { 0, // 结构体的版本，必须为0
        (__bridge void *)(self),  // 一个任意指针的数据，可以用在创建时CFSocket对象相关联。这个指针被传递给所有的上下文中定义的回调。
        NULL, // 一个定义在上面指针中的retain的回调， 可以为NULL
        NULL, NULL};
    
    _socket = CFSocketCreate(kCFAllocatorDefault,       // 为新对象分配内存，可以为nil
                             isIPv6 ? PF_INET6 : PF_INET,                   // 协议族，如果为0或者负数，则默认为PF_INET
                             SOCK_STREAM,               // 套接字类型，如果协议族为PF_INET,则它会默认为SOCK_STREAM
                             IPPROTO_TCP,               // 套接字协议，如果协议族是PF_INET且协议是0或者负数，它会默认为IPPROTO_TCP
                             kCFSocketConnectCallBack | kCFSocketReadCallBack | kCFSocketWriteCallBack | kCFSocketDataCallBack | kCFSocketAcceptCallBack,  // 触发回调函数的socket消息类型，具体见Callback Types
                             TCPClientConnectCallBack,  // 上面情况下触发的回调函数
                             &sockContext               // 一个持有CFSocket结构信息的对象，可以为nil
                             );
    
    //Tell Core Foundation that it is allowed to close the socket when the underlying Core Foundation object is invalidated.
    CFOptionFlags sockopt = CFSocketGetSocketFlags(_socket);
    sockopt |= kCFSocketCloseOnInvalidate | kCFSocketAutomaticallyReenableReadCallBack;
    CFSocketSetSocketFlags(_socket, sockopt);
    
    if (_socket != nil) {
        NSLog(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"create socket success");
        socketThread = [[NSThread alloc]initWithTarget:self selector:@selector(socketThreadStart) object:nil];
        [socketThread setName:@"startSocket"];
        [socketThread start];
        
        sendThread = [[NSThread alloc]initWithTarget:self selector:@selector(sendMessage) object:nil];
        [sendThread setName:@"sendMessage"];
        [sendThread start];
    } else {
        NSLog(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"create socket failed");
    }
}

- (void)socketThreadStart {
    
    NSLog(@"%s[line:%d] start thread:%@", __FUNCTION__, __LINE__, [NSThread currentThread]);
    
    CFSocketError status = CFSocketConnectToAddress(_socket, addressData, 3);
    if (status == kCFSocketSuccess) {
        NSLog(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"connect to address success");
        CFRunLoopRef cRunRef = CFRunLoopGetCurrent();
        CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socket, 0);
        CFRunLoopAddSource(cRunRef, sourceRef, kCFRunLoopDefaultMode);
        CFRunLoopRun();
        NSLog(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"run loop stoped");
        
        CFRunLoopRemoveSource(cRunRef, sourceRef, kCFRunLoopCommonModes);
        cRunRef = nil;
        
        if (CFRunLoopSourceIsValid(sourceRef)) {
            CFRunLoopSourceInvalidate(sourceRef);
        }
        CFRelease(sourceRef);
        sourceRef = nil;
        
    } else {
        NSLog(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"connect to address failed");
        [self stopScoket];
    }
}

- (void) stopScoket {
    NSLog(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"stop socket");
    
    if (_socket != nil) {
        NSLog(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"invalidate socket");
        
        if (CFSocketIsValid(_socket)) {
            CFSocketInvalidate(_socket);
        }
        close(CFSocketGetNative(_socket));
        CFRelease(_socket);
        _socket = nil;
    }
    
    if (!socketThread.isCancelled) {
        NSLog(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"cancel socket thread ");
        [socketThread cancel];
        socketThread = nil;
    }
    
    if (!sendThread.isCancelled) {
        NSLog(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"cancel send thread ");
        [sendThread cancel];
        sendThread = nil;
    }
}

/**
 *  socket callback
 *
 *  @param data    Data appropriate for the callback type. For a kCFSocketConnectCallBack that failed in the background, it is a pointer to an
 *                 SInt32 error code; for a kCFSocketAcceptCallBack, it is a pointer to a CFSocketNativeHandle; or for a kCFSocketDataCallBack,
 *                 it is a CFData object containing the incoming data. In all other cases, it is NULL.
 *  @param info    The info member of the CFSocketContext structure that was used when creating the CFSocket object.
 */
void TCPClientConnectCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
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
            NSLog(@"%s[line:%d] receive data is : %@", __FUNCTION__, __LINE__, data);
            NSData* receiveData = [NSData dataWithData:(__bridge NSData * _Nonnull)(data)];
            NSLog(@"%s[line:%d] receive data leghth is : %lu", __FUNCTION__, __LINE__, (unsigned long)receiveData.length);
            dispatch_async(dispatch_get_main_queue(), ^{
                //info 指向的对象调用相应的方法
            });
            break;
        }
        case kCFSocketConnectCallBack: {
            if (data != NULL) {
                // 当socket为kCFSocketConnectCallBack时，失败时回调失败会返回一个错误代码指针，其他情况返回NULL
                NSLog(@"%s[line:%d] %@:error is:%@", __FUNCTION__, __LINE__, @"连接失败", data);
            } else {
                NSLog(@"%s[line:%d] %@", __FUNCTION__, __LINE__, @"连接成功");
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //info 指向的对象调用相应的方法
            });
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

- (void)sendMessage {
    
    while (!sendThread.isCancelled) {
        if (_socket != nil) {
            NSData* data = [@"aaa" dataUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%s[line:%d] send message:%@", __FUNCTION__, __LINE__, data);
            
            CFDataRef sendData = CFDataCreate(kCFAllocatorDefault, [data bytes], data.length + 1);
            CFSocketError error = CFSocketSendData(_socket, addressData, sendData, 10);
            if (error == kCFSocketSuccess) {
                NSLog(@"%s[line:%d] send message result is:%@", __FUNCTION__, __LINE__, @"success");
            } else {
                NSLog(@"%s[line:%d] send message result is:%@", __FUNCTION__, __LINE__, @"failed");
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }
            
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 服务器端
static CFWriteStreamRef outputStream = NULL;

// 开辟一个线程线程函数中
-(void)runLoopInThread {
    int res = [self initSocketService];
    if (!res) {
        exit(1);
    }
    CFRunLoopRun();    // 运行当前线程的CFRunLoop对象
}

-(int)initSocketService{

    _socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM,IPPROTO_TCP, kCFSocketAcceptCallBack, TCPServerAcceptCallBack, NULL);
    if (NULL == _socket) {
        NSLog(@"Cannot create socket!");
        return 0;
    }
    
    int optval = 1;
    setsockopt(CFSocketGetNative(_socket), SOL_SOCKET, SO_REUSEADDR, // 允许重用本地地址和端口
               (void *)&optval, sizeof(optval));
    
    struct sockaddr_in addr4;
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
    addr4.sin_port = htons(8888);
    addr4.sin_addr.s_addr = htonl(INADDR_ANY);
    CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8*)&addr4, sizeof(addr4));
    
    if (kCFSocketSuccess != CFSocketSetAddress(_socket, address)) {
        NSLog(@"Bind to address failed!");
        if (_socket)
            CFRelease(_socket);
        _socket = NULL;
        return 0;
    }
    
    CFRunLoopRef cfRunLoop = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault,_socket, 0);
    CFRunLoopAddSource(cfRunLoop, source, kCFRunLoopCommonModes);
    CFRelease(source);
    
    return 1;
}
// socket回调函数，同客户端
void TCPServerAcceptCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void*info) {
    if (kCFSocketAcceptCallBack == type) {
        // 本地套接字句柄
        CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle *)data;
        uint8_t name[SOCK_MAXADDRLEN];
        socklen_t nameLen = sizeof(name);
        if (0 != getpeername(nativeSocketHandle, (struct sockaddr *)name,&nameLen)) {
            NSLog(@"error");
            exit(1);
        }
        NSLog(@"%s connected.", inet_ntoa( ((struct sockaddr_in*)name)->sin_addr ));
        CFReadStreamRef iStream;
        CFWriteStreamRef oStream;
        // 创建一个可读写的socket连接
        CFStreamCreatePairWithSocket(kCFAllocatorDefault,nativeSocketHandle, &iStream, &oStream);
        if (iStream && oStream) {
            CFStreamClientContext streamContext = {0, NULL, NULL, NULL};
            if (!CFReadStreamSetClient(iStream, kCFStreamEventHasBytesAvailable,
                                       readStream, // 回调函数，当有可读的数据时调用
                                       &streamContext)){
                exit(1);
            }

            if (!CFWriteStreamSetClient(oStream, kCFStreamEventCanAcceptBytes, writeStream, &streamContext)){
                exit(1);
            }
            CFReadStreamScheduleWithRunLoop(iStream, CFRunLoopGetCurrent(),kCFRunLoopCommonModes);
            CFWriteStreamScheduleWithRunLoop(oStream, CFRunLoopGetCurrent(),kCFRunLoopCommonModes);
            CFReadStreamOpen(iStream);
            CFWriteStreamOpen(oStream);
        } else {
            close(nativeSocketHandle);
        }
    }
}
// 读取数据
void readStream(CFReadStreamRef stream,CFStreamEventType eventType, void *clientCallBackInfo) {
    UInt8 buff[255];
    CFReadStreamRead(stream, buff, 255);
    printf("received: %s", buff);
}

void writeStream (CFWriteStreamRef stream, CFStreamEventType eventType, void *clientCallBackInfo) {
    outputStream = stream;
//}
//main {
    char *str = "nihao";
    
    if (outputStream != NULL) {
        CFWriteStreamWrite(outputStream, (const UInt8*)str, strlen(str) + 1);
    } else {
        NSLog(@"Cannot send data!");
    }
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
