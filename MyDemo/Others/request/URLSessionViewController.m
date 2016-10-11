//
//  URLSessionViewController.m
//  MyDemo
//
//  Created by 张鑫 on 16/9/28.
//  Copyright © 2016年 zhangxin. All rights reserved.
//

#import "URLSessionViewController.h"

#import "AppDelegate.h"

@interface URLSessionViewController () <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate> {
    NSURLSession *session;
    NSURLSessionDownloadTask *downloadTask;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-----------------------------
#pragma mark NSURLSession 相关用法
//-----------------------------

static NSString *DownloadURLString = @"https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/ObjC_classic/FoundationObjC.pdf";

- (NSURLSession *)backgroundSession {
    static NSURLSession *_session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.example.apple-samplecode.SimpleBackgroundTransfer.BackgroundSession"];
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    });
    return _session;
}

- (void)start:(id)sender {
    if (downloadTask) {
        return;
    }
    NSURL *downloadURL = [NSURL URLWithString:DownloadURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    downloadTask = [session downloadTaskWithRequest:request];
    [downloadTask resume];
    progressView.hidden = NO;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)_downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (_downloadTask == downloadTask) {
        double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"DownloadTask: %@ progress: %lf", _downloadTask, progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            progressView.progress = progress;
        });
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)_downloadTask didFinishDownloadingToURL:(NSURL *)downloadURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [URLs objectAtIndex:0];
    NSURL *originalURL = [[_downloadTask originalRequest] URL];
    NSURL *destinationURL = [documentsDirectory URLByAppendingPathComponent:[originalURL lastPathComponent]];
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
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error == nil) {
        NSLog(@"Task: %@ completed successfully", task);
    } else {
        NSLog(@"Task: %@ completed with error: %@", task, [error localizedDescription]);
    }
    double progress = (double)task.countOfBytesReceived / (double)task.countOfBytesExpectedToReceive;
    dispatch_async(dispatch_get_main_queue(), ^{
        progressView.progress = progress;
    });
    downloadTask = nil;
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

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task  didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
    
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
