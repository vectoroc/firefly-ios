//
//  UIButton+bgImageByURL.h
//  firefly
//
//  Created by Victor Grigoriev on 9/5/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (bgImageByURL)
-(void)setImageWithURL:(NSURL *)url forState:(UIControlState)state;
-(void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state;
@end
