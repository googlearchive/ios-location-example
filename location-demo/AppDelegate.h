//
//  AppDelegate.h
//  location-demo
//
//  Created by Tony Meng on 8/25/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager_;
@property (strong, nonatomic) NSString *displayName_;
@property Boolean hasOrientated_;

- (void)authToFirebase;
- (void)deauthToFirebase;

@end
