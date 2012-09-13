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
-(void)setImageWithURL:(NSURL *)url forState:(UIControlState)state
{
    __block id this = self;
    [self _ff_downloadImage:url success:^(UIImage *image) {
        [this setImage:image forState:state];        
    } failure:nil];
    
}

-(void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state
{
    __block id this = self;
    [self _ff_downloadImage:url success:^(UIImage *image) {
        [this setBackgroundImage:image forState:state];
    } failure:nil];
}

-(void)_ff_downloadImage:(NSURL *)url
              success:(void(^)(UIImage* image))success
              failure:(void(^)(NSError* error))failure
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        if (success) success(image);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        NSLog(@"Failed button background image downloading: %@", error);
        if (failure) failure(error);
    }];
}
@end
