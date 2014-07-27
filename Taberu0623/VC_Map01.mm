//
//  VC_Map01.m
//  Taberu0623
//
//  Created by Sicong Qian on 14-7-3.
//  Copyright (c) 2014年 Sicong Qian. All rights reserved.
//

#import "VC_Map01.h"
#import "TabBarMain.h"

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
	CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end

@interface VC_Map01 ()<UIPickerViewDataSource, UIPickerViewDelegate>
@end

@implementation VC_Map01{
    BMKPointAnnotation* pointAnnotation;
    BMKAnnotationView* newAnnotation;
    BMKPlanNode *bmkStart;
    BMKPlanNode *bmkEnd;
    BMKRouteSearch* _routesearch;
    TabBarMain *u2;
    UIPickerView *_picker;
    NSMutableArray *routePath;
    bool pickerShow;
    NSInteger btTag;
//    bool pickOpen;
}
@synthesize start;
@synthesize end;
@synthesize Map_tabBar;
@synthesize _mapView;
@synthesize selectorVertical;
@synthesize bushops;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.font = [UIFont boldSystemFontOfSize:15];  //设置文本字体与大小
    titleLabel.textColor = [UIColor blackColor];  //设置文本颜色
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [bushops.name substringToIndex:10];  //设置标题
    self.navigationItem.titleView = titleLabel;
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-44)];
    [self.view addSubview:_mapView];

    //遍历父viewcontroller，找到tabbarmain，设置tabbar隐藏。self.hidesBottomBarWhenPushed无效！
    u2 = (TabBarMain *)self.parentViewController.parentViewController;
    [u2._tabBar setHidden:YES];
    
    _routesearch = [[BMKRouteSearch alloc]init];
    
    //设定地图中心（device坐标基准）
    [_mapView setCenterCoordinate:start animated:YES];
    //设置地图缩放级别
    [_mapView setZoomLevel:15];
    
    [self _initialTabBarView];
    if (Map_tabBar != nil) {
        [self.view insertSubview:Map_tabBar atIndex:0];
        //前置tabbar
        [self.view bringSubviewToFront:Map_tabBar];
    }
    routePath = [NSMutableArray array];
    [routePath retain];
    [_mapView retain];
}

-(void)delayLoader:(id)sender{
    //绘制起点
    RouteAnnotation* item = [[RouteAnnotation alloc]init];
    item.coordinate = [BaseInfor singleton].coordinate;
    item.title = @"起点";
    item.type = 0;
    [_mapView addAnnotation:item]; // 添加起点标注
    [item release];
    // 添加一个PointAnnotation
    if (pointAnnotation == nil) {
        [self addPointAnnotation:end type:1];
    }
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    //延时加载坐标点
    [self performSelector:@selector(delayLoader:) withObject:nil afterDelay:0.5];
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _routesearch.delegate = nil; // 不用时，置nil
    //设置tabbar显示
    [u2._tabBar setHidden:NO];
}

- (void)dealloc {
    [super dealloc];
    if (_routesearch != nil) {
        [_routesearch release];
        _routesearch = nil;
    }
    if (_mapView) {
        [_mapView release];
        _mapView = nil;
    }
    if (selectorVertical != nil) {
        [selectorVertical release];
        selectorVertical = nil;
    }
}
- (NSString*)getMyBundlePath:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        //        NSLog(@"%@",s);
		return s;
	}
	return nil ;
}

//添加标注
- (void)addPointAnnotation:(CLLocationCoordinate2D)coor type:(int)type
{
    pointAnnotation = [[BMKPointAnnotation alloc]init];
    pointAnnotation.coordinate = coor;
    switch (type) {
        case 0:
            pointAnnotation.title = @"出发";
//            pointAnnotation.subtitle = @"此Annotation可拖拽!";
            break;
        case 1:
            pointAnnotation.title = bushops.name;
//            pointAnnotation.subtitle = @"此Annotation可拖拽!" ;
            break;
        default:
            break;
    }

    [_mapView addAnnotation:pointAnnotation];
    [pointAnnotation release];
    
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath:@"images/icon_nav_bus.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 3:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath:@"images/icon_nav_rail.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
			
		}
			break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath:@"images/icon_nav_waypoint.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
        }
            break;
		default:
			break;
	}
	
	return [[view retain]autorelease];
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
		return [[[self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation]retain] autorelease];
	}else{
        NSString *AnnotationViewID = @"renameMark";
        newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
		((BMKPinAnnotationView*)newAnnotation).pinColor = BMKPinAnnotationColorPurple;
        // 从天上掉下效果
		((BMKPinAnnotationView*)newAnnotation).animatesDrop = YES;
        // 设置可拖拽
//		((BMKPinAnnotationView*)newAnnotation).draggable = YES;
        return newAnnotation;
    }
}
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return [[polylineView retain]autorelease];
    }
	return nil;
}
// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}

#pragma mark -路径查询显示
-(void)_initialTabBarView{
    NSArray *navTitle = @[@"公交",@"步行",@"驾车"];
    Map_tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH-49, ScreenW, 49)];
    Map_tabBar.tag = 9;
    Map_tabBar.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i < [navTitle count]; i++) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.frame = CGRectMake(105*i+10, (49-40)/2, 90, 40);
        bt.tag = i;
        [bt setTitle:[navTitle objectAtIndex:i] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        bt.titleLabel.font = [UIFont systemFontOfSize:15];
        bt.showsTouchWhenHighlighted = YES;
        [bt addTarget:self action:@selector(tarItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [Map_tabBar addSubview:bt];
    }
    UIView *partition = [[UIView alloc]initWithFrame:CGRectMake(107, 15, 1, 19)];
    partition.backgroundColor = [UIColor grayColor];
    [Map_tabBar addSubview:partition];
    [partition release];
    partition = [[UIView alloc]initWithFrame:CGRectMake(212, 15, 1, 19)];
    partition.backgroundColor = [UIColor grayColor];
    [Map_tabBar addSubview:partition];
    [partition release];
}
-(void)tarItemClick:(UIButton *)bt{
    NSLog(@"tag: %d",bt.tag);
    for (int i = 0; i < 3; i++) {
        if (bt.tag == i) {
            bt.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:20];
            [bt setSelected:YES];
        }else{
            UIButton *btn = (UIButton *)[Map_tabBar viewWithTag:i];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setSelected:NO];
//            [btn release];
        }
    }


    [self _removeIZValueSelector ];
    if (btTag != bt.tag) {
        btTag = bt.tag;
    }else{
        btTag = -1;
        return;
    }
    BOOL flag;
    bmkStart = [BMKPlanNode alloc];
    bmkStart.pt = start;
    bmkEnd = [BMKPlanNode alloc];
    bmkEnd.pt = end;
    switch (bt.tag) {
        case 0:{
            BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
            transitRouteSearchOption.city= @"北京市";
            transitRouteSearchOption.from = bmkStart;
            transitRouteSearchOption.to = bmkEnd;
            flag = [_routesearch transitSearch:transitRouteSearchOption];
            [transitRouteSearchOption release];
        }
            break;
        case 1:{
            BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
            walkingRouteSearchOption.from = bmkStart;
            walkingRouteSearchOption.to = bmkEnd;
            flag = [_routesearch walkingSearch:walkingRouteSearchOption];
            [walkingRouteSearchOption release];
        }
            break;
        case 2:{
            BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
            drivingRouteSearchOption.from = bmkStart;
            drivingRouteSearchOption.to = bmkEnd;
            flag = [_routesearch drivingSearch:drivingRouteSearchOption];
            [drivingRouteSearchOption release];
            break;
        }
        default:
            flag = NO;
            break;
    }
    if(flag)
    {
        NSLog(@"检索发送成功");

    }
    else
    {
        NSLog(@"检索发送失败");
    }
}
- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
    [routePath removeAllObjects];
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
		BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
		int size = [plan.steps count];
		int planPointCounts = 0;
		for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            if(i==0){
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
            }else if(i==size-1){
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            [item release];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            [routePath addObject:transitStep.instruction];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
		[_mapView addOverlay:polyLine]; // 添加路线overlay
		delete []temppoints;
        //加载路线pickerview
        [self _initIZValueSelector];
	}else{
        NSString *str = @"无法查询到可用公交路线";
        [self _showMesseage:str];
    }

}
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
	if (error == BMK_SEARCH_NO_ERROR) {
    [routePath removeAllObjects];
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
		int size = [plan.steps count];
		int planPointCounts = 0;
		for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            if(i==0){
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
//                [item release];
                
            }else if(i==size-1){
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
//                [item release];
            }
            //添加annotation节点
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            [item release];
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            [routePath addObject:transitStep.entraceInstruction];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
		[_mapView addOverlay:polyLine]; // 添加路线overlay
		delete []temppoints;
        //加载路线pickerview
        [self _initIZValueSelector];
		
	}else{
        NSString *str = @"无法查询到可用步行路线";
        [self _showMesseage:str];
    }

}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
    [routePath removeAllObjects];
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
		int size = [plan.steps count];
		int planPointCounts = 0;
		for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            if(i==0){
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
//                [item release];
                
            }else if(i==size-1){
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
//                [item release];
            }
            //添加annotation节点
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            [item release];
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            [routePath addObject:transitStep.entraceInstruction];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
		[_mapView addOverlay:polyLine]; // 添加路线overlay
		delete []temppoints;
        //加载路线pickerview
        [self _initIZValueSelector];
		
	}else{
        NSString *str = @"无法查询到可用步行路线";
        [self _showMesseage:str];
    }

    
}
-(void)_showMesseage:(NSString *)str{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"m(_ _)m" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [al show];
}
#pragma mark -pickerview 路径显示
-(void)_initialPickerView{
    if (_picker == nil) {
        _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ScreenH-49-162, ScreenW, 162)];
        _picker.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _picker.alpha = 0.8;

        _picker.dataSource = self;
        _picker.delegate = self;
//        [self.view insertSubview:_picker aboveSubview:0];
        [self.view addSubview:_picker];
        //前置
//        [_mapView removeFromSuperview];
        [self.view bringSubviewToFront:_picker];

    }else{
        [_picker removeFromSuperview];
        _picker = nil;
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if ([pickerView isEqual:_picker]){
        return 1;
    }
    return 0;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if ([pickerView isEqual:_picker]){
        return [routePath count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
            forComponent:(NSInteger)component{
    if ([pickerView isEqual:_picker]){
        /* Row is zero-based and we want the first row (with index 0) to be rendered as Row 1, so we have to +1 every row index */
        return  [routePath objectAtIndex:row];
}
    return nil;
}
#pragma mark IZValueSelector
-(void)_initIZValueSelector{
    if (selectorVertical == nil) {
        selectorVertical = [[IZValueSelectorView alloc]initWithFrame:CGRectMake(0, ScreenH-49-120, ScreenW, 120)];
        selectorVertical.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [selectorVertical retain];
        selectorVertical.dataSource = self;
        selectorVertical.delegate = self;
        selectorVertical.shouldBeTransparent = YES;
        selectorVertical.horizontalScrolling = NO;
        selectorVertical.debugEnabled = YES;
        [self.view addSubview:selectorVertical];
        [self.view bringSubviewToFront:selectorVertical];
    }else{
        [selectorVertical removeFromSuperview];
        [selectorVertical release];
        selectorVertical = nil;
    }

}
-(void)_removeIZValueSelector{
    if (selectorVertical != nil) {
        [selectorVertical removeFromSuperview];
        [selectorVertical release];
        selectorVertical = nil;
    }
}
#pragma IZValueSelector dataSource
- (NSInteger)numberOfRowsInSelector:(IZValueSelectorView *)valueSelector {
    return [routePath count];
}

//ONLY ONE OF THESE WILL GET CALLED (DEPENDING ON the horizontalScrolling property Value)
- (CGFloat)rowHeightInSelector:(IZValueSelectorView *)valueSelector {
    return 30.0;
}

- (CGFloat)rowWidthInSelector:(IZValueSelectorView *)valueSelector {
    return selectorVertical.frame.size.width;
}


- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index {
    UILabel * label = nil;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.selectorVertical.frame.size.width, 30)];
    label.text = [NSString stringWithFormat:@"%@",[routePath objectAtIndex:index]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextColor:[UIColor blueColor]];
    label.textAlignment =  NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return [[label retain]autorelease];
}

- (CGRect)rectForSelectionInSelector:(IZValueSelectorView *)valueSelector {
    //Just return a rect in which you want the selector image to appear
    //Use the IZValueSelector coordinates
    //Basically the x will be 0
    //y will be the origin of your image
    //width and height will be the same as in your selector image
    return CGRectMake(0.0, self.selectorVertical.frame.size.height/2 - 35.0, selectorVertical.frame.size.width, selectorVertical.frame.size.height);
}

#pragma IZValueSelector delegate
- (void)selector:(IZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index {
    NSLog(@"Selected index %d",index);
}

@end
