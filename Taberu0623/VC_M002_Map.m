//
//  VC_M002_Map.m
//  Taberu0623
//
//  Created by silver on 14-7-6.
//  Copyright (c) 2014年 silver. All rights reserved.
//

#import "VC_M002_Map.h"
#define precision 0.000001

@interface VC_M002_Map ()

@end

@implementation VC_M002_Map{
    BMKAnnotationView* newAnnotation;
    
}
@synthesize _mapView;
@synthesize baseinfor;
@synthesize bu;
@synthesize PointAnnotations;
@synthesize mainViewController;
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
    // Do any additional setup after loading the view.
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-40)];
    [self.view addSubview:_mapView];
    
    //设定地图中心（device坐标基准）
    [_mapView setCenterCoordinate:[BaseInfor singleton].coordinate animated:YES];
    
    //设置地图缩放级别
    [_mapView setZoomLevel:15];

}
-(void)delayLoader:(id)sender{
    //设定地图中心（device坐标基准）
    _mapView.centerCoordinate = [BaseInfor singleton].coordinate;
    // 添加一个PointAnnotation
    for (BuShops *e in bu.buShops) {
        CLLocationCoordinate2D coor;
        coor.latitude = [e.latitude floatValue];
        coor.longitude = [e.longitude floatValue];
        BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
        pointAnnotation.coordinate = coor;
        pointAnnotation.title = e.name;
//        pointAnnotation.subtitle = e.categories;
        
        [_mapView addAnnotation:pointAnnotation];
        [pointAnnotation release];
        pointAnnotation = nil;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
//    [array release];
    //设定地图中心（device坐标基准）
    [_mapView setCenterCoordinate:[BaseInfor singleton].coordinate animated:YES];
    //延时加载坐标点
    [self performSelector:@selector(delayLoader:) withObject:nil afterDelay:0.5];
    //绘制起点
    RouteAnnotation* item = [[RouteAnnotation alloc]init];
    item.coordinate = [BaseInfor singleton].coordinate;
    item.title = @"起点";
    item.type = 0;
    [_mapView addAnnotation:item]; // 添加起点标注
    [item release];
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
//    _mapView.delegate = nil; // 不用时，置nil
}

- (void)dealloc {
    [super dealloc];
    if (_mapView) {
        [_mapView release];
        _mapView = nil;
        _mapView.delegate = nil; // 不用时，置nil
        }
    if (PointAnnotations) {
        [PointAnnotations release];
        PointAnnotations = nil;
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
- (void)addPointAnnotation:(CLLocationCoordinate2D)coor
{
    BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
//    CLLocationCoordinate2D coor;
//    coor.latitude = 39.915;
//    coor.longitude = 116.404;
    pointAnnotation.coordinate = coor;

    [_mapView addAnnotation:pointAnnotation];
    
    [pointAnnotation release];
    
}


#pragma mark -
#pragma mark implement BMKMapViewDelegate

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        
        newAnnotation = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"start_node"];
        newAnnotation.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath:@"images/icon_nav_start.png"]];
        newAnnotation.centerOffset = CGPointMake(0, -(newAnnotation.frame.size.height * 0.5));
        newAnnotation.canShowCallout = TRUE;
        newAnnotation.annotation = annotation;
    }
    else{
        NSString *AnnotationViewID = @"renameMark";
        newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
        ((BMKPinAnnotationView*)newAnnotation).pinColor = BMKPinAnnotationColorPurple;
        // 从天上掉下效果
        ((BMKPinAnnotationView*)newAnnotation).animatesDrop = YES;
        // 设置可拖拽
//        ((BMKPinAnnotationView*)newAnnotation).draggable = YES;
    }
    return newAnnotation;
    
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
    BMKPointAnnotation *anno = view.annotation;
    NSLog(@"%@",anno.title);
    for (BuShops *e in bu.buShops) {
        CLLocationCoordinate2D coor;
        coor.latitude = [e.latitude floatValue];
        coor.longitude = [e.longitude floatValue];
        if (fabs(anno.coordinate.latitude-[e.latitude floatValue])<precision && fabs(anno.coordinate.longitude-[e.longitude floatValue])<precision) {
            VC_D01 *vcd01 = [[VC_D01 alloc]init];
            vcd01.bushops = e;
            [mainViewController.navigationController pushViewController:vcd01 animated:YES];
            [vcd01 release];
            break;
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
