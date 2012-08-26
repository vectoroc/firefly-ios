//
//  FFObjectSource.m
//  firefly
//
//  Created by Victor Grigoriev on 8/25/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import "FFObjectModel.h"

@implementation FFObjectModel

- (id)initWithId:(NSInteger) id title:(NSString *)title metier:(NSString *)metier latlon:(CLLocationCoordinate2D)latlon
{
    self = [self init];
    if (self) {
        self.id = id;
        self.title = title;
        self.metier = metier;
        self.latlon = latlon;
    }
    
    return self;
}

@end
