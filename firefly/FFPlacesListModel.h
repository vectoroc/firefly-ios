//
//  FFObjectsListSource.h
//  firefly
//
//  Created by Victor Grigoriev on 8/25/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFPlaceModel.h"

@protocol FFPlacesListModelDelegate <NSObject>

-(void)objectsListModeldidDataRecive;

@end


@interface FFPlacesListModel : NSObject

@property(nonatomic, strong) NSMutableArray *places;
@property(nonatomic, assign) id delegate;

+(FFPlacesListModel*) sharedInstance;
-(void)sortByLocation:(CLLocation*)location;

@end
