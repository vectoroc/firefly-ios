//
//  FFMapViewController.h
//  firefly
//
//  Created by Victor Grigoriev on 9/1/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "FFPlacesListModel.h"
#import "FFPlaceModel.h"
#import "FFPlaceViewController.h"



@interface FFMapViewController : UIViewController

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *places;

@end
