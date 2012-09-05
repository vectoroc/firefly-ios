//
//  FFObjectViewController.m
//  firefly
//
//  Created by Victor Grigoriev on 8/27/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "FFPlaceViewController.h"
#import "FFMapViewController.h"
#import "Libraries/AFNetworking/AFNetworking.h"

@interface FFPlaceViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *metierLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *openhoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (strong, nonatomic) IBOutlet UITableView *detailsTableView;

@end

@implementation FFPlaceViewController
@synthesize place;
@synthesize logo;
@synthesize metierLabel;
@synthesize descriptionLabel;
@synthesize addressLabel;
@synthesize phoneLabel;
@synthesize openhoursLabel;
@synthesize websiteLabel;
@synthesize emailLabel;
@synthesize discountLabel;
@synthesize detailsTableView;


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    NSLog(@"FFPlaceViewController::initWithCoder");
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"Details->viewDidLoad");
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = self.place.title;
    self.metierLabel.text = self.place.metier;
    
    self.addressLabel.text = self.place.address;
    self.phoneLabel.text = self.place.phone;
    self.openhoursLabel.text = self.place.openHours;
    self.websiteLabel.text = self.place.site;
    self.emailLabel.text = self.place.email;
    self.discountLabel.text = self.place.discount;
        
    self.descriptionLabel.text = self.place.description;
    [self.descriptionLabel sizeToFit];
    [self.descriptionLabel.superview sizeToFit];
    [self.descriptionLabel.superview.superview sizeToFit];
    
    if (!self.place.discount) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        [self.detailsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    

    
//    NSLog(@"super class %@", NSStringFromClass([self.descriptionLabel.superview class]));
//    NSLog(@"super super class %@", NSStringFromClass([self.descriptionLabel.superview.superview class]));
//    UITableViewCell* cell;
//    UIView *superview = (UIView*)self.superclass;
//    [superview sizeToFit];
//    cell.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    cell setContentMode:UIViewContent
//
//    CGRect rect = self.descriptionLabel.superview.bounds;
//    rect.size.height = CGRectGetHeight(self.descriptionLabel.bounds);
//    self.
//    self.descriptionLabel.superview.bounds = rect;
        
    if (![self.place.logo_big isEqualToString:@""]) {
        [self.logo setImageWithURL:[NSURL URLWithString:self.place.logo_big] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }

    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [self setLogo:nil];
    [self setMetierLabel:nil];
    [self setDescriptionLabel:nil];
    [self setAddressLabel:nil];
    [self setPhoneLabel:nil];
    [self setOpenhoursLabel:nil];
    [self setWebsiteLabel:nil];
    [self setEmailLabel:nil];
    [self setDiscountLabel:nil];
    [self setDetailsTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return CGRectGetHeight(self.descriptionLabel.bounds) + 20;
    }
    else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

#pragma Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"viewOnMap"]) {
        FFMapViewController *viewController = (FFMapViewController*)segue.destinationViewController;
        viewController.places = [NSArray arrayWithObject:self.place];
    }
}

@end
