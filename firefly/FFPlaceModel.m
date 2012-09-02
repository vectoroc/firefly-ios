//
//  FFObjectSource.m
//  firefly
//
//  Created by Victor Grigoriev on 8/25/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import "FFPlaceModel.h"

@implementation FFPlaceModel

@dynamic coordinate;
@dynamic subtitle;

-(NSString*)subtitle
{
    return self.metier;
}

-(CLLocationCoordinate2D)coordinate
{
    return self.location.coordinate;
}

@end
