//
//  VC_M002_Map.h
//  Taberu0623
//
//  Created by silver on 14-7-6.
//  Copyright (c) 2014年 silver. All rights reserved.
//

#import "VC_M00.h"
#import "BMapKit.h"
#import "BuShops.h"
#import "Businesses.h"
#import "BaseInfor.h"
#import "RouteAnnotation.h"
#import "VC_D01.h"
#import <math.h>
@interface VC_M002_Map : VC_M00 <BMKMapViewDelegate>
@property (nonatomic, strong) Businesses *bu;
@property (strong, nonatomic) BaseInfor *baseinfor;
@property (strong, nonatomic) VC_M00 *mainViewController;
@property (strong, nonatomic) BMKMapView* _mapView;
@property (retain, strong, nonatomic) NSMutableArray *PointAnnotations;;
@end
