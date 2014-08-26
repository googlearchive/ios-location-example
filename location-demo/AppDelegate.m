//
//  AppDelegate.m
//  location-demo
//
//  Created by Tony Meng on 8/25/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "AppDelegate.h"

#import <GoogleMaps/GoogleMaps.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Firebase/Firebase.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>

@implementation AppDelegate {
    CLLocationManager *locationManager_;
    NSString *displayName_;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    if (wasHandled) {
        [self authToFirebase];
    }
    // You can add your app-specific url handling code here if needed
    return wasHandled;
}

- (void)authToFirebase
{
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    // if we have an access token, authenticate to firebase
    if (fbAccessToken) {
        Firebase *ref = [[Firebase alloc] initWithUrl:@"https://location-demo.firebaseio.com"];
        FirebaseSimpleLogin *authClient = [[FirebaseSimpleLogin alloc] initWithRef:ref];
        [authClient loginWithFacebookWithAccessToken:fbAccessToken withCompletionBlock:^(NSError *error, FAUser *user) {
            if (error) {
                NSLog(@"Error on login: %@", error);
                [self stopLocationUpdates];
            } else {
                displayName_ = user.thirdPartyUserData[@"displayName"];
                NSLog(@"Logged In: %@", displayName_);
                [self startLocationUpdates];
            }
        }];
    } else {
        NSLog(@"No access token provided.");
    }
}

- (void)deauthToFirebase
{
    if (displayName_) {
        Firebase *positionRef = [[[Firebase alloc] initWithUrl:@"https://location-demo.firebaseio.com"] childByAppendingPath:displayName_];
        [positionRef removeValueWithCompletionBlock:^(NSError *error, Firebase *ref) {
            displayName_ = nil;
        }];
    }
    [self stopLocationUpdates];
}

- (void)startLocationUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (!locationManager_) {
        locationManager_ = [[CLLocationManager alloc] init];
    }
    
    locationManager_.delegate = self;
    locationManager_.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    locationManager_.distanceFilter = 5; // meters
    
    [locationManager_ startUpdatingLocation];
}

- (void)stopLocationUpdates
{
    if (locationManager_) {
        [locationManager_ stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *loc = locations[0];
    if (displayName_) {
        NSDictionary *value = @{
            @"coords": @{
                @"accuracy" : [NSNumber numberWithDouble:loc.horizontalAccuracy],
                @"latitude" : [NSNumber numberWithDouble:loc.coordinate.latitude],
                @"longitude" : [NSNumber numberWithDouble:loc.coordinate.longitude]
            },
            @"timestamp" : [NSNumber numberWithInt:[[NSNumber numberWithDouble:loc.timestamp.timeIntervalSince1970 * 1000] intValue]]
        };
        Firebase *positionRef = [[[Firebase alloc] initWithUrl:@"https://location-demo.firebaseio.com"] childByAppendingPath:displayName_];
        [positionRef setValue:value];
        [positionRef onDisconnectRemoveValue];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyBx8n37AY9pJw9AV6aOkrSKN84V22LrcUc"];
    [self authToFirebase];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
