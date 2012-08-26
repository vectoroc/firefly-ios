//
//  FFObjectSource.h
//  firefly
//
//  Created by Victor Grigoriev on 8/25/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FFObjectModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *metier;
@property (nonatomic, strong) UIImage  *logo;
@property (nonatomic) CLLocationCoordinate2D latlon;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *site;
@property (nonatomic, strong) NSString *openHours;
@property (nonatomic, strong) NSArray  *photos;

- (id)initWithId:(NSInteger) id title:(NSString *)title metier:(NSString *)metier latlon:(CLLocationCoordinate2D)latlon;

@end
