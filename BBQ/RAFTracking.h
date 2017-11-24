@class Placemark;

@interface RAFTracking : NSObject

+ (id)sharedInstance;
- (void)trackPageView:(NSString *)pageName;
- (void)trackError:(NSError *)error;

@end
