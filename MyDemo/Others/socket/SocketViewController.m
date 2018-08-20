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
