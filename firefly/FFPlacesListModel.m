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

@synthesize places=_objectsList;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.places = [[NSMutableArray alloc] init];
                
        NSURL *url = [NSURL URLWithString:@"http://webmanager.dev/iphone-client"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [JSON enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
            
            [self.delegate objectsListModeldidDataRecive];
            NSLog(@"JSON donwload finished");
            
        } failure:nil];
        
        [operation start];
        NSLog(@"JSON download start");
    }
    
    return self;
}


+(FFPlacesListModel*) sharedInstance
{
    static id _instance;
    if (!_instance) {
        _instance = [[FFPlacesListModel alloc] init];
    }    
    return _instance;
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
