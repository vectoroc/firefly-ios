//
//  FFObjectsListViewController.h
//  firefly
//
//  Created by Victor Grigoriev on 8/25/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>
#import "FFObjectsListModel.h"
#import "Libraries/AFNetworking/UIImageView+AFNetworking.h"

@interface FFObjectsListViewController : UITableViewController

@property (strong, nonatomic) FFObjectsListModel* dataSource;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
