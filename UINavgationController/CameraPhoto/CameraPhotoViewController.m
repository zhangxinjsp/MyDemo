//
//  CameraPhotoViewController.m
//  UINavgationController
//
//  Created by xsw on 14-10-27.
//  Copyright (c) 2014年 niexin. All rights reserved.
//

#import "CameraPhotoViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <OpenGLES/EAGL.h>
#import <GLKit/GLKit.h>

@interface CameraPhotoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate>{
    UIImagePickerController* imagePickerController;
    
    
    AVCaptureSession* captureSession;

    EAGLContext* glContext;
    GLKView* glView;
    CIContext* ciContext;
    
    
}

@end

@implementation CameraPhotoViewController

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
    // Do any additional setup after loading the view.
#if 0
    [self initImagePickerController];
    [self presentViewController:imagePickerController animated:YES completion:^{
        LOGINFO(@"image picker controller has appear");
    }];
#else
//    [self checkAuthorizationStatus];
#endif
    

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self checkAuthorizationStatus];
    
}

#pragma mark  UIImagePickerController 的使用方法
- (void)initImagePickerController{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    view.backgroundColor = [UIColor redColor];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    imagePickerController = [[UIImagePickerController alloc]init];
    //前置摄像头没有闪光灯
    imagePickerController.delegate = self;
    /**
     *  UIImagePickerControllerSourceTypeSavedPhotosAlbum 只能看单一的照片 点击图片的时候会有回调
     *  UIImagePickerControllerSourceTypePhotoLibrary 可以看分组以后的照片 点击图片的时候会有回调
     *  UIImagePickerControllerSourceTypeCamera  调用相机
     */
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = YES;//是否允许查看和裁剪图片
    imagePickerController.mediaTypes = @[(NSString*)kUTTypeImage, (NSString*)kUTTypeMovie];//添加相应的类型相机就可以拍摄相应的东西
    
    if (imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;//选择前后摄像头
        if ([self doesCameraSupportShootingVideos]){
            LOGINFO(@"The camera supports shooting videos.");
            imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;//需要判断是否支持
        }
        imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;//需要判断是否有闪光灯
        imagePickerController.videoMaximumDuration = 300;//设置视频最长拍摄时间
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeLow;//拍摄视屏的质量
        imagePickerController.showsCameraControls = NO;//是否显示系统的自导控件
        imagePickerController.cameraOverlayView = view;//设置视频上的一个子view，修改界面效果
        imagePickerController.cameraViewTransform = CGAffineTransformMakeTranslation(0.5, 0.5);//设置视频画面的transform
    }
    
    /*
     保存照片的方法
     UIImageWriteToSavedPhotosAlbum(<#UIImage *image#>, <#id completionTarget#>, <#SEL completionSelector#>, <#void *contextInfo#>)
     
     保存视频的方法
     UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(<#NSString *videoPath#>);
     UISaveVideoAtPathToSavedPhotosAlbum(<#NSString *videoPath#>, <#id completionTarget#>, <#SEL completionSelector#>, <#void *contextInfo#>)
     
     在系统的相关操作控件被隐藏的时候自定义控件的时候可以进行相关调用
     [imagePickerController takePicture];
     [imagePickerController startVideoCapture];
     [imagePickerController stopVideoCapture];
     */
    if ([self isCameraAvailable]){
        LOGINFO(@"Camera is available.");
    } else {
        LOGINFO(@"Camera is not available.");
    }
    
    if ([self doesCameraSupportTakingPhotos]){
        LOGINFO(@"The camera supports taking photos.");
    } else {
        LOGINFO(@"The camera does not support taking photos");
    }
    
    if ([self doesCameraSupportShootingVideos]){
        LOGINFO(@"The camera supports shooting videos.");
    } else {
        LOGINFO(@"The camera does not support shooting videos.");
    }
}

- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) doesCameraSupportTakingPhotos{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) doesCameraSupportShootingVideos{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0){
        LOGINFO(@"Media type is empty.");
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        LOGINFO(@"%@", mediaType);
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

- (BOOL) isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}
- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)isFlashAvailableForCameraDevice{
    //判断摄像头是否支持闪光
    return [UIImagePickerController isFlashAvailableForCameraDevice: UIImagePickerControllerCameraDeviceRear];
}

//获取摄像头支持的捕获方式
- (void)availableCaptureModes{
    
    NSArray* modes = [UIImagePickerController availableCaptureModesForCameraDevice:UIImagePickerControllerCameraDeviceFront];
    for (NSNumber* mode in modes) {
        if (mode.integerValue == UIImagePickerControllerCameraCaptureModePhoto) {
            LOGINFO(@"UIImagePickerControllerCameraCaptureModePhoto");
        } else if (mode.integerValue == UIImagePickerControllerCameraCaptureModeVideo) {
            LOGINFO(@"UIImagePickerControllerCameraCaptureModeVideo");
        } else {
            LOGINFO(@"UIImagePickerControllerCameraCaptureMode Any Others");
        }
    }
}


#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    LOGINFO(@"did Finish Picking Image With editing Info \n%@", editingInfo);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    LOGINFO(@"did Finish Picking Media With Info \n%@", info);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    LOGINFO(@"image Picker Controller Did Cancel");
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
                    [self avfoundation];
                } else {
                    LOGINFO(@"未得到授权");
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
            [self avfoundation];
            break;
        }
        default: {
            break;
        }
    }
    
}

- (void)avfoundation{
    captureSession = [[AVCaptureSession alloc]init];
    /**
     *  后面有具体XXX＊xxx的都需要进行判断
     */
    if ([captureSession canSetSessionPreset:AVCaptureSessionPresetiFrame960x540]) {
        //然后再进行设置
    }
    captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    
    
//    NSArray* availableCameraDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDevice* wantDevice;
    NSArray *devices = [AVCaptureDevice devices];
    
    for (AVCaptureDevice *device in devices) {
        LOGINFO(@"Device name: %@", [device localizedName]);
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionBack) {
                LOGINFO(@"Device position : back");
            } else {
                LOGINFO(@"Device position : front");
                wantDevice = device;
            }
        }
    }
    
    [wantDevice hasTorch];
    [wantDevice hasFlash];
    
    NSError* error;
    
    AVCaptureDeviceInput* deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:wantDevice error:&error];
    if ([captureSession canAddInput:deviceInput]) {
        [captureSession addInput:deviceInput];
    }
    
//    [self showVideoPreview];
    [self captureStillImage];
    
    
    [captureSession startRunning];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(captureSessionRuntimeErrorNotification:) name:AVCaptureSessionRuntimeErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(captureDeviceWasConnectedNotification:) name:AVCaptureDeviceWasConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(captureDeviceWasDisconnectedNotification:) name:AVCaptureDeviceWasDisconnectedNotification object:nil];
}

- (void)changCaptureSession{
    [captureSession beginConfiguration];
    // Remove an existing capture device.
    // Add a new capture device.
    // Reset the preset.
    
    
    
    [captureSession commitConfiguration];
}

- (void)captureMovieFileOutput{
    AVCaptureMovieFileOutput *aMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    CMTime maxDuration = CMTimeMake(300, 1);//Create a CMTime to represent the maximum duration;
    aMovieFileOutput.maxRecordedDuration = maxDuration;
    aMovieFileOutput.minFreeDiskSpaceLimit = 300;//An appropriate minimum given the quality of the movie format and the duration;
    
    NSURL *fileURL = [NSURL URLWithString:@""];//A file URL that identifies the output location;
    [aMovieFileOutput startRecordingToOutputFileURL:fileURL recordingDelegate:self];
    
}




- (void)showVideoPreview{
#if 0
//    使用AVCaptureVideoPreviewLayer 来显示视频效果
    AVCaptureVideoPreviewLayer* previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.frame = self.view.bounds;
    //    previewLayer.backgroundColor = [UIColor redColor].CGColor;
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
    
    AVCaptureVideoDataOutput* videoOutput = [[AVCaptureVideoDataOutput alloc]init];
    
    dispatch_queue_t queue = dispatch_queue_create("simple buffer", DISPATCH_QUEUE_SERIAL);
    [videoOutput setSampleBufferDelegate:self queue:queue];
    if ([captureSession canAddOutput:videoOutput]) {
        [captureSession addOutput:videoOutput];
    }
#endif
}

- (void)captureStillImage{
    AVCaptureStillImageOutput* stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    if ([captureSession canAddOutput:stillImageOutput]) {
        [captureSession addOutput:stillImageOutput];
    }
}




#pragma mark AVFoundation Still and Video Media Capture  Output Delegate
//AVCaptureVideoDataOutputSampleBufferDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CIImage* ciImage = [[CIImage alloc]initWithCVPixelBuffer:pixelBuffer];
//    UIImage* image = [[UIImage alloc]initWithCIImage:ciImage];
    
    if (glContext != [EAGLContext currentContext]) {
        [EAGLContext setCurrentContext:glContext];
    }
    
    [glView bindDrawable];
    [ciContext drawImage:ciImage inRect:ciImage.extent fromRect:ciImage.extent];
    [glView display];
    
    
}

//AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    LOGINFO(@"didStartRecordingToOutputFileAtURL :%@ ",fileURL.absoluteString);
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    LOGINFO(@"didFinishRecordingToOutputFileAtURL :%@ ",outputFileURL.absoluteString);
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






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
