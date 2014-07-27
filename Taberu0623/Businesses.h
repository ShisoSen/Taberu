//
//  Businesses.h
//  Taberu0623
//
//  Created by Sicong Qian on 14-6-30.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPAPI.h"
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CoreLocation.h>
#import "VC_M00.h"
#import "CoordinateConvert.h"
@interface Businesses : NSObject <DPRequestDelegate>
@property (nonatomic, strong) CLLocationManager *myLocationManager;
@property (nonatomic, strong) NSMutableArray *buShops;
@property (nonatomic, strong)  VC_M00 *vcm02;
///坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property NSInteger sortFlg;
-(void)requestByParam:(CLLocationCoordinate2D)co category:(NSString *)category page:(NSInteger)page;
-(void) initialize:(CLLocationCoordinate2D)co;
-(void)initialize;
-(void) sortByFlg:(int) flg;
@end
