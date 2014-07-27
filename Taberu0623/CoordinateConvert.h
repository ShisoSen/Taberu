//
//  CoordinateConvert.h
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-14.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <math.h>
@interface CoordinateConvert : NSObject
//hx -> bd
+(CLLocationCoordinate2D)bd_encrypt:(CLLocationCoordinate2D)coor;
//bd -> hx
+(CLLocationCoordinate2D)bd_decrypt:(CLLocationCoordinate2D)coor;
+(CLLocationCoordinate2D)WGS2GCJ:(CLLocationCoordinate2D)coor;
@end
