//
//  FFObjectsListSource.m
//  firefly
//
//  Created by Victor Grigoriev on 8/25/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import "FFObjectsListModel.h"
#import "Libraries/AFNetworking/AFNetworking.h"

@implementation FFObjectsListModel

@synthesize objectsList=_objectsList;

-(id)init
{
    self = [super init];
    if (self)
    {
    
        self.objectsList = [[NSMutableArray alloc] init];
        
        NSURL *url = [NSURL URLWithString:@"http://webmanager.dev/iphone-client"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [JSON enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                CLLocationCoordinate2D coord;
                
                coord.latitude = [[obj valueForKeyPath:@"location.lat"] floatValue];
                coord.longitude = [[obj valueForKeyPath:@"location.lon"] floatValue];
                
                id ffobj = [[FFObjectModel alloc] initWithId:11 title:[obj valueForKey:@"title"] metier:[obj valueForKey:@"subtitle"] latlon:coord];
                
                [self.objectsList addObject:ffobj];
                
                NSLog(@"list size: %d / last title: %@", [self.objectsList count], [ffobj title]);
            }];
            
        } failure:nil];
        
        NSLog(@"before start");
        [operation start];
        NSLog(@"after start");
    }
    
    return self;
}


@end
