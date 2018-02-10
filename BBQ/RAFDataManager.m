//
//  RAFDataManager.m
//  BBQ-Berlin
//
//  Created by Rafał on 10.02.18.
//  Copyright © 2018 Rafal Sroka. All rights reserved.
//

#import "RAFDataManager.h"
@import CoreData;

@interface RAFDataManager ()

@property (strong, nonatomic) NSPersistentContainer *persistentContainer;

@end

@implementation RAFDataManager

- (id)initWithModel:(NSString *)modelName {
    self = [super init];
    if (!self) return nil;
    
    self.persistentContainer = [[NSPersistentContainer alloc] initWithName:modelName];
    [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *description,
                                                                          NSError *error) {
        if (error != nil) {
            NSLog(@"Failed to load Core Data stack: %@", error);
            abort();
        }
    }];

    return self;
}

- (NSManagedObjectContext *)viewContext {
    return self.persistentContainer.viewContext;
}

- (NSURL *)databaseJSONContentURL {
    return [[NSBundle mainBundle] URLForResource:@"Berlin" withExtension:@"json"];
}

- (void)loadInitialContentWithSuccessHandler:(void (^)(void))successHandler
                                     failure:(void (^)(NSError *))failureHandler {
    // Try to load data from json
    NSError *error = nil;
    NSData *JSONData = [NSData dataWithContentsOfURL:[self databaseJSONContentURL]];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
    if (dictionary == nil && error == nil) {
        failureHandler(error);
        return;
    }
    
    NSArray *placemarks = dictionary[@"placemarks"];
    [placemarks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Placemark *placemark = [NSEntityDescription insertNewObjectForEntityForName:@"Placemark"
                                                             inManagedObjectContext:self.viewContext];
        // Mandatory attributes.
        placemark.name = obj[@"name"];
        placemark.longitude = obj[@"longitude"];
        placemark.latitude = obj[@"latitude"];
        placemark.district = obj[@"district"];
        placemark.placeDescription = obj[@"description"];
        
        // Optional attributes.
        if ([obj[@"public_transport"] isKindOfClass:[NSString class]]) placemark.publicTransportation = obj[@"public_transport"];
        if ([obj[@"activities"] isKindOfClass:[NSString class]]) placemark.activities = obj[@"activities"];
    }];
    
    BOOL success = [self.viewContext save:&error];
    if (success) {
        successHandler();
    }
    else {
        failureHandler(error);
    }
}

@end
