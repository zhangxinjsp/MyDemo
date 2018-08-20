//
//  ViewController.m
//  ScoketServer
//
//  Created by zhangxin on 16/2/24.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "SocketServiceViewController.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

#import <AddressBook/AddressBook.h>

@interface SocketServiceViewController () {
    CFSocketRef _socket;
}

@end

@implementation SocketServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self runLoopInThread];
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
    NSLog(@"connect 12312312513452452345");
    //    return;
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

@end
