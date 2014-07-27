//
//  AppDelegate.h
//  Taberu0623
//
//  Created by Sicong Qian on 14-6-23.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "DPAPI.h"
#import "TabBarMain.h"
@class MapViewController;
@class VC_M01;
@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate>
//< dianpin api
@property (readonly, nonatomic) DPAPI *dpapi;
@property (strong, nonatomic) NSString *appKey;
@property (strong, nonatomic) NSString *appSecret;
@property   TabBarMain *tbm;
+ (AppDelegate *)instance;
//>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (strong, nonatomic) MapViewController *mapVC;

@end
