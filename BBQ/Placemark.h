//
//  Placemark.h
//  BBQ
//
//  Created by Rafal Sroka on 10.03.14.
//  Copyright (c) 2014 Rafal Sroka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Placemark : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * district;
@property (nonatomic, retain) NSString * placeDescription;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;

@end
