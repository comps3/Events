//
//  GoogleMapsViewController.m
//  Events
//
//  Created by Brian Huynh on 7/17/14.
//  Copyright (c) 2014 HotRod software. All rights reserved.
//

#import "GoogleMapsViewController.h"
#import <GoogleMaps/GoogleMaps.h>


@implementation GoogleMapsViewController {
    
    GMSMapView *mapView_;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
}

-(void)viewDidLoad
{
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    // Positioning maps over California State University, Monterey Bay campus
    GMSCameraPosition * camera = [GMSCameraPosition cameraWithLatitude:36.6520344 longitude:-121.7983946 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    
    mapView_.myLocationEnabled = YES;
    //mapView_.settings.compassButton = YES;
    //mapView_.settings.myLocationButton = YES;
    
    [mapView_ setMinZoom:15 maxZoom:mapView_.maxZoom];
    mapView_.multipleTouchEnabled = YES;
    self.view = mapView_;
    self.title = @"Campus Map";
    mapView_.delegate = self;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
