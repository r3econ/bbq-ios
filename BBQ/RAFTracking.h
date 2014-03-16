@class Placemark;

@interface RAFTracking : NSObject


+ (id)sharedInstance;
- (void)trackPageView:(NSString *)pageName;
- (void)trackError:(NSError *)error;
- (void)trackShareButtonTapped;
- (void)trackShareWithSocialNetwork:(NSString *)socialNetwork;
- (void)viewPlacemarkDetails:(Placemark *)placemark;


@end