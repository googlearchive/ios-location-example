//
//  ViewController.h
//  location-demo
//
//  Created by Tony Meng on 8/25/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController : UIViewController <FBLoginViewDelegate>

@property (strong, nonatomic) GMSMapView *mapView_;
@property (strong, nonatomic) NSMapTable *usersToMarkers_;

- (void)updateCameraWithLocation:(CLLocation*)location;

@end
