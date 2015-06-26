//
//  MapAndLocationViewController.h
//  UINavgationController
//
//  Created by zhangxin on 14-10-22.
//  Copyright (c) 2014年 zhangxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"

@interface MapAndLocationViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>


@property (nonatomic, strong) MKMapView *myMapView;
@property (nonatomic, strong) CLLocationManager* myLocationManager;
@property (nonatomic, strong) CLGeocoder* myGeocoder;

@end
