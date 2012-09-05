//
//  FFObjectsListViewController.h
//  firefly
//
//  Created by Victor Grigoriev on 8/25/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "FFPlacesListModel.h"

@interface FFPlacesListViewController : UITableViewController

@property (assign, nonatomic) NSInteger category;
@property (strong, nonatomic) FFPlacesListModel* dataSource;

@end
