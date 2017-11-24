#import "Placemark.h"


@implementation Placemark

@dynamic name;
@dynamic district;
@dynamic longitude;
@dynamic latitude;
@dynamic placeDescription;
@dynamic publicTransportation;
@dynamic activities;


- (NSString *)title {
    return self.name;
}

- (NSString *)subtitle {
    return self.district;
}

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coord;
    coord.latitude = [self.latitude doubleValue];
    coord.longitude = [self.longitude doubleValue];
    return coord;
}

@end
