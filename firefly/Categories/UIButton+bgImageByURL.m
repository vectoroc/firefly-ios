//
//  UIButton+bgImageByURL.m
//  firefly
//
//  Created by Victor Grigoriev on 9/5/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import "UIButton+bgImageByURL.h"
#import "../Libraries/AFNetworking/AFNetworking.h"
#import "../Libraries/AFNetworking/UIImageView+AFNetworking.h"

@implementation UIButton (bgImageByURL)
-(void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    __block id this = self;
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [this setBackgroundImage:image forState:state];
    } failure:nil];
    
}
@end
