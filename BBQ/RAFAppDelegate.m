#import "RAFAppDelegate.h"


@implementation RAFAppDelegate


#pragma mark - Appearance


- (void)configureAppearance
{    
    [UIView appearance].tintColor = [UIColor blackColor];
}


#pragma mark - Configuration


- (NSURL *)URLForJSONWithDatabaseContent
{
    return [[NSBundle mainBundle] URLForResource:@"Berlin" withExtension:@"json"];
}


- (NSString *)databasePath
{
    return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Berlin.sqlite"];
}


#pragma mark - Helper methods


+ (RAFAppDelegate *)delegate
{
    return [UIApplication sharedApplication].delegate;
}


+ (NSManagedObjectContext *)managedObjectContext
{
    return [RAFAppDelegate delegate].managedObjectContext;
}


- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                NSUserDomainMask,
                                                YES)
            objectAtIndex:0];
}


- (BOOL)isFirstLaunch
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        return NO;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // This is the first launch ever
        return YES;
    }
}


#pragma mark - UIApplicationDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configureAppearance];
    [self createPersistentStore];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Core Data


- (NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    return _persistentStoreCoordinator;
}


- (void)createPersistentStore
{
    NSError *error = nil;
    NSURL *storeUrl = [NSURL fileURLWithPath:[self databasePath]];
    
    if([self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                     configuration:nil
                                                               URL:storeUrl
                                                           options:nil
                                                             error:&error])
    {
        // Check if it's the first launch. If so, create a database.
        if ([self isFirstLaunch])
        {
            NSError *error = nil;
            NSData *JSONData = [NSData dataWithContentsOfURL:[self URLForJSONWithDatabaseContent]];
            
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
            NSString *locale = dictionary[@"locale"];
            NSArray *placemarks = dictionary[@"placemarks"];
            
            NSLog(@"Locale: %@", locale);
            
            [placemarks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
             {
                 Placemark *placemark = [NSEntityDescription insertNewObjectForEntityForName:@"Placemark"
                                                                      inManagedObjectContext:self.managedObjectContext];
                 
                 // Mandatory attributes.
                 placemark.name = [obj objectForKey:@"name"];
                 placemark.longitude = [obj objectForKey:@"longitude"];
                 placemark.latitude = [obj objectForKey:@"latitude"];
                 placemark.district = [obj objectForKey:@"district"];
                 placemark.placeDescription = [obj objectForKey:@"description"];
                 
                 // Optional attributes.
                 if ([[obj objectForKey:@"public_transport"] isKindOfClass:[NSString class]]) placemark.publicTransportation = [obj objectForKey:@"public_transport"];
                 if ([[obj objectForKey:@"activities"] isKindOfClass:[NSString class]]) placemark.activities = [obj objectForKey:@"activities"];
                 
                 NSError *error;
                 
                 if (![self.managedObjectContext save:&error])
                 {
                     NSLog(@"Couldn't save: %@", [error localizedDescription]);
                 }
             }];
        }
    }
    else
    {
        /*Error for store creation should be handled in here*/
        NSLog(@"Error %@", error.localizedDescription);
    }
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}


@end
