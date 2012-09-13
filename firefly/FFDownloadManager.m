//
//  FFServer.m
//  firefly
//
//  Created by Victor Grigoriev on 9/5/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import "FFDownloadManager.h"
#import "Libraries/AFNetworking/AFNetworking.h"
#import "Libraries/AFNetworking/AFNetworkActivityIndicatorManager.h"

NSString * const kFFDownloadManagerNotificationCatalogData = @"firefly.data.catalog";
NSString * const kFFDownloadManagerNotificationPlacesData = @"firefly.data.places";

@implementation FFDownloadManager

+(FFDownloadManager*)sharedInstance
{
    static FFDownloadManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [FFDownloadManager new];
    });
    return _instance;
}

-(NSURL*)baseURL
{
    return [NSURL URLWithString:@"http://webmanager.dev"];
}

-(void)incrementActivityCount
{
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];   
}

-(void)decrementActivityCount
{
    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
}

-(void)requestCatalogData
{
    NSURL *url = [[self baseURL] URLByAppendingPathComponent:@"iphone-client/catalog"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    [request addValue:language forHTTPHeaderField:@"Accept-Language"];

    [self incrementActivityCount];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self decrementActivityCount];
        [[NSNotificationCenter defaultCenter] postNotificationName:kFFDownloadManagerNotificationCatalogData object:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self decrementActivityCount];
        NSLog(@"failed to fetch catalog data: %@", error);
    }];
    
    NSLog(@"request started: %@", request);
    [operation start];
}

-(void)requestPlacesDataWithCategory:(NSInteger)category andCoordinates:(CLLocationCoordinate2D)coordinates
{
    NSString *pathcompenent = [NSString stringWithFormat:@"iphone-client/list/%d/%f,%f", category, coordinates.latitude, coordinates.longitude];
    
    NSURL *url = [[self baseURL] URLByAppendingPathComponent:pathcompenent];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    [request addValue:language forHTTPHeaderField:@"Accept-Language"];
    
    [self incrementActivityCount];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self decrementActivityCount];
        [[NSNotificationCenter defaultCenter] postNotificationName:kFFDownloadManagerNotificationPlacesData object:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self decrementActivityCount];
        NSLog(@"failed to fetch places data: %@", error);
    }];
    
    NSLog(@"request started: %@", request);
    [operation start];
}

@end
