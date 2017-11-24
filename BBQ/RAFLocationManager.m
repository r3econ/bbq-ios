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
