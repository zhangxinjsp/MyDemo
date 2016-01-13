//
//  CameraPhotoViewController.m
//  UINavgationController
//
//  Created by zhangxin on 14-10-27.
//  Copyright (c) 2014年 zhangxin. All rights reserved.
//

#import "CameraViewController.h"
#import "MediaCaptureViewController.h"
#import "SquareCamViewController.h"


#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
    UIImagePickerController* imagePickerController;
    
    UIButton* imagePickerButton;
    UIButton* mediaCaptureButton;
    UIButton* faceCaptureButton;
}

@end

@implementation CameraViewController

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
    
    imagePickerButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 300, 40)];
    [imagePickerButton setTitle:@"image picker " forState:UIControlStateNormal];
    [imagePickerButton addTarget:self action:@selector(imagePickerAction:) forControlEvents:UIControlEventTouchUpInside];
    imagePickerButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:imagePickerButton];
    
    
    mediaCaptureButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 200, 300, 40)];
    [mediaCaptureButton setTitle:@"media capture " forState:UIControlStateNormal];
    [mediaCaptureButton addTarget:self action:@selector(mediaCaptureAction:) forControlEvents:UIControlEventTouchUpInside];
    mediaCaptureButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:mediaCaptureButton];
    
    faceCaptureButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, 300, 40)];
    [faceCaptureButton setTitle:@"face capture " forState:UIControlStateNormal];
    [faceCaptureButton addTarget:self action:@selector(faceCaptureAction:) forControlEvents:UIControlEventTouchUpInside];
    faceCaptureButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:faceCaptureButton];
    
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)faceCaptureAction:(id)sender {
    
    SquareCamViewController* ctl = [[SquareCamViewController alloc]init];
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void)mediaCaptureAction:(id)sender {
    
    MediaCaptureViewController* ctl = [[MediaCaptureViewController alloc]init];
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void)imagePickerAction:(id)sender{
    [self initImagePickerController];
    [self presentViewController:imagePickerController animated:YES completion:^{
        LOGINFO(@"image picker controller has appear");
    }];
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
