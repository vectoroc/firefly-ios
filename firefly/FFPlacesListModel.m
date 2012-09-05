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

-(FFPlacesListModel*)initWithObject:(id)data
{
    self = [self init];
    if (self) {
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            FFPlaceModel *place = [[FFPlaceModel alloc] init];
            
            place.id = [[obj valueForKey:@"id"] integerValue];
            place.title = [obj valueForKey:@"title"];
            place.metier = [obj valueForKey:@"metier"];
            place.description = [obj valueForKey:@"description"];
            place.address = [obj valueForKey:@"address"];
            place.phone = [obj valueForKey:@"phone"];
            place.site = [obj valueForKey:@"site"];
            place.email = [obj valueForKey:@"email"];
            place.discount = [obj valueForKey:@"discount"];
            place.openHours = [obj valueForKey:@"openhours"];
            place.logo = [obj valueForKey:@"logo"];
            place.photos = [obj valueForKey:@"photos"];
            
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
