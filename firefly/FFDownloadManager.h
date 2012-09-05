//
//  FFServer.h
//  firefly
//
//  Created by Victor Grigoriev on 9/5/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString * const kFFDownloadManagerNotificationCatalogData;
extern NSString * const kFFDownloadManagerNotificationPlacesData;

@interface FFDownloadManager : NSObject

+(FFDownloadManager*)sharedInstance;

-(void)requestCatalogData;
-(void)requestPlacesDataWithCategory:(NSInteger)category andCoordinates:(CLLocationCoordinate2D)coordinates;

@end
