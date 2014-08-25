//
//  ViewController.m
//  location-demo
//
//  Created by Tony Meng on 8/25/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "ViewController.h"
#import <Firebase/Firebase.h>
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController ()

@end

@implementation ViewController {
    GMSMapView *mapView_;
    NSMapTable *usersToMarkers_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // setup the view
    [self loadMapsView];
	// additional setup after loading the view, typically from a nib.
    [self loadFacebookView];
    [self listenForLocations];
}

- (void)loadMapsView {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.32607142
                                                            longitude:-122.01973718
                                                                 zoom:14];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
}

- (void)loadFacebookView {
	// Do any additional setup after loading the view, typically from a nib.
    FBLoginView *loginView = [[FBLoginView alloc] init];
    [self.view addSubview:loginView];
}

- (void)listenForLocations {
    usersToMarkers_ = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory];
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://location-demo.firebaseio.com"];
    [ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *s2) {
        // a new person connected, start listening for his position
        NSLog(@"Got new user %@", s2.name);
        [[ref childByAppendingPath:s2.name] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSLog(@"Got new position for user %@", snapshot.name);
            GMSMarker *marker = [usersToMarkers_ objectForKey:snapshot.name];
            if (!marker) {
                marker = [[GMSMarker alloc] init];
                marker.title = snapshot.name;
                marker.map = mapView_;
                [usersToMarkers_ setObject:marker forKey:snapshot.name];
            }
            marker.position = CLLocationCoordinate2DMake([snapshot.value[@"coords"][@"latitude"] doubleValue], [snapshot.value[@"coords"][@"longitude"] doubleValue]);
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
