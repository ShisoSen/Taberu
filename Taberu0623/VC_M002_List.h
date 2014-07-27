//
//  VC_M002_List.h
//  Taberu0623
//
//  Created by silver on 14-7-6.
//  Copyright (c) 2014年 silver. All rights reserved.
//

#import "VC_M00.h"
#import "Businesses.h"
#import "BaseInfor.h"
#import "VC_M002_ListCell.h"
#import "BuShops.h"
#import "VC_D01.h"
#import "PullingRefreshTableView.h"
@interface VC_M002_List : VC_M00 <PullingRefreshTableViewDelegate,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PullingRefreshTableView *myTableView;
@property (nonatomic, strong) Businesses *bu;
@property (strong, nonatomic) VC_M00 *mainViewController;
@property BOOL refreshing;
@end
