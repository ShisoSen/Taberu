//
//  VC_Map01.h
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-3.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "BMKTypes.h"
#import "RouteAnnotation.h"
#import "IZValueSelectorView.h"
#import "BuShops.h"
@interface VC_Map01 : UIViewController<BMKMapViewDelegate,BMKRouteSearchDelegate,IZValueSelectorViewDataSource,IZValueSelectorViewDelegate>{
	
}
@property CLLocationCoordinate2D end;
@property CLLocationCoordinate2D start;
@property (nonatomic, strong) BuShops *bushops;
@property (nonatomic, strong) UIView *Map_tabBar;
@property (nonatomic, strong) BMKMapView* _mapView;
@property (nonatomic, strong) IZValueSelectorView *selectorVertical;
@end
