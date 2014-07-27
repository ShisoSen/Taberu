//
//  Businesses.m
//  Taberu0623
//
//  Created by Sicong Qian on 14-6-30.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import "Businesses.h"
#import "AppDelegate.h"
#import "BuShops.h"
#import "BaseInfor.h"
@implementation Businesses{
    NSString *urlParam;
    NSString *posParam;
    NSString *ca;
}
@synthesize myLocationManager;
@synthesize coordinate;
@synthesize buShops;
@synthesize vcm02;
@synthesize sortFlg;
- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
        urlParam = @"v1/business/find_businesses";
        sortFlg = 2;
        ca = @"美食";
    }
    return self;
}
-(void) initialize:(CLLocationCoordinate2D)co{
    coordinate = [CoordinateConvert bd_decrypt:co];
    if (co.latitude==0) {
        return;
        //存储位置
        posParam = [@"latitude=" stringByAppendingFormat:@"%f&longitude=%f&category=美食",39.99862,116.28954];
    }else{
        //当前位置
        posParam = [@"latitude=" stringByAppendingFormat:@"%f&longitude=%f&category=%@",coordinate.latitude,coordinate.longitude,ca];

    }
    NSLog(@"posParam messege is: %@",posParam);
    [[[AppDelegate instance] dpapi] requestWithURL:urlParam paramsString:posParam delegate:self];
}
-(void)initialize{
    if ([[BaseInfor singleton] isCoorZero]) {
        return;
    }else{
        //当前位置
        coordinate = [BaseInfor singleton].coordinate;
        posParam = [@"latitude=" stringByAppendingFormat:@"%f&longitude=%f&category=%@",coordinate.latitude,coordinate.longitude,ca];
        
    }
    NSLog(@"posParam messege is: %@",posParam);
    [[[AppDelegate instance] dpapi] requestWithURL:urlParam paramsString:posParam delegate:self];
}
-(void)requestByParam:(CLLocationCoordinate2D)co category:(NSString *)category page:(NSInteger)page{
    //当前位置
    coordinate = [CoordinateConvert bd_decrypt:co];
    NSString *NposParam = [@"latitude=" stringByAppendingFormat:@"%f&longitude=%f",co.latitude,co.longitude];
    if (category!=nil) {
        if ([category isEqualToString:@"P"]) {
            if (ca!=nil) {
                NposParam = [NposParam stringByAppendingFormat:@"&category=%@",ca];
            }
        }else{
            NposParam = [NposParam stringByAppendingFormat:@"&category=%@",category];
            ca = category;
        }
    }
    if (page>1) {
        NposParam = [NposParam stringByAppendingFormat:@"&page=%ld",(long)page];
    }
    NSLog(@"PPosParam messege is: %@",NposParam);
    [[[AppDelegate instance] dpapi] requestWithURL:urlParam paramsString:NposParam delegate:self];
}
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"error messege is: %@",[error description]);
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    NSLog(@"succese messege is: %@",[result description]);
    bool isE = [@"OK" isEqualToString:[result objectForKey:@"status"]];
    int reC =[[result objectForKey:@"count"] intValue];
    if (isE&&reC > 0) {
        NSArray *nar = [result objectForKey:@"businesses"];
        if (buShops == nil) {
            buShops = [NSMutableArray array];
        }
        for(NSDictionary *ndic in nar){
            BuShops *temp = [BuShops alloc];
            temp.business_id = [ndic objectForKey:@"business_id"];
            temp.name = [ndic objectForKey:@"name"];
            temp.branch_name = [ndic objectForKey:@"branch_name"];
            temp.address = [ndic objectForKey:@"address"];
            temp.telephone = [ndic objectForKey:@"telephone"];
            temp.avg_rating = [ndic objectForKey:@"avg_rating"];
            temp.rating_img_url = [ndic objectForKey:@"rating_img_url"];
            temp.rating_s_img_url = [ndic objectForKey:@"rating_s_img_url"];
            temp.product_grade = [NSString stringWithFormat:@"%@",[ndic objectForKey:@"product_grade"]];
            temp.decoration_grade = [NSString stringWithFormat:@"%@",[ndic objectForKey:@"decoration_grade"]];
            temp.service_grade = [NSString stringWithFormat:@"%@",[ndic objectForKey:@"service_grade"]];
            temp.avg_price = [NSString stringWithFormat:@"%@",[ndic objectForKey:@"avg_price"]];
            temp.review_count = [ndic objectForKey:@"review_count"];
            temp.business_url = [ndic objectForKey:@"business_url"];
            temp.photo_url = [ndic objectForKey:@"photo_url"];
            temp.s_photo_url = [ndic objectForKey:@"s_photo_url"];
            temp.distance = [NSString stringWithFormat:@"%@",[ndic objectForKey:@"distance"]];
            NSArray *arr = [ndic objectForKey:@"regions"];
            temp.regions = [arr componentsJoinedByString:@" "];
            arr = [ndic objectForKey:@"categories"];
            temp.categories = [arr componentsJoinedByString:@" "];
            
            temp.N_avg_price = [temp.avg_price floatValue];
            temp.N_distance = [temp.distance floatValue];
            temp.N_review_count = [temp.review_count intValue];
            temp.N_product_grade = [temp.product_grade intValue];
            temp.N_decoration_grade = [temp.decoration_grade intValue];
            temp.N_service_grade = [temp.service_grade intValue];
            
            CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([[NSString stringWithFormat:@"%@",[ndic objectForKey:@"latitude"]] doubleValue], [[NSString stringWithFormat:@"%@",[ndic objectForKey:@"longitude"]] doubleValue]);
            temp.latitude = [NSString stringWithFormat:@"%f",coor.latitude];
            temp.longitude = [NSString stringWithFormat:@"%f",coor.longitude];
            
            [buShops addObject:temp];
        }
        if (sortFlg!=-1) {
            [self sortByFlg:sortFlg];
        }
            [vcm02 updateTabelCell];

    }else if (isE&&reC==0){
        [vcm02 loadAllMessage];
    }
}
//sort data
-(void) sortByFlg:(int) flg;{
    sortFlg = flg;
    switch (flg) {
        case 0:
            for (int i = 1; i < [buShops count]; i++) {
                BuShops *t1 = [buShops objectAtIndex:i];
                for (int j = i; j > 0; j--) {
                    BuShops *t2 = [buShops objectAtIndex:j-1];
                    if (t2.N_avg_price < t1.N_avg_price) {
                        [self _switcher:j-1 index2:j];
                    }else{
                        break;
                    }
                }
            }
            break;
        case 1:
            for (int i = 1; i < [buShops count]; i++) {
                BuShops *t1 = [buShops objectAtIndex:i];
                for (int j = i; j > 0; j--) {
                    BuShops *t2 = [buShops objectAtIndex:j-1];
                    if (t2.N_avg_price > t1.N_avg_price) {
                        [self _switcher:j-1 index2:j];
                    }else{
                        break;
                    }
                }
            }
            break;
        case 2:
            for (int i = 1; i < [buShops count]; i++) {
                BuShops *t1 = [buShops objectAtIndex:i];
                for (int j = i; j > 0; j--) {
                    BuShops *t2 = [buShops objectAtIndex:j-1];
                    if (t2.N_distance > t1.N_distance) {
                        [self _switcher:j-1 index2:j];
                    }else{
                        break;
                    }
                }
            }
            break;
        case 3:
            for (int i = 1; i < [buShops count]; i++) {
                BuShops *t1 = [buShops objectAtIndex:i];
                for (int j = i; j > 0; j--) {
                    BuShops *t2 = [buShops objectAtIndex:j-1];
                    if (t2.N_review_count < t1.N_review_count) {
                        [self _switcher:j-1 index2:j];
                    }else{
                        break;
                    }
                }
            }
            break;
        case 4:
            for (int i = 1; i < [buShops count]; i++) {
                BuShops *t1 = [buShops objectAtIndex:i];
                for (int j = i; j > 0; j--) {
                    BuShops *t2 = [buShops objectAtIndex:j-1];
                    if ((t2.N_product_grade+t2.N_decoration_grade+t2.N_service_grade) < (t1.N_product_grade+t1.N_decoration_grade+t1.N_service_grade)) {
                        [self _switcher:j-1 index2:j];
                    }else{
                        break;
                    }
                }
            }
            break;
        default:
            break;
    }
    for (BuShops *e in buShops) {
        NSLog(@"price: %f",e.N_distance);
    }
}
-(void)_switcher:(int)i index2:(int)j{
    BuShops *temp = [buShops objectAtIndex:i];
    [buShops replaceObjectAtIndex:i withObject:[buShops objectAtIndex:j]];
    [buShops replaceObjectAtIndex:j withObject:temp];
    
}

@end
