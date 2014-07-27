//
//  RouteAnnotation.h
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-7.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import "BMKPointAnnotation.h"

@interface RouteAnnotation : BMKPointAnnotation
{
	int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
	int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end
