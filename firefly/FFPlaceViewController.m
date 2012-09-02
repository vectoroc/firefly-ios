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
@property (weak, nonatomic) IBOutlet UILabel *metier;
@property (weak, nonatomic) IBOutlet UILabel *description;

@end

@implementation FFPlaceViewController
@synthesize place;
@synthesize logo;
@synthesize metier;
@synthesize description;


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
    self.metier.text = self.place.metier;
    self.description.text = self.place.description;
    [self.description sizeToFit];
    
    if (![self.place.logo isEqualToString:@""]) {
        [self.logo setImageWithURL:[NSURL URLWithString:self.place.logo] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [self setLogo:nil];
    [self setMetier:nil];
    [self setDescription:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
