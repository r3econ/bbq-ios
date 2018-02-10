//
//  RAFDataManager.h
//  BBQ-Berlin
//
//  Created by Rafał on 10.02.18.
//  Copyright © 2018 Rafal Sroka. All rights reserved.
//

@import Foundation;

@interface RAFDataManager : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *viewContext;

- (id)initWithModel:(NSString *)modelName;
- (void)loadInitialContentWithSuccessHandler:(void (^)(void))successHandler
                                     failure:(void (^)(NSError *))failureHandler;

@end
