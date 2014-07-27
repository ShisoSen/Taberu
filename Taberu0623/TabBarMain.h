//
//  TabBarMain.h
//  Taberu0623
//
//  Created by silver on 14-6-29.
//  Copyright (c) 2014年 silver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VC_M04.h"
#import "VC_M002.h"
#import "EAIntroView.h"
@interface TabBarMain : UITabBarController <EAIntroDelegate>
@property (nonatomic, strong) UIView *_tabBar;
@end
