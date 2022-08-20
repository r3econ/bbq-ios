//
// Copyright (c) 2014 Rafał Sroka
//
// Licensed under the GNU General Public License, Version 3.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at:
//
//   https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "RAFLocationManager.h"
@import CoreLocation;

NSString * const RAFLocationDidChangeNotification = @"RAFLocationDidChangeNotification";
NSString * const RAFLocationKey = @"RAFLocationKey";


@interface RAFLocationManager() <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@end


@implementation RAFLocationManager

#pragma mark - Lifecycle

+ (instancetype)sharedInstance; {
    static dispatch_once_t once;
    static RAFLocationManager *sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[RAFLocationManager alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Helper methods

- (void)startLocating {
    if (!self.locationServicesAllowed) {
        NSLog(@"[RAFLocationManager] Location services not allowed");
        return;
    }
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.distanceFilter = 30.0;
    }
    
    [_locationManager startUpdatingLocation];
}

- (void)endLocating {
    [_locationManager stopUpdatingLocation];
}

- (BOOL)locationServicesAllowed {
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways;
}

#pragma mark - CLLLocationManageDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {

    CLLocation *location = [locations lastObject];
    if (location == nil) {
        return;
    }

    _currentLocation = location;

    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    userInfo[RAFLocationKey] = _currentLocation;

    dispatch_async(dispatch_get_main_queue(),^ {
        [[NSNotificationCenter defaultCenter] postNotificationName:RAFLocationDidChangeNotification
                                                            object:userInfo];
    });
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"[RAFLocationManager] Error: %@", error);
}

@end
