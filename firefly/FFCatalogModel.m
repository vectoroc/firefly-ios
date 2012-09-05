//
//  FFCatalogModel.m
//  firefly
//
//  Created by Victor Grigoriev on 9/3/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import "FFCatalogModel.h"
#import "Libraries/AFNetworking/AFNetworking.h"

@implementation FFCatalogCategory
@end

@implementation FFCatalogModel

-(id)initWithObject:(id)data
{
    self = [self init];
    if (self) {
        
        NSMutableArray *list = [NSMutableArray new];
        
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            FFCatalogCategory* category = [FFCatalogCategory new];
            
            category.id = [[obj valueForKey:@"id"] integerValue];
            category.parent = [[obj valueForKey:@"parent"] integerValue];
            category.weight = [[obj valueForKey:@"weight"] integerValue];
            category.name = [obj valueForKey:@"name"];
            category.icon_url = [NSURL URLWithString:[obj valueForKey:@"icon_url"]];
            
            [list addObject:category];
        }];
        
        self.categories = [list copy];
    }
    
    return self;
}

-(FFCatalogCategory*)category:(NSInteger)id
{
    NSInteger idx = [self.categories indexOfObjectPassingTest:^BOOL(FFCatalogCategory *obj, NSUInteger idx, BOOL *stop) {
        return obj.id == id;
    }];
    return idx != NSNotFound ? [self.categories objectAtIndex:idx] : nil;
}

-(NSArray*)categoriesByParent:(NSInteger)parent
{
    NSArray *children;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"parent = %d", parent]];
    children = [self.categories filteredArrayUsingPredicate:predicate];
    return children;
}

-(NSArray*)categoriesByParent:(NSInteger)parent depth:(NSInteger)depth
{
    NSArray __block *categories;
    if (depth) {
        categories = [self categoriesByParent:parent];
        
        [categories enumerateObjectsUsingBlock:^(FFCatalogCategory *obj, NSUInteger idx, BOOL *stop) {
            categories = [categories arrayByAddingObjectsFromArray:[self categoriesByParent:obj.id depth:depth - 1]];
        }];
        
        depth--;
    }
    
    return categories;
}

@end
