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


@implementation RAFAppDelegate

#pragma mark - Helper methods

+ (RAFAppDelegate *)sharedInstance {
    return (RAFAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)isFirstLaunch {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        return NO;
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // This is the first launch ever
        return YES;
    }
}

- (void)resetFirstLaunch {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"HasLaunchedOnce"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [RAFAppearance configureAppearance];

    [self configureTabBarController];
    [self configureDataManager];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Configuration

- (void)configureTabBarController {
    // Create the controller
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
    // Set the tint color
    tabBarController.tabBar.barTintColor = [RAFAppearance secondaryViewColor];
    
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
