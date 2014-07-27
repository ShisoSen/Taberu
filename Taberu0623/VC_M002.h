//
//  VC_M002.h
//  Taberu0623
//
//  Created by silver on 14-7-6.
//  Copyright (c) 2014年 silver. All rights reserved.
//

#import "VC_M00.h"
#import "VC_M002_List.h"
#import "VC_M002_Map.h"
#import "Businesses.h"
#import "BaseInfor.h"
#import "DropDownChooseProtocol.h"
#import "DropDownListView.h"

@interface VC_M002 : VC_M00 <DropDownChooseDelegate,DropDownChooseDataSource>
@property (nonatomic, strong) NSArray *vcms;
@property (nonatomic, strong) Businesses *bu;
@end
