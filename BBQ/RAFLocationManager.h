@interface RAFLocationManager : NSObject

@property (nonatomic, readonly) CLLocation *currentLocation;

+ (instancetype)sharedInstance;
- (void)startLocating;
- (void)endLocating;
- (BOOL)locationServicesAllowed;

@end

extern NSString * const RAFLocationDidChangeNotification;
extern NSString * const RAFNewLocationKey;
extern NSString * const RAFOldLocationKey;
