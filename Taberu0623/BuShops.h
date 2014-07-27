//
//  BuShops.h
//  Taberu0623
//
//  Created by Sicong Qian on 14-6-30.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuShops : NSObject
@property (strong, nonatomic) NSString *business_id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *branch_name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *telephone;
@property (strong, nonatomic) NSString *avg_rating;
@property (strong, nonatomic) NSString *rating_img_url;
@property (strong, nonatomic) NSString *rating_s_img_url;

@property (strong, nonatomic) NSString *product_grade;
@property (strong, nonatomic) NSString *decoration_grade;
@property (strong, nonatomic) NSString *service_grade;
@property (strong, nonatomic) NSString *avg_price;
@property (strong, nonatomic) NSString *review_count;
@property (strong, nonatomic) NSString *business_url;
@property (strong, nonatomic) NSString *photo_url;
@property (strong, nonatomic) NSString *s_photo_url;
@property (strong, nonatomic) NSString *regions;
@property (strong, nonatomic) NSString *categories;
@property (strong, nonatomic) NSString *distance;

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

//number type
@property float N_distance;
@property int N_review_count;
@property float N_avg_price;
@property int N_product_grade;
@property int N_decoration_grade;
@property int N_service_grade;
@end
