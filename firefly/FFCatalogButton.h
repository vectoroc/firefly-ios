//
//  FFCatalogButton.h
//  firefly
//
//  Created by Victor Grigoriev on 9/19/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFCatalogButton : UIButton

@property NSInteger iconIndex;

@property CGFloat iconWidth;
@property CGFloat iconHeight;

@property id delegate;

@end
