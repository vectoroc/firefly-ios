//
//  FFObjectSource.h
//  firefly
//
//  Created by Victor Grigoriev on 8/25/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface FFPlaceModel : NSObject <MKAnnotation>

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *metier;
@property (nonatomic, strong) NSString  *logo;
@property (nonatomic, strong) NSString  *logo_big;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *discount;
@property (nonatomic, strong) NSString *site;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *openHours;
@property (nonatomic, strong) NSArray  *photos;


#pragma -
#pragma MKAnnotation

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *subtitle;


@end
