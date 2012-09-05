//
//  FFObjectsListSource.m
//  firefly
//
//  Created by Victor Grigoriev on 8/25/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import "FFPlacesListModel.h"
#import "Libraries/AFNetworking/AFNetworking.h"

@implementation FFPlacesListModel

-(id)init
{
    self = [super init];
    if (self) {
        self.places = [NSMutableArray new];
    }
    return self;
}

#define VAL4KEY(obj, key) ([obj valueForKey:key] != [NSNull null] ? [obj valueForKey:key] : nil);

-(FFPlacesListModel*)initWithObject:(id)data
{
    self = [self init];
    if (self) {
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            FFPlaceModel *place = [[FFPlaceModel alloc] init];
            
            place.id = [[obj valueForKey:@"id"] integerValue];
            place.title = VAL4KEY(obj, @"title");
            place.metier = VAL4KEY(obj, @"metier");
            place.description = VAL4KEY(obj, @"description");
            place.address = VAL4KEY(obj, @"address");
            place.phone = VAL4KEY(obj, @"phone");
            place.site = VAL4KEY(obj, @"site");
            place.email = VAL4KEY(obj, @"email");
            place.discount = VAL4KEY(obj, @"discount");
            place.openHours = VAL4KEY(obj, @"openhours");
            place.logo = VAL4KEY(obj, @"logo");
            place.logo_big = VAL4KEY(obj, @"logo_big");
            place.photos = VAL4KEY(obj, @"photos");
            
            CLLocationDegrees lat = [[obj valueForKeyPath:@"location.latitude"] floatValue];
            CLLocationDegrees lon = [[obj valueForKeyPath:@"location.longitude"] floatValue];
            place.location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
            
            [self.places addObject:place];
        }];        
    }
    
    return self;
}


-(void) sortByLocation:(CLLocation*)location
{
    NSArray *places = [self.places sortedArrayUsingComparator:^NSComparisonResult(FFPlaceModel* a, FFPlaceModel* b) {
        CLLocationDistance a_dist = [location distanceFromLocation:a.location];
        CLLocationDistance b_dist = [location distanceFromLocation:b.location];
        
        if (a_dist < b_dist) return NSOrderedAscending;
        else if (a_dist > b_dist) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
    
    self.places = [places mutableCopy];
}

@end
