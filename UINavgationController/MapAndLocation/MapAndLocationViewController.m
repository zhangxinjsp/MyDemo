//
//  MapAndLocationViewController.m
//  UINavgationController
//
//  Created by xsw on 14-10-22.
//  Copyright (c) 2014年 niexin. All rights reserved.
//

#import "MapAndLocationViewController.h"




@interface MapAndLocationViewController ()

@end

@implementation MapAndLocationViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initMapView];
    [self initLocationManager];
    [self getAddressFromLocation];
}

-(void)initMapView{
    self.myMapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    /* Set the map type to Satellite */
    self.myMapView.mapType = MKMapTypeHybrid;//地图的类型MKMapTypeStandard 标准地图 MKMapTypeSatellite 卫星地图    MKMapTypeHybrid 混合地图
    self.myMapView.showsUserLocation = YES;
    //mapview.zoomEnabled = NO;
    //mapview.scrollEnabled = NO;
    self.myMapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(40, 120), MKCoordinateSpanMake(80, 80));//开始显示的位置和区域大小
    self.myMapView.centerCoordinate = CLLocationCoordinate2DMake(40, 100);
    self.myMapView.delegate = self;
    
    self.myMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    /* Add it to our view */
    [self.view addSubview:self.myMapView];
    
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    [self.myMapView addGestureRecognizer:mTap];
}



//当需要从Google服务器取得新地图时
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
    LOGINFO(@"mapViewWillStartLoadingMap");
}
//当成功地取得地图后
-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    LOGINFO(@"mapViewDidFinishLoadingMap");
}
//当取得地图失败后（建议至少要实现此方法）
-(void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{
    LOGINFO(@"mapViewDidFailLoadingMap");
}

//当手势开始（拖拽，放大，缩小，双击）
-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    LOGINFO(@"regionWillChangeAnimated");
}

//当手势结束（拖拽，放大，缩小，双击）//地图的显示区域改变了调用
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    LOGINFO(@"regionDidChangeAnimated");
}

//更新当前位置调用
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    LOGINFO(@"didUpdateUserLocation");
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    
}

//选中注释图标
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    LOGINFO(@"didSelectAnnotationView");
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    LOGINFO(@"didDeselectAnnotationView");
}

- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.myMapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate = [self.myMapView convertPoint:touchPoint toCoordinateFromView:self.myMapView];//这里touchMapCoordinate就是该点的经纬度了
    
    NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
    [self addAnnotationWithLocation:touchMapCoordinate];
//    [self.myMapView addAnnotation:annotationa];
}

-(void)addAnnotationWithLocation:(CLLocationCoordinate2D)location{
    /* This is just a sample location */

    /* Create the annotation using the location */
    MyAnnotation *annotation = [[MyAnnotation alloc] initWithCoordinates:location title:@"My Title" subTitle:@"My Sub Title"];
    annotation.pinColor = MKPinAnnotationColorGreen;
    /* And eventually add it to the map */
    [self.myMapView addAnnotation:annotation];
//    [self.myMapview removeAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    MKAnnotationView *result = nil;
    if ([annotation isKindOfClass:[MyAnnotation class]] == NO){
        return result;
    }
    if ([mapView isEqual:self.myMapView] == NO){
        /* We want to process this event only for the Map View
         that we have created previously */
        return result;
    }
    /* First typecast the annotation for which the Map View has fired this delegate message */
    MyAnnotation *senderAnnotation = (MyAnnotation *)annotation;
    /* Using the class method we have defined in our custom annotation class, we will attempt to get a reusable
     identifier for the pin we are about to create */
    NSString *pinReusableIdentifier = [MyAnnotation reusableIdentifierforPinColor:senderAnnotation.pinColor];
    /* Using the identifier we retrieved above, we will attempt to reuse a pin in the sender Map View */
    
#if 1
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];
    if (annotationView == nil){
        /* If we fail to reuse a pin, then we will create one */
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:senderAnnotation reuseIdentifier:pinReusableIdentifier];
        /* Make sure we can see the callouts on top of each pin in case we have assigned title and/or subtitle to each pin */
        [annotationView setCanShowCallout:YES];
    }
    /* Now make sure, whether we have reused a pin or not, that the color of the pin matches the color of the annotation */
    annotationView.pinColor = senderAnnotation.pinColor;
#else //自定义锚点
    MKAnnotationView *annotationView = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];
    if (annotationView == nil){
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:senderAnnotation reuseIdentifier:pinReusableIdentifier];
        [annotationView setCanShowCallout:YES];
    }
    UIImage *pinImage = [UIImage imageNamed:@"dragDown.png"];
    if (pinImage != nil){
        annotationView.image = pinImage;
    }
#endif
    result = annotationView;
    return result;
}









-(void)getAddressFromLocation{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:+38.4112810 longitude:-120.0f];
    self.myGeocoder = [[CLGeocoder alloc] init];
    [self.myGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
         if (error == nil && [placemarks count] > 0){
             CLPlacemark *placemark = [placemarks objectAtIndex:0]; /* We received the results */
             LOGINFO(@"Country = %@", placemark.country);
             LOGINFO(@"Postal Code = %@", placemark.postalCode);
             LOGINFO(@"Locality = %@", placemark.locality);
         }
         else if (error == nil && [placemarks count] == 0){
             LOGINFO(@"No results were returned.");
         }
         else if (error != nil){
             LOGINFO(@"An error occurred = %@", error);
         }
     }];
}

-(void)initLocationManager{
    if ([CLLocationManager locationServicesEnabled]){
        self.myLocationManager = [[CLLocationManager alloc] init];
        self.myLocationManager.delegate = self;
        /*
         kCLLocationAccuracyBest
         kCLLocationAccuracyNearestTenMeters
         kCLLocationAccuracyHundredMeters
         kCLLocationAccuracyHundredMeters
         kCLLocationAccuracyKilometer
         kCLLocationAccuracyThreeKilometers
         */
        //设置定位的精度
        [self.myLocationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        //Set the purpose string in Info.plist using key NSLocationUsageDescription.
//        self.myLocationManager.purpose = @"To provide functionality based on user's current location.";
        [self.myLocationManager startUpdatingLocation];
        
        if ([CLLocationManager headingAvailable]) {
            //指南针功能开启
            [self.myLocationManager startUpdatingHeading];
        }
    } else {
        /* Location services are not enabled. Take appropriate action: for instance, prompt the user to enable the location services */
        LOGINFO(@"Location services are not enabled");
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation* lastLocation = [locations lastObject];
    LOGINFO(@"Latitude = %f", lastLocation.coordinate.latitude);
    LOGINFO(@"Longitude = %f", lastLocation.coordinate.longitude);
    
}

- (void)locationManager:(CLLocationManager *)manager idUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    /* We received the new location */
    LOGINFO(@"Latitude = %f", newLocation.coordinate.latitude);
    LOGINFO(@"Longitude = %f", newLocation.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    /* Failed to receive user's location */
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    LOGINFO(@" = %f", newHeading.magneticHeading);
    LOGINFO(@" = %f", newHeading.trueHeading);
    LOGINFO(@" = %f", newHeading.headingAccuracy);
    LOGINFO(@" = %f", newHeading.x);
    LOGINFO(@" = %f", newHeading.y);
    LOGINFO(@" = %f", newHeading.z);
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
