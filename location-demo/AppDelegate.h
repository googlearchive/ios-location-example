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

- (void)authToFirebase;
- (void)deauthToFirebase;

@property (strong, nonatomic) UIWindow *window;

@end
