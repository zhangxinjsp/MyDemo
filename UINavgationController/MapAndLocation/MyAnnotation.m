//
//  MyAnnotation.m
//  UINavgationController
//
//  Created by xsw on 14-10-22.
//  Copyright (c) 2014年 niexin. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
@synthesize coordinate, title, subtitle;
- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle subTitle:(NSString *)paramSubTitle{
    self = [super init];
    if (self != nil){
        coordinate = paramCoordinates;
        title = paramTitle;
        subtitle = paramSubTitle;
    }
    return(self);
}

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
    coordinate = newCoordinate;
}

+ (NSString *) reusableIdentifierforPinColor :(MKPinAnnotationColor)paramColor{
    NSString *result = nil;
    switch (paramColor){
        case MKPinAnnotationColorRed:{
            result = REUSABLE_PIN_RED;
            break;
        }
        case MKPinAnnotationColorGreen:{
            result = REUSABLE_PIN_GREEN;
            break;
        }
        case MKPinAnnotationColorPurple:{
            result = REUSABLE_PIN_PURPLE;
            break;
        }
    }
    return result;
}
@end