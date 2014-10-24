//
//  MotionViewController.m
//  UINavgationController
//
//  Created by xsw on 14-10-24.
//  Copyright (c) 2014年 niexin. All rights reserved.
//

#import "MotionViewController.h"


#define UPDATE_INTERVAL   0.01f

@interface MotionViewController (){
    CMMotionManager *motionManager;
    
    UIButton* accelerometerBtn;
    UIButton* gyroBtn;
    UIButton* magnetometerBtn;
    UIButton* deviceMotionBtn;
    UILabel* showValueLabel;
    
}

@end

@implementation MotionViewController

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
    motionManager = [[CMMotionManager alloc] init];
    
    accelerometerBtn = [[UIButton alloc]init];
    accelerometerBtn.tag = 0;
    accelerometerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [accelerometerBtn setTitle:@"加速度计" forState:UIControlStateNormal];
    [accelerometerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [accelerometerBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [accelerometerBtn setBackgroundColor:[UIColor grayColor]];
    [accelerometerBtn addTarget:self action:@selector(startActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:accelerometerBtn];
    
    gyroBtn = [[UIButton alloc]init];
    gyroBtn.tag = 1;
    gyroBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [gyroBtn setTitle:@"陀螺" forState:UIControlStateNormal];
    [gyroBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gyroBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [gyroBtn setBackgroundColor:[UIColor grayColor]];
    [gyroBtn addTarget:self action:@selector(startActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gyroBtn];
    
    magnetometerBtn = [[UIButton alloc]init];
    magnetometerBtn.tag = 2;
    magnetometerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [magnetometerBtn setTitle:@"磁力" forState:UIControlStateNormal];
    [magnetometerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [magnetometerBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [magnetometerBtn setBackgroundColor:[UIColor grayColor]];
    [magnetometerBtn addTarget:self action:@selector(startActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:magnetometerBtn];
    
    deviceMotionBtn = [[UIButton alloc]init];
    deviceMotionBtn.tag = 3;
    deviceMotionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [deviceMotionBtn setTitle:@"装置动态" forState:UIControlStateNormal];
    [deviceMotionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deviceMotionBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [deviceMotionBtn setBackgroundColor:[UIColor grayColor]];
    [deviceMotionBtn addTarget:self action:@selector(startActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deviceMotionBtn];
    
    showValueLabel = [[UILabel alloc]init];
    showValueLabel.backgroundColor = [UIColor lightGrayColor];
    showValueLabel.numberOfLines = 0;
    showValueLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:showValueLabel];
    
    [accelerometerBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [gyroBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [magnetometerBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [deviceMotionBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [showValueLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(accelerometerBtn, gyroBtn, magnetometerBtn, deviceMotionBtn, showValueLabel);

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[accelerometerBtn(30)]-(10)-[showValueLabel(>=30)]-(10)-|"
                                                                      options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[accelerometerBtn(>=10)]-(10)-[gyroBtn(accelerometerBtn)]-(10)-[magnetometerBtn(accelerometerBtn)]-(10)-[deviceMotionBtn(accelerometerBtn)]-(10)-|"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing|NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom metrics:nil views:views]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:showValueLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:deviceMotionBtn attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
}

-(void)startActions:(id)sender{
    NSInteger tag = ((UIButton*)sender).tag;
    
    [accelerometerBtn setSelected:tag == 0];
    [gyroBtn setSelected:tag == 1];
    [magnetometerBtn setSelected:tag == 2];
    [deviceMotionBtn setSelected:tag == 3];
    
    [motionManager stopAccelerometerUpdates];
    [motionManager stopGyroUpdates];
    [motionManager stopMagnetometerUpdates];
    [motionManager stopDeviceMotionUpdates];
    
    switch (tag) {
        case 0:{
            [self startAccelerometer];
        }
            break;
        case 1:{
            [self startGyro];
        }
            break;
        case 2:{
            [self startMagnetometer];
        }
            break;
        case 3:{
            [self startDeviceMotion];
        }
            break;
        default:
            break;
    }
}

//加速度计
-(void)startAccelerometer{
    if ([motionManager isAccelerometerAvailable]){
        if ([motionManager isGyroActive] == NO){
            [motionManager setAccelerometerUpdateInterval:UPDATE_INTERVAL];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            [motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                showValueLabel.text = [NSString stringWithFormat:@"x = %.04f \ny = %.04f \nz = %.04f", accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z];
                NSLog(@"Gyro Rotation x = %.04f", accelerometerData.acceleration.x);
                NSLog(@"Gyro Rotation y = %.04f", accelerometerData.acceleration.y);
                NSLog(@"Gyro Rotation z = %.04f", accelerometerData.acceleration.z);
            }];
        } else {
            showValueLabel.text = @"Gyro is already active.";
            NSLog(@"Gyro is already active.");
        }
    } else {
        showValueLabel.text = @"Accelerometer is not available.";
        NSLog(@"Accelerometer is not available.");
    }
}
//陀螺仪
-(void)startGyro{
    if ([motionManager isGyroAvailable]){
        if ([motionManager isGyroActive] == NO){
            [motionManager setGyroUpdateInterval:UPDATE_INTERVAL];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [motionManager startGyroUpdatesToQueue:queue withHandler:^(CMGyroData *gyroData, NSError *error) {
                showValueLabel.text = [NSString stringWithFormat:@"x = %.04f \ny = %.04f \nz = %.04f", gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z];
                NSLog(@"Gyro Rotation x = %.04f", gyroData.rotationRate.x);
                NSLog(@"Gyro Rotation y = %.04f", gyroData.rotationRate.y);
                NSLog(@"Gyro Rotation z = %.04f", gyroData.rotationRate.z);
            }];
        } else {
            showValueLabel.text = @"Gyro is already active.";
            NSLog(@"Gyro is already active.");
        }
    } else {
        showValueLabel.text = @"Gyro isn't available.";
        NSLog(@"Gyro isn't available.");
    }
}
//磁力
-(void)startMagnetometer{
    if ([motionManager isMagnetometerAvailable]){
        if ([motionManager isMagnetometerActive] == NO){
            [motionManager setMagnetometerUpdateInterval:UPDATE_INTERVAL];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            [motionManager startMagnetometerUpdatesToQueue:queue withHandler:^(CMMagnetometerData *magnetometerData, NSError *error) {
                showValueLabel.text = [NSString stringWithFormat:@"x = %.04f \ny = %.04f \nz = %.04f", magnetometerData.magneticField.x, magnetometerData.magneticField.y, magnetometerData.magneticField.z];
                NSLog(@"Magnetometer Rotation x = %.04f", magnetometerData.magneticField.x);
                NSLog(@"Magnetometer Rotation y = %.04f", magnetometerData.magneticField.y);
                NSLog(@"Magnetometer Rotation z = %.04f", magnetometerData.magneticField.z);
            }];
        } else {
            showValueLabel.text = @"Magnetometer is already active.";
            NSLog(@"Magnetometer is already active.");
        }
    } else {
        showValueLabel.text = @"Magnetometer isn't available.";
        NSLog(@"Magnetometer isn't available.");
    }
}

//装置动态
-(void)startDeviceMotion{
    if ([motionManager isDeviceMotionAvailable]){
        if ([motionManager isDeviceMotionActive] == NO){
            [motionManager setDeviceMotionUpdateInterval:UPDATE_INTERVAL];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            CMAttitudeReferenceFrame referenceFrame = motionManager.attitudeReferenceFrame;
            
            [motionManager startDeviceMotionUpdatesUsingReferenceFrame:referenceFrame toQueue:queue withHandler:^(CMDeviceMotion *motion, NSError *error) {
                showValueLabel.text = [NSString stringWithFormat:@"Gyro Rotation %@", motion];
                NSLog(@"Gyro Rotation %@", motion);
            }];
        } else {
            showValueLabel.text = @"Gyro is already active.";
            NSLog(@"Gyro is already active.");
        }
    } else {
        showValueLabel.text = @"Gyro isn't available.";
        NSLog(@"Gyro isn't available.");
    }
}
//设备晃动的回调方法
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    showValueLabel.text = @"motion Began";
    LOGINFO(@"motion Began");
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    showValueLabel.text = @"motion Cancelled";
    LOGINFO(@"motion Cancelled");
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    showValueLabel.text = @"motion Ended";
    LOGINFO(@"motion Ended");
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
