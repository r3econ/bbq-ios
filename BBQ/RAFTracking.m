#import "RAFTracking.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "Placemark.h"

#define kGATrackingID @"UA-47897348-3"
#define kCategoryErrors @"Errors"
#define kCategoryUIEvents @"UI Events"

@implementation RAFTracking


+ (id)sharedInstance {
    static dispatch_once_t once;
    static RAFTracking *sharedInstance;
    
    dispatch_once(&once, ^{
                      sharedInstance = [[self alloc] init];
                      
                      [sharedInstance configureTracker];
                  });
    
    return sharedInstance;
}


- (void)configureTracker {
    [[GAI sharedInstance] trackerWithTrackingId:kGATrackingID];
    
#ifdef DEBUG
    [GAI sharedInstance].dryRun = YES;
#endif
    
}


- (void)trackPageView:(NSString *)pageName
{
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:pageName];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
}


- (void)trackError:(NSError *)error
{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:kCategoryErrors
                                                                                        action:error.description
                                                                                         label: error.domain
                                                                                         value:@(error.code)] build]];
}


- (void)trackShareButtonTapped
{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:kCategoryUIEvents
                                                                                        action:@"Share button tapped"
                                                                                         label:nil
                                                                                         value:nil] build]];
}


- (void)viewPlacemarkDetails:(Placemark *)placemark
{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:kCategoryUIEvents
                                                                                        action:@"Viewed placemark details"
                                                                                         label:placemark.title
                                                                                         value:nil] build]];
}


- (void)trackShareWithSocialNetwork:(NSString *)socialNetwork
{
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createSocialWithNetwork:socialNetwork
                                                                                        action:@"Share"
                                                                                        target:nil] build]];
    
}


@end
