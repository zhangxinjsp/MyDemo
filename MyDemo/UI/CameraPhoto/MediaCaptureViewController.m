//
//  MediaCaptureViewController.m
//  UINavgationController
//
//  Created by 张鑫 on 15/5/30.
//  Copyright (c) 2015年 zhangxin. All rights reserved.
//

#import "MediaCaptureViewController.h"

#import <OpenGLES/EAGL.h>
#import <GLKit/GLKit.h>
#import <CoreLocation/CoreLocation.h>
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <Photos/Photos.h>

#define VIDEO_PREVIEW_LAYER 1

@interface MediaCaptureViewController() <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate, AVCaptureMetadataOutputObjectsDelegate>{
    
    UIButton* recordingButton;
    UIButton* stillImageButton;
    UIButton* cameraButton;
    UIButton* QRCodeButton;
    
    UIBackgroundTaskIdentifier backgroundRecordingID;
    
    
    
    //**********************************//
    AVCaptureSession* captureSession;
    
    EAGLContext* glContext;
    GLKView* glView;
    CIContext* ciContext;
    
    AVCaptureDeviceInput* cameraDeviceInput;
    
    AVCaptureVideoPreviewLayer* previewLayer;
    
    AVCaptureMovieFileOutput *aMovieFileOutput;
    AVCaptureStillImageOutput* stillImageOutput;
    AVCaptureVideoDataOutput *videoDataOutput;
    AVCaptureAudioDataOutput *audioDataOutput;
    AVCaptureMetadataOutput * metadataOutput;
}

@end

@implementation MediaCaptureViewController




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self initControls];
    [self checkAuthorizationStatus];
    backgroundRecordingID = UIBackgroundTaskInvalid;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusAndExposeTap:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)viewWillAppear:(BOOL)animated
{
//    return;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(captureSessionRuntimeErrorNotification:) name:AVCaptureSessionRuntimeErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(captureDeviceWasConnectedNotification:) name:AVCaptureDeviceWasConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(captureDeviceWasDisconnectedNotification:) name:AVCaptureDeviceWasDisconnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[cameraDeviceInput device]];
    
    if (captureSession) {
        [captureSession startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
//    return;
    [captureSession stopRunning];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVCaptureSessionRuntimeErrorNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVCaptureDeviceWasConnectedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVCaptureDeviceWasDisconnectedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[cameraDeviceInput device]];
    
}

- (void)initControls {
    recordingButton = [[UIButton alloc]init];
    recordingButton.backgroundColor = [UIColor redColor];
    [recordingButton setTitle:@"record" forState:UIControlStateNormal];
    [recordingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [recordingButton addTarget:self action:@selector(recordingAction:) forControlEvents:UIControlEventTouchUpInside];
    recordingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:recordingButton];
    
    stillImageButton = [[UIButton alloc]init];
    stillImageButton.backgroundColor = [UIColor redColor];
    [stillImageButton setTitle:@"still" forState:UIControlStateNormal];
    [stillImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [stillImageButton addTarget:self action:@selector(stillImageAction:) forControlEvents:UIControlEventTouchUpInside];
    stillImageButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stillImageButton];
    
    cameraButton = [[UIButton alloc]init];
    cameraButton.backgroundColor = [UIColor redColor];
    [cameraButton setTitle:@"camera" forState:UIControlStateNormal];
    [cameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:cameraButton];
    
    QRCodeButton = [[UIButton alloc]init];
    QRCodeButton.backgroundColor = [UIColor redColor];
    [QRCodeButton setTitle:@"二维码" forState:UIControlStateNormal];
    [QRCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [QRCodeButton addTarget:self action:@selector(qrCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    QRCodeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:QRCodeButton];
    
    NSDictionary* viewDict = NSDictionaryOfVariableBindings(recordingButton, stillImageButton, cameraButton, QRCodeButton);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[recordingButton(==30)]-(>=10)-|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:viewDict]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[recordingButton(>=0)]-10-[stillImageButton(==recordingButton)]-10-[cameraButton(==recordingButton)]-10-[QRCodeButton(==recordingButton)]-10-|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:viewDict]];
}

- (void)recordingAction:(id)sender {
    if (aMovieFileOutput.recording) {
        [self stopRecordingMovieFile];
    } else {
        [self startRecordingMovieFile];
    }
}

- (void)stillImageAction:(id)sender {
    [self captureStillImage];
}

- (void)cameraAction:(id)sender {
    
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    [self switchCameraDevice:btn.selected];
}

- (void)qrCodeAction:(id)sender{
    LOGINFO(@"二维码扫描");
    [self metadataOutput];
    
    
    
}

#pragma mark AVFoundation Still and Video Media Capture 只是其中的一部份
//https://developer.apple.com/library/ios/documentation/AudioVideo/Conceptual/AVFoundationPG/Articles/04_MediaCapture.html#//apple_ref/doc/uid/TP40010188-CH5-SW2
- (void)checkAuthorizationStatus {
    
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authorizationStatus) {
        case AVAuthorizationStatusNotDetermined: {
            //许可对话框没有出现，可以发起授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    LOGINFO(@"得到授权 可以继续");
                    [self startCaptureSession];
                } else {
                    LOGINFO(@"未得到授权");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:@"AVCam!"
                                                    message:@"AVCam doesn't have permission to use Camera, please change privacy settings"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil] show];
                        //                        [self setDeviceAuthorized:NO];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusRestricted: {
            LOGINFO(@"相机设备无法访问");
            break;
        }
        case AVAuthorizationStatusDenied: {
            LOGINFO(@"用户拒绝");
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            LOGINFO(@"已经得到授权 可以继续");
            [self startCaptureSession];
            break;
        }
        default: {
            break;
        }
    }
}

- (void)startCaptureSession {
    
    
    captureSession = [[AVCaptureSession alloc]init];
    /**
     *  后面有具体XXX＊xxx的都需要进行判断
     */
    if ([captureSession canSetSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
        //然后再进行设置
    }
//    [captureSession setSessionPreset:AVCaptureSessionPresetHigh];
//AVCaptureSessionPresetPhoto 只能进行still photo ， recoding movie 的时候会crash
    captureSession.sessionPreset = AVCaptureSessionPresetLow;
    
    
    [self deviceInput];
    [self showVideoPreview];
//    [self captureMovieFileOutput];
//    [self captureStillImageOutput];

    [self captureVideoDataOutput];
//    [self audioDataOutput];
//    [self metadataOutput];
    
    [captureSession startRunning];
}

- (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
    //  设置闪关灯
    if ([device hasFlash] && [device isFlashModeSupported:flashMode])
    {
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            [device setFlashMode:flashMode];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
    }
}

- (void)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint devicePoint = [previewLayer captureDevicePointOfInterestForPoint:[gestureRecognizer locationInView:[gestureRecognizer view]]];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)subjectAreaDidChange:(NSNotification *)notification
{
    CGPoint devicePoint = CGPointMake(.5, .5);
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
    
    AVCaptureDevice *device = [cameraDeviceInput device];
    NSError *error = nil;
    if ([device lockForConfiguration:&error])
    {
        if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode])
        {
            [device setFocusMode:focusMode];
            [device setFocusPointOfInterest:point];
        }
        if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode])
        {
            [device setExposureMode:exposureMode];
            [device setExposurePointOfInterest:point];
        }
        [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
        [device unlockForConfiguration];
    }
    else
    {
        NSLog(@"%@", error);
    }
}

- (void)switchCameraDevice:(BOOL)frount{
    
    AVCaptureDevice *currentVideoDevice = [cameraDeviceInput device];
    AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
    AVCaptureDevicePosition currentPosition = [currentVideoDevice position];
    
    switch (currentPosition)
    {
        case AVCaptureDevicePositionUnspecified:
            preferredPosition = AVCaptureDevicePositionBack;
            break;
        case AVCaptureDevicePositionBack:
            preferredPosition = AVCaptureDevicePositionFront;
            break;
        case AVCaptureDevicePositionFront:
            preferredPosition = AVCaptureDevicePositionBack;
            break;
    }
    
    AVCaptureDevice *videoDevice;
    
    NSArray* availableCameraDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in availableCameraDevices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == preferredPosition) {
                videoDevice = device;
                break;
            }
        }
    }
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    
    [captureSession beginConfiguration];
    
    [captureSession removeInput:cameraDeviceInput];
    if ([captureSession canAddInput:videoDeviceInput]){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];
        
        [self setFlashMode:AVCaptureFlashModeAuto forDevice:[videoDeviceInput device]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDevice];
        
        [captureSession addInput:videoDeviceInput];
        cameraDeviceInput = videoDeviceInput;
        
    } else {
        [captureSession addInput:cameraDeviceInput];
    }
    
    [captureSession commitConfiguration];
}

- (void)deviceInput {
    /*
     NSArray* availableCameraDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
     
     NSArray *devices = [AVCaptureDevice devices];
     for (AVCaptureDevice *device in devices) {
     LOGINFO(@"Device name: %@", [device localizedName]);
     if ([device hasMediaType:AVMediaTypeVideo]) {
     if ([device position] == AVCaptureDevicePositionBack) {
     LOGINFO(@"Device position : back");
     cameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
     } else {
     LOGINFO(@"Device position : front");
     cameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
     }
     } else if ([device hasMediaType:AVMediaTypeAudio]) {
     LOGINFO(@"Device Type: audio");
     AVCaptureDeviceInput* audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
     if ([captureSession canAddInput:audioDeviceInput]) {
     [captureSession addInput:audioDeviceInput];
     }
     }
     }
     */
    
    NSError* error;
    
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput* audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
    if ([captureSession canAddInput:audioDeviceInput]) {
        [captureSession addInput:audioDeviceInput];
    }
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    cameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if ([captureSession canAddInput:cameraDeviceInput]) {
        [captureSession addInput:cameraDeviceInput];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        // Why are we dispatching this to the main queue?
        // Because AVCaptureVideoPreviewLayer is the backing layer for AVCamPreviewView and UIView can only be manipulated on main thread.
        // Note: As an exception to the above rule, it is not necessary to serialize video orientation changes on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
        
        [[previewLayer connection] setVideoOrientation:(AVCaptureVideoOrientation)[self interfaceOrientation]];
    });

}

- (void)showVideoPreview{
#ifdef VIDEO_PREVIEW_LAYER
    //    使用AVCaptureVideoPreviewLayer 来显示视频效果
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.frame = self.view.bounds;
    [previewLayer setSession:captureSession];
    [previewLayer.connection setVideoOrientation:(AVCaptureVideoOrientation)[self interfaceOrientation]];
    [previewLayer.connection setAutomaticallyAdjustsVideoMirroring:YES];
//    [previewLayer.connection setVideoMirrored:YES];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.view.layer addSublayer:previewLayer];
#else
    //    从输出数据流中捕获单一的图像帧
    //    -(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection中处理的
    glContext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    glView = [[GLKView alloc]initWithFrame:CGRectMake(0, 100, 320, 320) context:glContext];
    ciContext = [CIContext contextWithEAGLContext:glContext];
    
    glView.backgroundColor = [UIColor redColor];
    glView.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.view addSubview:glView];
#endif
}

//设置方向
- (void)setCaptureVideoOrientation {
    AVCaptureConnection *captureConnection = [stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if ([captureConnection isVideoOrientationSupported])
    {
        AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationLandscapeLeft;
        [captureConnection setVideoOrientation:orientation];
    }
}

#pragma mark  静态图片的处理
- (void)captureStillImageOutput{
    stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    
    NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG};
    [stillImageOutput setOutputSettings:outputSettings];
    
    if ([captureSession canAddOutput:stillImageOutput]) {
        [captureSession addOutput:stillImageOutput];
    }
}

- (void)captureStillImage {
    
    [self setFlashMode:AVCaptureFlashModeAuto forDevice:[cameraDeviceInput device]];
    
    // Update the orientation on the still image output video connection before capturing.
    //也可以使用stillImageOutput.connections遍历 用AVCaptureInputPort mediaType来寻找
    AVCaptureConnection *videoConnection = [stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    [videoConnection setVideoOrientation:[[previewLayer connection] videoOrientation]];
    [videoConnection setVideoScaleAndCropFactor:20];
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        //        CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(imageSampleBuffer);
        //        CIImage* ciImage = [[CIImage alloc]initWithCVPixelBuffer:pixelBuffer];
        //        UIImage* image = [[UIImage alloc]initWithCIImage:ciImage];
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
        
        CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
        if (exifAttachments) {
            // Do something with the attachments.
            LOGINFO(@"%@", exifAttachments);
        }
        // Continue as appropriate.
    }];
}

#pragma mark movie file 处理
- (void)captureMovieFileOutput{
    aMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
//    CMTime maxDuration = CMTimeMake(300, 1);//Create a CMTime to represent the maximum duration;
//    aMovieFileOutput.maxRecordedDuration = maxDuration;
//    aMovieFileOutput.minFreeDiskSpaceLimit = 300;//An appropriate minimum given the quality of the movie format and the duration;
    
    if ([captureSession canAddOutput:aMovieFileOutput]) {
        [captureSession addOutput:aMovieFileOutput];
        
        AVCaptureConnection *connection = [aMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([connection isVideoStabilizationSupported])
            [connection setEnablesVideoStabilizationWhenAvailable:YES];
    }
    
//    [self setMovieFileOutputMetadata];
}

- (void)setMovieFileOutputMetadata {
    //    You can set metadata for the movie file at any time, even while recording
    NSArray *existingMetadataArray = aMovieFileOutput.metadata;
    NSMutableArray *newMetadataArray = nil;
    if (existingMetadataArray) {
        newMetadataArray = [existingMetadataArray mutableCopy];
    }
    else {
        newMetadataArray = [[NSMutableArray alloc] init];
    }
    CLLocation *location = [[CLLocationManager alloc]init].location;
    
    AVMutableMetadataItem *item = [[AVMutableMetadataItem alloc] init];
    item.keySpace = AVMetadataKeySpaceCommon;
    item.key = AVMetadataCommonKeyLocation;
    item.value = [NSString stringWithFormat:@"%+08.4lf%+09.4lf/", location.coordinate.latitude, location.coordinate.longitude];
    
    [newMetadataArray addObject:item];
    
    aMovieFileOutput.metadata = newMetadataArray;
}

- (void)startRecordingMovieFile{
    
    if ([[UIDevice currentDevice] isMultitaskingSupported])
    {
        // Setup background task. This is needed because the captureOutput:didFinishRecordingToOutputFileAtURL: callback is not received until AVCam returns to the foreground unless you request background execution time. This also ensures that there will be time to write the file to the assets library when AVCam is backgrounded. To conclude this background execution, -endBackgroundTask is called in -recorder:recordingDidFinishToOutputFileURL:error: after the recorded file has been saved.
        backgroundRecordingID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    }
    
    // Update the orientation on the movie file output video connection before starting recording.
    [[aMovieFileOutput connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[previewLayer connection] videoOrientation]];
    NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecH264};
    [aMovieFileOutput setOutputSettings:outputSettings forConnection:[previewLayer connection]];
    
    [self setFlashMode:AVCaptureFlashModeOff forDevice:[cameraDeviceInput device]];
    
    NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"movie" stringByAppendingPathExtension:@"mov"]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//取出需要的路径
    NSString* filePath = [documentsDirectory stringByAppendingPathComponent:@"movie.mov"];
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];//A file URL that identifies the output location;
    if ([[NSFileManager defaultManager]fileExistsAtPath:outputFilePath]) {
        [[NSFileManager defaultManager]removeItemAtURL:fileURL error:nil];
    }
    @try {
        [aMovieFileOutput startRecordingToOutputFileURL:fileURL recordingDelegate:self];
    }
    @catch (NSException *exception) {
        LOGINFO(@"%@", exception);
    }
    
}

- (void)stopRecordingMovieFile{
    
    [aMovieFileOutput stopRecording];
}

#pragma mark 二维码扫描
- (void)metadataOutput {
    metadataOutput = [[AVCaptureMetadataOutput alloc]init];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    [metadataOutput setRectOfInterest:CGRectMake(100, 100, 100, 100)];
    
    if ([captureSession canAddOutput:metadataOutput]) {
        [captureSession addOutput:metadataOutput];
    }
    
    for (NSString* type in metadataOutput.availableMetadataObjectTypes) {
        LOGINFO(@"%@", type);
        if ([type isEqualToString:AVMetadataObjectTypeQRCode]) {
            [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        } else {
            
        }
    }
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject* object = metadataObjects[0];
        LOGINFO(@"%@", object);
    } else {
        LOGINFO(@"%@", @"nothing");
    }
}


#pragma mark audio data output
- (void)audioDataOutput {
    audioDataOutput = [[AVCaptureAudioDataOutput alloc]init]; //Get the audio data output
    
    if ([captureSession canAddOutput:audioDataOutput]) {
        [captureSession addOutput:audioDataOutput];
    }
}

-(void)captureAudioChannelLevel{
    
    NSArray *connections = audioDataOutput.connections;
    if ([connections count] > 0) {
        // There should be only one connection to an AVCaptureAudioDataOutput.
        AVCaptureConnection *connection = [connections objectAtIndex:0];
        
        NSArray *audioChannels = connection.audioChannels;
        
        for (AVCaptureAudioChannel *channel in audioChannels) {
            float avg = channel.averagePowerLevel;
            float peak = channel.peakHoldLevel;
            LOGINFO(@"averagePowerLevel %f peakHoldLevel :%f", avg, peak);
            // Update the level meter user interface.
        }
    }
}

#pragma mark video的处理
- (void)captureVideoDataOutput{
    
    videoDataOutput = [[AVCaptureVideoDataOutput alloc]init];
    //    currently, the only supported key is kCVPixelBufferPixelFormatTypeKey.
    
    //    NSArray* cVPixelFormatTypes = [videoDataOutput availableVideoCVPixelFormatTypes];
    //    NSArray* codecTypes = [videoDataOutput availableVideoCodecTypes];
    
    NSDictionary *newSettings = @{(NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
    
    videoDataOutput.videoSettings = newSettings;
    
    // discard if the data output queue is blocked (as we process the still image
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:NO];
    
    // create a serial dispatch queue used for the sample buffer delegate as well as when a still image is captured
    // a serial dispatch queue must be used to guarantee that video frames will be delivered in order
    // see the header doc for setSampleBufferDelegate:queue: for more information
    dispatch_queue_t videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
    
    if ([captureSession canAddOutput:videoDataOutput]) {
        [captureSession addOutput:videoDataOutput];
    }
}

#pragma mark 视频帧处理里 AVCaptureVideoDataOutputSampleBufferDelegate
//AVCaptureVideoDataOutputSampleBufferDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    LOGINFO(@" didOutputSampleBuffer");
    
    
    
//    CMBlockBufferRef blockBufferRef = CMSampleBufferGetDataBuffer(sampleBuffer);
//    size_t length = CMBlockBufferGetDataLength(blockBufferRef);
//    Byte buffer[length];
//    CMBlockBufferCopyDataBytes(blockBufferRef, 0, length, buffer);
//    NSData *data = [NSData dataWithBytes:buffer length:length];
//    
//    LOGINFO(@"data :%@", data);
    
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CIImage* ciImage = [[CIImage alloc]initWithCVPixelBuffer:pixelBuffer];
    LOGINFO(@"data :%@", ciImage);
#ifdef VIDEO_PREVIEW_LAYER
    
#else
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CIImage* ciImage = [[CIImage alloc]initWithCVPixelBuffer:pixelBuffer];
    //    UIImage* image = [[UIImage alloc]initWithCIImage:ciImage];
    //    UIImage *image = imageFromSampleBuffer(sampleBuffer);
    
    if (glContext != [EAGLContext currentContext]) {
        [EAGLContext setCurrentContext:glContext];
    }
    
    [glView bindDrawable];
    [ciContext drawImage:ciImage inRect:ciImage.extent fromRect:ciImage.extent];
    [glView display];
#endif
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    LOGINFO(@"didDropSampleBuffer");
    CMBlockBufferRef blockBufferRef = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t length = CMBlockBufferGetDataLength(blockBufferRef);
    Byte buffer[length];
    CMBlockBufferCopyDataBytes(blockBufferRef, 0, length, buffer);
    NSData *data = [NSData dataWithBytes:buffer length:length];
    LOGINFO(@"%@", data);
}

//AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    LOGINFO(@"didStartRecordingToOutputFileAtURL :%@ ",fileURL.absoluteString);
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    LOGINFO(@"didFinishRecordingToOutputFileAtURL :%@ ",outputFileURL.absoluteString);
    
    BOOL recordedSuccessfully = YES;
    if ([error code] != noErr) {
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value) {
            recordedSuccessfully = [value boolValue];
        }
    }
    // Continue as appropriate...
    UIBackgroundTaskIdentifier backgRecordingID = backgroundRecordingID;
    backgroundRecordingID = UIBackgroundTaskInvalid;
    
    if (recordedSuccessfully) {
        [[[ALAssetsLibrary alloc] init] writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error)
                NSLog(@"%@", error);
            
            [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
            
            if (backgRecordingID != UIBackgroundTaskInvalid)
                [[UIApplication sharedApplication] endBackgroundTask:backgRecordingID];
        }];
    }
}


#pragma mark NSNotification
-(void)captureSessionRuntimeErrorNotification:(NSNotification*)noti {
    LOGINFO(@"captureSessionRuntimeErrorNotification");
}

-(void)captureDeviceWasConnectedNotification:(NSNotification*)noti {
    LOGINFO(@"captureDeviceWasConnectedNotification");
}

-(void)captureDeviceWasDisconnectedNotification:(NSNotification*)noti {
    LOGINFO(@"captureDeviceWasDisconnectedNotification");
}

-(BOOL)shouldAutorotate{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

@end
