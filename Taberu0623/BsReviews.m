//
//  BsReviews.m
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-2.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import "BsReviews.h"
#import "AppDelegate.h"
#import "Reviews.h"
@implementation BsReviews{
    NSString *urlParam;
    NSString *posParam;
}
@synthesize bsreviews;
@synthesize vcm00;

- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
    }
    return self;
}
-(void) initialize:(NSString *)bid{
    urlParam = @"v1/review/get_recent_reviews";
    posParam = [@"business_id=" stringByAppendingString:bid];
    [[[AppDelegate instance] dpapi] requestWithURL:urlParam paramsString:posParam delegate:self];
}
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"error messege is: %@",[error description]);
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    NSLog(@"succese messege is: %@",[result description]);
    if ([@"OK" isEqualToString:[result objectForKey:@"status"]]&&[[result objectForKey:@"count"] intValue] > 0) {
        NSArray *nar = [result objectForKey:@"reviews"];
        if (bsreviews == nil) {
            bsreviews = [NSMutableArray array];
        }
        for(NSDictionary *ndic in nar){
            Reviews *temp = [Reviews alloc];
            temp.review_id = [ndic objectForKey:@"review_id"];
            temp.user_nickname = [ndic objectForKey:@"user_nickname"];
            temp.created_time = [ndic objectForKey:@"created_time"];
            temp.text_excerpt = [ndic objectForKey:@"text_excerpt"];
            temp.rating_s_img_url = [ndic objectForKey:@"rating_s_img_url"];
            temp.product_rating = [NSString stringWithFormat:@"%@",[ndic objectForKey:@"product_rating"]];
            temp.decoration_rating = [NSString stringWithFormat:@"%@",[ndic objectForKey:@"decoration_rating"]];
            temp.service_rating = [NSString stringWithFormat:@"%@",[ndic objectForKey:@"service_rating"]];
            temp.review_url = [NSString stringWithFormat:@"%@",[ndic objectForKey:@"review_url"]];
            
            [bsreviews addObject:temp];
        }
        [vcm00 updateTabelCell];
        
    }
}
@end
