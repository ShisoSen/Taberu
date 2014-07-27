//
//  BaseInfor.m
//  Taberu0623
//
//  Created by Sicong Qian on 14-6-26.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import "BaseInfor.h"

@implementation BaseInfor
//singleton
static BaseInfor *baseInfor;

@synthesize city;
@synthesize category;
@synthesize coordinate;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
    /* We received the new location */
    coordinate = [CoordinateConvert bd_encrypt:[CoordinateConvert WGS2GCJ:newLocation.coordinate]];
//    NSLog(@"Latitude = %f", newLocation.coordinate.latitude);
//    NSLog(@"Longitude = %f", newLocation.coordinate.longitude);

    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    /* Failed to receive user's location */
    
}

-(void)initialize{
    //default value
//    coordinate.latitude = 39.997620;
//    coordinate.longitude = 116.303480;
    
    [self resign];
}
-(void)resign{
    if ([CLLocationManager locationServicesEnabled]){
        self.myLocationManager = [[CLLocationManager alloc] init];
        self.myLocationManager.delegate = self;
        
        
        [self.myLocationManager startUpdatingLocation];
    } else {
        /* Location services are not enabled.
         Take appropriate action: for instance, prompt the
         user to enable the location services */
        NSLog(@"Location services are not enabled");
    }
}
-(void)deResign{
        self.myLocationManager.delegate = nil;
}
+(BaseInfor *)singleton{
    @synchronized(self){
        if (baseInfor == nil) {
            baseInfor = [[self alloc] init];
        }
    }
    return baseInfor;
}
-(BOOL)isCoorZero{
    if (coordinate.latitude==0||coordinate.longitude==0) {
        return YES;
    }else{
        return NO;
    }
}
@end
