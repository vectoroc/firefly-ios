//
//  FFPlaceTableViewCell.m
//  firefly
//
//  Created by Victor Grigoriev on 9/5/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import "FFPlaceTableViewCell.h"

@implementation FFPlaceTableViewCell
@synthesize imageView;
@synthesize textLabel;
@synthesize detailTextLabel;
@synthesize distLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
