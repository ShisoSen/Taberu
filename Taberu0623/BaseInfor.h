//
//  BaseInfor.h
//  Taberu0623
//
//  Created by Sicong Qian on 14-6-26.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CoreLocation.h>
#import "CoordinateConvert.h"
@interface BaseInfor : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *myLocationManager;

@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *category;
///坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

-(void) initialize;
-(void) resign;
-(void) deResign;
-(BOOL)isCoorZero;
+(BaseInfor*) singleton;
@end
