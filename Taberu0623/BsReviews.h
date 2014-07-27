//
//  BsReviews.h
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-2.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPAPI.h"
#import "VC_M00.h"

@interface BsReviews : NSObject <DPRequestDelegate>
@property (nonatomic, strong)NSMutableArray *bsreviews;
@property (nonatomic, strong)VC_M00 *vcm00;

-(void) initialize:(NSString *)bid;
@end
