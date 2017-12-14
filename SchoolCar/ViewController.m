//
//  ViewController.m
//  SchoolCar
//
//  Created by 周杰 on 2017/12/12.
//  Copyright © 2017年 周杰. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#define APIKey @"839401eefd64c1522f68aee441413e58"
@interface ViewController ()<MAMapViewDelegate,AMapGeoFenceManagerDelegate>
{
   
    UIButton * _locationButton;
    
}
@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) AMapGeoFenceManager *geoFenceManager;
@property (strong, nonatomic) CLLocation *userLocation;


@end

@implementation ViewController
- (void)initControls{
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationButton.frame = CGRectMake(20, CGRectGetHeight(_mapView.bounds)-80, 40, 40);
    _locationButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _locationButton.backgroundColor = [UIColor whiteColor];
    _locationButton.layer.cornerRadius = 5;
    [_locationButton addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:_locationButton];
}
- (void)initMapView{
    [AMapServices sharedServices].apiKey = APIKey;
    [AMapServices sharedServices].enableHTTPS = YES;
    
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
//    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 22);
//    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, 22);
     _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self initControls];
    [self.view addSubview:_mapView];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initMapView];
    [self createGeoFenceManager];
    [self addPolygonRegionForMonitoringWithCoordinates];
    [self addCircleFence];
}
//添加圆形围栏
- (void)addCircleFence{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(29.5298153191,106.6030883789);
    if (self.userLocation) {
        coordinate = self.userLocation.coordinate;
    }
    [self.geoFenceManager addCircleRegionForMonitoringWithCenter:coordinate radius:300 customID:@"circle_1"];
}
//初始化地理围栏

- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray<AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"创建失败 %@",error);
    } else {
        NSLog(@"创建成功");
    }
}
- (void)createGeoFenceManager{
    self.geoFenceManager = [[AMapGeoFenceManager alloc]init];
    self.geoFenceManager.delegate = self;
    self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed; //进入，离开，停留都要进行通知
    self.geoFenceManager.allowsBackgroundLocationUpdates = YES;//允许后台定位
    [self.geoFenceManager addKeywordPOIRegionForMonitoringWithKeyword:@"重庆邮电大学" POIType:@"高等院校" city:@"重庆" size:15 customID:@"circle_2"];
}

//绘制多边形地理围栏
- (void)addPolygonRegionForMonitoringWithCoordinates{
    NSInteger count = 4;
    CLLocationCoordinate2D *coorArr = malloc(sizeof(CLLocationCoordinate2D) * count);
    //重邮四角
    coorArr[0] = CLLocationCoordinate2DMake(29.5298153191,106.6030883789);
    coorArr[1] = CLLocationCoordinate2DMake(29.5371524833,106.6045475006);
    coorArr[2] = CLLocationCoordinate2DMake(29.5358269790,106.6118860245);
    coorArr[3] = CLLocationCoordinate2DMake(29.5281909894,106.6110599041);
    [self.geoFenceManager addPolygonRegionForMonitoringWithCoordinates:coorArr count:count customID:@"circle_3"];
    
    free(coorArr);
    coorArr = NULL;
}

- (void)location{
    if (_mapView.userTrackingMode != MAUserTrackingModeFollow) {
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }
    
}
//持续更新用户位置
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    self.userLocation = userLocation.location;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
