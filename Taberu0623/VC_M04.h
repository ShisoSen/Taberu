//
//  VC_M04.h
//  Taberu0623
//
//  Created by silver on 14-6-29.
//  Copyright (c) 2014年 silver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VC_M00.h"
#import "PullingRefreshTableView.h"
#import "StarShop.h"
#import "FileOperator.h"
#import "VC_D01.h"
#import "BuShops.h"
@interface VC_M04 : VC_M00 <PullingRefreshTableViewDelegate,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PullingRefreshTableView *myTableView;
@property (nonatomic, strong) NSMutableArray *starShops;
@end
