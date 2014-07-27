//
//  CoordinateConvert.m
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-14.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//
#define x_pi 180.0f
#define a 6378245.0f
#define ee 0.00669342162296594323f
#define pi 3.14159265358979324

#import "CoordinateConvert.h"

@implementation CoordinateConvert
+(CLLocationCoordinate2D)bd_encrypt:(CLLocationCoordinate2D)coor{
    double y = coor.latitude;
    double x = coor.longitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    
    return CLLocationCoordinate2DMake(z * sin(theta) + 0.006, z * cos(theta) + 0.0065);
}

+(CLLocationCoordinate2D)bd_decrypt:(CLLocationCoordinate2D)coor{
    double y = coor.latitude - 0.006;
    double x = coor.longitude - 0.0065;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    
    return CLLocationCoordinate2DMake(z * sin(theta), z * cos(theta));
}

+(CLLocationCoordinate2D)WGS2GCJ:(CLLocationCoordinate2D)coor{
    double wgLat = coor.latitude;
    double wgLon = coor.longitude;
    double mgLat = 0.0f;
    double mgLon = 0.0f;
    
    if ([self outOfChina:wgLat lon:wgLon])
    {
        mgLat = wgLat;
        mgLon = wgLon;
    }
    double dLat = [self transformLat:wgLon - 105.0 y:wgLat - 35.0];
    double dLon = [self transformLon:wgLon - 105.0 y:wgLat - 35.0];
    double radLat = wgLat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    mgLat = wgLat + dLat;
    mgLon = wgLon + dLon;
    
    return CLLocationCoordinate2DMake(mgLat, mgLon);
}
+(bool)outOfChina:(double)lat lon:(double)lon
{
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}
+(double)transformLat:(double)x y:(double)y
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
}
+(double)transformLon:(double)x y:(double)y
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
}
@end