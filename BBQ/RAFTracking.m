#import "RAFTracking.h"
#import "Placemark.h"

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
    // Here configure the tracker if any
}

- (void)trackPageView:(NSString *)pageName {
    // Add page tracking here
}


- (void)trackError:(NSError *)error {
    // Add error tracking here
}

@end
