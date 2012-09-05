//
//  FFObjectsListSource.h
//  firefly
//
//  Created by Victor Grigoriev on 8/25/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFPlaceModel.h"

@interface FFPlacesListModel : NSObject

@property(nonatomic, strong) NSMutableArray *places;

-(FFPlacesListModel*)initWithObject:(id)data;
-(void)sortByLocation:(CLLocation*)location;

@end
