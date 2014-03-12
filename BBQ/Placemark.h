#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>


@interface Placemark : NSManagedObject<MKAnnotation>

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * district;
@property (nonatomic, retain) NSString * placeDescription;
@property (nonatomic, retain) NSString * publicTransportation;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;

@end
