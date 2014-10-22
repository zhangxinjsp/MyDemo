//
//  MyAnnotation.h
//  UINavgationController
//
//  Created by xsw on 14-10-22.
//  Copyright (c) 2014年 niexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define REUSABLE_PIN_RED @"Red"
#define REUSABLE_PIN_GREEN @"Green"
#define REUSABLE_PIN_PURPLE @"Purple"

@interface MyAnnotation : NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;

@property (nonatomic, unsafe_unretained) MKPinAnnotationColor pinColor;


- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle subTitle:(NSString *)paramSubTitle;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate ;
+ (NSString *) reusableIdentifierforPinColor:(MKPinAnnotationColor)paramColor;
@end

