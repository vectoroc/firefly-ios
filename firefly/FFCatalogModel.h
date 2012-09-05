//
//  FFCatalogModel.h
//  firefly
//
//  Created by Victor Grigoriev on 9/3/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFCatalogCategory : NSObject

@property (assign, nonatomic) NSInteger  id;
@property (assign, nonatomic) NSInteger  parent;
@property (assign, nonatomic) NSInteger  weight;
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) NSURL     *icon_url;

@end

@interface FFCatalogModel : NSObject

@property (strong, nonatomic) NSArray *categories;

-(id)initWithObject:(id)data;

-(FFCatalogCategory*)category:(NSInteger)id;
-(NSArray*)categoriesByParent:(NSInteger)parent;
-(NSArray*)categoriesByParent:(NSInteger)parent depth:(NSInteger)depth;

@end
