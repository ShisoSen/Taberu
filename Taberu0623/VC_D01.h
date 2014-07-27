//
//  VC_D01.h
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-2.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuShops.h"
#import "VC_M00.h"
#import "BsReviews.h"
#import "SingleShop.h"
#import "FileOperator.h"
@interface VC_D01 : VC_M00 <UIAlertViewDelegate>
@property (nonatomic, strong) BuShops *bushops;
@property (nonatomic, strong) BsReviews *bsreviews;
@property (nonatomic, strong) SingleShop *singleShop;
@property (nonatomic, strong) UIActivityViewController *activityViewController;
-(void)searchSingleShop;
@end
