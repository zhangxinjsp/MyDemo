//
//  URLSessionViewController.m
//  MyDemo
//
//  Created by 张鑫 on 16/9/28.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "URLSessionViewController.h"

#import "AppDelegate.h"

@interface URLSessionViewController () <NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate, NSURLSessionStreamDelegate, NSURLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate> {
    
    NSURLSessionConfiguration *configuration;
    NSURLSession *session;
    
    NSURLSessionDownloadTask *downloadTask;
    NSURLSessionDataTask * dataTask;
    UIDocumentInteractionController *documentInteractionController;
    UIProgressView *progressView;
    
}

@end

@implementation URLSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    session = [self backgroundSession];
    
    
    progressView.progress = 0;
    progressView.hidden = YES;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self startLoadData];
    [self startDownload:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NSURLSessionConfiguration

//-----------------------------
#pragma mark NSURLSession 相关用法
//-----------------------------

static NSString *DownloadURLString = @"https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/ObjC_classic/FoundationObjC.pdf";

- (NSURLSession *)backgroundSession {
    static NSURLSession *_session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//                      [NSURLSessionConfiguration backgroundSessionConfiguration:@""];iOS8之后不用了
//        configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"identify"];
        configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        configuration.timeoutIntervalForRequest = 30;
        configuration.timeoutIntervalForResource = 30;
        configuration.networkServiceType = NSURLNetworkServiceTypeDefault;
        configuration.allowsCellularAccess = YES;
        configuration.discretionary = YES;
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    });
    return _session;
}

- (void)startDownload:(id)sender {
    if (downloadTask) {
        return;
    }
    NSString* url = @"http://kohlertest.archermind.com/resource/headpic/20161110094115893_703452_65.jpg";
    NSURL *downloadURL = [NSURL URLWithString:url ];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    downloadTask = [session downloadTaskWithRequest:request];
    [downloadTask resume];
    progressView.hidden = NO;
}

- (void)startLoadData {
    if (dataTask) {
        return;
    }
//    dataTask = [session dataTaskWithRequest:[self requestGET]];
    dataTask = [session dataTaskWithRequest:[self requestPOST]];
//    dataTask = [session dataTaskWithRequest:[self requestPOSTForm]];
    [dataTask resume];
//    LOGINFO(@"data task delegate :%@", dataTask);
}

- (NSURLRequest*)requestGET {
    NSURL* dataURL = [NSURL URLWithString:@"http://localhost:80/PHPProjects/TestProject1/TestPHPFile/AppInterface.php?FirstName=Peter&web=W3school.com.cn"];
    
    NSURLRequest* req = [NSURLRequest requestWithURL:dataURL];
    return req;
}

- (NSMutableURLRequest*)requestPOST {
    NSDictionary* dict = @{@"FirstName" : @"aaaaaa",
                           @"LastName"  : @"bbbbbbbb",
                           @"Age"       : @"12"};
    
    NSData *myRequestData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSURL* dataURL = [NSURL URLWithString:@"http://localhost:80/PHPProjects/TestProject1/TestPHPFile/AppInterface.php"];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:dataURL];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPBody:myRequestData];
    [req setHTTPMethod:@"POST"];
    
    return req;
}

- (NSMutableURLRequest*)requestPOSTForm {
    NSDictionary* dict = @{@"FirstName" : @"aaaaaa",
                           @"LastName"  : @"bbbbbbbb",
                           @"Age"       : @"12"};
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //添加分界线，换行
    [myRequestData appendData:[[NSString stringWithFormat:@"%@\r\n",MPboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //添加字段名称，换2行
    [myRequestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";\r\n\r\n", @"args"] dataUsingEncoding:NSUTF8StringEncoding]];
//添加字段的值
    [myRequestData appendData:[[NSString stringWithFormat:@"%@", @"asd"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //参数的集合的所有key的集合
    NSArray *keys= [dict allKeys];
    //遍历keys
    for(int i = 0; i < [keys count]; i++)
    {
        //得到当前key
        NSString *key = [keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        ////添加分界线，换行
        [myRequestData appendData:[[NSString stringWithFormat:@"\r\n%@\r\n",MPboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //声明pic字段，文件名为boris.png
        [myRequestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //有filename的适用于文件上传的
//        [myRequestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",key,[NSString stringWithFormat:@"pic%d", i]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //声明上传文件的格式
        [myRequestData appendData:[[NSString stringWithFormat:@"Content-Type: text/html\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //将image的data加入
        //        [myRequestData appendData:[imageDict objectForKey:key]];
        [myRequestData appendData:[dict[key] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@\r\n",endMPboundary];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    LOGINFO(@"\n%@", [[NSString alloc]initWithData:myRequestData encoding:NSUTF8StringEncoding]);
    
    NSURL* dataURL = [NSURL URLWithString:@"http://localhost:80/PHPProjects/TestProject1/TestPHPFile/AppInterface.php"];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:dataURL];
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    [req setValue:content forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPBody:myRequestData];
    [req setHTTPMethod:@"POST"];
    
    return req;
}
#pragma mark session delegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
    LOGINFO(@"All tasks are finished");
}

#pragma mark NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response         newRequest:(NSURLRequest *)request  completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    completionHandler(nil);
    LOGINFO(@"");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task  didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
    LOGINFO(@"");
    // 判断是否是信任服务器证书
    //    if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
    //        // 告诉服务器，客户端信任证书
    //        // 创建凭据对象
    //        NSURLCredential *credntial = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    //        // 通过completionHandler告诉服务器信任证书
    //        completionHandler(NSURLSessionAuthChallengeUseCredential, credntial);
    //    }
    //    NSLog(@"protectionSpace = %@",challenge.protectionSpace);
    
    SecIdentityRef identity = NULL;
    SecTrustRef trust = NULL;
    NSData *PKCS12Data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"]];
    if ([self extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data]) {
        SecCertificateRef certificate = NULL;
        SecIdentityCopyCertificate (identity, &certificate);
        //TODO:方法可能需要修改
        NSArray *certs = @[CFBridgingRelease(certificate)];
        
        NSURLCredential *credential = [NSURLCredential credentialWithIdentity:identity certificates:certs persistence:NSURLCredentialPersistencePermanent];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task  needNewBodyStream:(void (^)(NSInputStream * _Nullable bodyStream))completionHandler {
    LOGINFO(@"");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    LOGINFO(@"");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
    LOGINFO(@"");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error == nil) {
        LOGINFO(@"Task: %@ completed successfully", task);
    } else {
        LOGINFO(@"Task: %@ completed with error: %@", task, [error localizedDescription]);
    }
    double progress = (double)task.countOfBytesReceived / (double)task.countOfBytesExpectedToReceive;
    dispatch_async(dispatch_get_main_queue(), ^{
        progressView.progress = progress;
    });
    downloadTask = nil;
}

#pragma mark  NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    LOGINFO(@"receive response is %@", response);
    
    completionHandler(NSURLSessionResponseAllow);
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    LOGINFO(@"");
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask {
    LOGINFO(@"");
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    id dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if (dict != nil) {
        LOGINFO(@"\n type:%@ \n%@", [dict class], dict);
    } else {
        LOGINFO(@"data is :<<<%@>>>", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]  );
    }
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler {
    LOGINFO(@"");
    completionHandler(nil);
}

#pragma mark NSURLSessionDownloadDelegate <NSURLSessionTaskDelegate>

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)_downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (_downloadTask == downloadTask) {
        double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        LOGINFO(@"DownloadTask: %@ progress: %lf", _downloadTask, progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            progressView.progress = progress;
        });
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)_downloadTask didFinishDownloadingToURL:(NSURL *)downloadURL {
    
    LOGINFO(@"download url %@", downloadURL);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [URLs objectAtIndex:0];
    NSURL *originalURL = [[_downloadTask originalRequest] URL];
    NSURL *destinationURL = [documentsDirectory URLByAppendingPathComponent:[originalURL lastPathComponent]];
    
    LOGINFO(@"save url %@", destinationURL);
    
    NSError *errorCopy;
    // For the purposes of testing, remove any esisting file at the destination.
    [fileManager removeItemAtURL:destinationURL error:NULL];
    BOOL success = [fileManager copyItemAtURL:downloadURL toURL:destinationURL error:&errorCopy];
    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //download finished - open the pdf
            documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:destinationURL];
            // Configure Document Interaction Controller
            [documentInteractionController setDelegate:self];
            // Preview PDF
            [documentInteractionController presentPreviewAnimated:YES];
            progressView.hidden = YES;
        });
    } else {
        NSLog(@"Error during the copy: %@", [errorCopy localizedDescription]);
    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    LOGINFO(@"");
}

#pragma mark NSURLSessionStreamDelegate <NSURLSessionTaskDelegate>

- (void)URLSession:(NSURLSession *)session readClosedForStreamTask:(NSURLSessionStreamTask *)streamTask {
    LOGINFO(@"");
}

- (void)URLSession:(NSURLSession *)session writeClosedForStreamTask:(NSURLSessionStreamTask *)streamTask {
    LOGINFO(@"");
}

- (void)URLSession:(NSURLSession *)session betterRouteDiscoveredForStreamTask:(NSURLSessionStreamTask *)streamTask {
    LOGINFO(@"");
}

- (void)URLSession:(NSURLSession *)session streamTask:(NSURLSessionStreamTask *)streamTask didBecomeInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream {
    LOGINFO(@"");
}






- (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data
{
    OSStatus securityError = errSecSuccess;
    
    //  NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObject:@"" forKey:(id)kSecImportExportPassphrase];
    
    CFStringRef password = CFSTR("1234"); //证书密码
    const void *keys[] =   { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys,values, 1,NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((CFDataRef)inPKCS12Data,(CFDictionaryRef)optionsDictionary,&items);
    
    if (securityError == errSecSuccess) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"Failed with error code %d",(int)securityError);
        return NO;
    }
    return YES;
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
