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

#import "RAFAppDelegate.h"
#import "RAFDataManager.h"

@interface RAFAppDelegate ()

@property (strong, nonatomic) RAFDataManager *dataManager;

@end

static NSString *const kHasLaunchedOnce = @"HasLaunchedOnce";

@implementation RAFAppDelegate

#pragma mark - Helper methods

+ (RAFAppDelegate *)sharedInstance {
    return (RAFAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)isFirstLaunch {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kHasLaunchedOnce]) {
        return NO;
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:kHasLaunchedOnce];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // This is the first launch ever
        return YES;
    }
}

- (void)resetFirstLaunch {
    [[NSUserDefaults standardUserDefaults] setBool:NO
                                            forKey:kHasLaunchedOnce];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [RAFAppearance configureAppearance];

    [self configureTabBarController];
    [self configureDataManager];
    
    return YES;
}

#pragma mark - Configuration

- (void)configureTabBarController {
    // Create the controller
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;

    // Configure appearance
    tabBarController.tabBar.standardAppearance = [RAFAppearance tabBarAppearance];
    if (@available(iOS 15.0, *)) {
        tabBarController.tabBar.scrollEdgeAppearance = [RAFAppearance tabBarAppearance];
    }

    // Get the tab bar items and customize them
    UITabBarItem *tabBarItem1 = (tabBarController.tabBar.items)[0];
    UITabBarItem *tabBarItem2 = (tabBarController.tabBar.items)[1];

    tabBarItem1.image = IMAGE_NAMED(@"MapUnselected");
    tabBarItem1.selectedImage = IMAGE_NAMED(@"MapSelected");
    tabBarItem1.title = NSLocalizedString(@"map_view_title", nil);

    tabBarItem2.image = IMAGE_NAMED(@"GrillUnselected");
    tabBarItem2.selectedImage = IMAGE_NAMED(@"GrillSelected");
    tabBarItem2.title = NSLocalizedString(@"locations_view_title", nil);
}

#pragma mark - Core Data

- (void)configureDataManager {
    if (_dataManager == nil) {
        _dataManager = [[RAFDataManager alloc] initWithModel:@"BBQ"];
    }
    
    // Check if it's the first launch. If so, inject database content.
    if ([self isFirstLaunch]) {
        [_dataManager loadInitialContentWithSuccessHandler:nil
                                                   failure:^(NSError *error) {
            NSLog(@"[RAFAppDelegate] Data import error: %@", error.localizedDescription);
            [self resetFirstLaunch];
        }];
    }
}

@end
