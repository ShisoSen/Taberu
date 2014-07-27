//
//  SingleShop.m
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-11.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import "SingleShop.h"
#import "AppDelegate.h"

@implementation SingleShop{
    NSString *urlParam;
    NSString *posParam;
}
@synthesize bushops;
- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
        bushops = [[BuShops alloc]init];
    }
    return self;
}
-(void) initialize:(NSString *)bid{
    urlParam = @"v1/business/get_single_business";
    posParam = [@"business_id=" stringByAppendingString:bid];
    [[[AppDelegate instance] dpapi] requestWithURL:urlParam paramsString:posParam delegate:self];
}
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"error messege is: %@",[error description]);
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    NSLog(@"succese messege is: %@",[result description]);
    if ([@"OK" isEqualToString:[result objectForKey:@"status"]]&&[[result objectForKey:@"count"] intValue] > 0) {
        NSDictionary *ndic = [[result objectForKey:@"businesses"] objectAtIndex:0];
        bushops.business_id = [ndic objectForKey:@"business_id"];
        bushops.name = [ndic objectForKey:@"name"];
        bushops.branch_name = [ndic objectForKey:@"branch_name"];
        bushops.address = [ndic objectForKey:@"address"];
        bushops.telephone = [ndic objectForKey:@"telephone"];
        bushops.avg_rating = [ndic objectForKey:@"avg_rating"];
        bushops.rating_img_url = [ndic objectForKey:@"rating_img_url"];
        bushops.rating_s_img_url = [ndic objectForKey:@"rating_s_img_url"];
        bushops.product_grade = [NSString stringWithFormat:@"%@",[ndic objectForKey:@"product_grade"]];
        bushops.decoration_grade = [NSString stringWithFormat:@"%@",[ndic objectForKey:@"decoration_grade"]];
        bushops.service_grade = [NSString stringWithFormat:@"%@",[ndic objectForKey:@"service_grade"]];
        bushops.avg_price = [NSString stringWithFormat:@"%@",[ndic objectForKey:@"avg_price"]];
        bushops.review_count = [ndic objectForKey:@"review_count"];
        bushops.business_url = [ndic objectForKey:@"business_url"];
        bushops.photo_url = [ndic objectForKey:@"photo_url"];
        bushops.s_photo_url = [ndic objectForKey:@"s_photo_url"];
        bushops.distance = [NSString stringWithFormat:@"%@",[ndic objectForKey:@"distance"]];
        NSArray *arr = [ndic objectForKey:@"regions"];
        bushops.regions = [arr componentsJoinedByString:@" "];
        arr = [ndic objectForKey:@"categories"];
        bushops.categories = [arr componentsJoinedByString:@" "];
        
        bushops.N_avg_price = [bushops.avg_price floatValue];
        bushops.N_distance = [bushops.distance floatValue];
        bushops.N_review_count = [bushops.review_count intValue];
        bushops.N_product_grade = [bushops.product_grade intValue];
        bushops.N_decoration_grade = [bushops.decoration_grade intValue];
        bushops.N_service_grade = [bushops.service_grade intValue];
        
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([[NSString stringWithFormat:@"%@",[ndic objectForKey:@"latitude"]] doubleValue], [[NSString stringWithFormat:@"%@",[ndic objectForKey:@"longitude"]] doubleValue]);
        bushops.latitude = [NSString stringWithFormat:@"%f",coor.latitude];
        bushops.longitude = [NSString stringWithFormat:@"%f",coor.longitude];
        
        bushops.name = [ndic objectForKey:@"name"];

        [_vcm00 updateTabelCell];
        
    }
}
@end
