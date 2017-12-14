//
//  MonitoringRegionViewController.h
//  SchoolCar
//
//  Created by 周杰 on 2017/12/14.
//  Copyright © 2017年 周杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface MonitoringRegionViewController : UIViewController
@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) AMapLocationManager *locationManager;
@end
