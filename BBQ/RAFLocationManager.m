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
#import <CoreLocation/CoreLocation.h>

NSString * const RAFLocationDidChangeNotification = @"RAFLocationDidChangeNotification";
NSString * const RAFNewLocationKey = @"RAFNewLocationKey";
NSString * const RAFOldLocationKey = @"RAFOldLocationKey";


@interface RAFLocationManager() <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@end


@implementation RAFLocationManager

#pragma mark - Lifecycle

+ (instancetype)sharedInstance; {
    static dispatch_once_t once;
    static RAFLocationManager *sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [[RAFLocationManager alloc] init];
                      
                      [sharedInstance configure];
                  });
    
    return sharedInstance;
}

- (void)configure {
    // Do nothing
}

#pragma mark - Helper methods

- (void)startLocating {
    if ([self isLocationManagerAvailable]) {
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            
            _locationManager.delegate = self;
            _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
            _locationManager.distanceFilter = 30;
        }
        
        [_locationManager startUpdatingLocation];
    }
    else {
        // TODO: Move the UI logic elsewhere
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:NSLocalizedString(@"info_location_mode", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles: nil] show];
    }
}

- (void)endLocating {
    [_locationManager stopUpdatingLocation];
}

- (BOOL)isLocationManagerAvailable {
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            return NO;
            
        case kCLAuthorizationStatusAuthorizedAlways:
        default:
            return YES;
    }
}

- (BOOL)locationServicesAllowed {
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways;
}

#pragma mark - CLLLocationManageDelegate


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    _currentLocation = newLocation;
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];

    if (newLocation) {
        userInfo[RAFNewLocationKey] = newLocation;
    }
    
    if (oldLocation) {
        userInfo[RAFOldLocationKey] = oldLocation;
    }
    
    dispatch_async(dispatch_get_main_queue(),^ {
        [[NSNotificationCenter defaultCenter] postNotificationName:RAFLocationDidChangeNotification
                                                            object:userInfo];
    });
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}

@end
