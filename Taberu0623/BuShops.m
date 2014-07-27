//
//  BuShops.m
//  Taberu0623
//
//  Created by Sicong Qian on 14-6-30.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import "BuShops.h"

@implementation BuShops
@synthesize business_id;
@synthesize name;
@synthesize branch_name;
@synthesize address;
@synthesize telephone;
@synthesize avg_rating;
@synthesize rating_img_url;
@synthesize rating_s_img_url;

@synthesize product_grade;
@synthesize decoration_grade;
@synthesize service_grade;
@synthesize avg_price;
@synthesize review_count;
@synthesize business_url;
@synthesize photo_url;
@synthesize s_photo_url;
@synthesize regions;
@synthesize categories;
@synthesize distance;

@synthesize N_distance;
@synthesize N_review_count;
@synthesize N_avg_price;
@synthesize N_product_grade;
@synthesize N_decoration_grade;
@synthesize N_service_grade;

@synthesize latitude;
@synthesize longitude;
- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
        business_id= @" ";
        name= @" ";
        branch_name= @" ";
        address= @" ";
        telephone= @" ";
        avg_rating= @" ";
        rating_img_url= @" ";
        rating_s_img_url= @" ";
        
        product_grade= @" ";
        decoration_grade= @" ";
        service_grade= @" ";
        avg_price= @" ";
        review_count= @" ";
        business_url= @" ";
        photo_url= @" ";
        s_photo_url= @" ";
        regions= @" ";
        categories= @" ";
        distance= @" ";
        
        latitude= @" ";
        longitude= @" ";
        
        N_distance= 0;
        N_review_count= 0;
        N_avg_price= 0;
        N_product_grade= 0;
        N_decoration_grade= 0;
        N_service_grade= 0;
    }
    return self;
}
@end
