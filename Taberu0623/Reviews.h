//
//  Reviews.h
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-2.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reviews : NSObject
@property (strong, nonatomic) NSString *review_id;
@property (strong, nonatomic) NSString *user_nickname;
@property (strong, nonatomic) NSString *created_time;
@property (strong, nonatomic) NSString *text_excerpt;
@property (strong, nonatomic) NSString *rating_s_img_url;
@property (strong, nonatomic) NSString *product_rating;
@property (strong, nonatomic) NSString *decoration_rating;
@property (strong, nonatomic) NSString *service_rating;
@property (strong, nonatomic) NSString *review_url;
@end
