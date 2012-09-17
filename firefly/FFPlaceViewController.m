//
//  FFObjectViewController.m
//  firefly
//
//  Created by Victor Grigoriev on 8/27/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>

#import "FFPlaceViewController.h"
#import "FFMapViewController.h"
#import "Libraries/AFNetworking/AFNetworking.h"
#import "Libraries/MWPhotoBrowser/Classes/MWPhotoBrowser.h"


@interface FFPlaceViewController () <MWPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *metierLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) NSArray *detailsFields;
@property (strong, nonatomic) NSIndexSet *detailsFieldsIndexSet;

@property (strong, nonatomic) NSArray *photos;

@end

@implementation FFPlaceViewController {
    NSUInteger *_detailFieldsRows;
}

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
    
    // ordered list of fields in section 0 
    self.detailsFields = @[
        @"address",
        @"phone",
        @"openHours",
        @"site",
        @"email",
        @"discount",
        @"photos"
    ];
            
    self.detailsFieldsIndexSet = [self.detailsFields indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        id objVal = [self.place valueForKey:obj];
        NSUInteger counter = 0;
        if ([objVal respondsToSelector:@selector(count)]) {
            counter = [objVal count];
        }
        if ([objVal respondsToSelector:@selector(length)]) {
            counter = [objVal length];
        }
        return counter > 0;
    }];
    
    self->_detailFieldsRows = malloc(sizeof(NSUInteger) * [self.detailsFieldsIndexSet count]);
    [self.detailsFieldsIndexSet getIndexes:self->_detailFieldsRows maxCount:[self.detailsFieldsIndexSet count] inIndexRange:nil];
    
    self.navigationItem.title = self.place.title;
    self.metierLabel.text = self.place.metier;
    
    self.descriptionLabel.text = self.place.description;
    [self.descriptionLabel sizeToFit];
        
    if (![self.place.logo_big isEqualToString:@""]) {
        [self.logo setImageWithURL:[NSURL URLWithString:self.place.logo_big] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    
    NSMutableArray *photos = [NSMutableArray array];
    [self.place.photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:obj]]];
    }];
    [self setPhotos:photos];
}

- (void)viewDidUnload
{
    [self setLogo:nil];
    [self setMetierLabel:nil];
    [self setDescriptionLabel:nil];
    [self setPlace:nil];
    [self setDetailsFields:nil];
    [self setDetailsFieldsIndexSet:nil];
    [self setPhotos:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    free(self->_detailFieldsRows);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - tableview staff

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection");
    if (section == 0) {
        return [self.detailsFieldsIndexSet count];
    }
    
    return [super tableView:tableView numberOfRowsInSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSUInteger row = self->_detailFieldsRows[indexPath.row];
        
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
        
        NSString *key = [self.detailsFields objectAtIndex:row];
        if (![key isEqualToString:@"photos"]) {
            cell.textLabel.text = [self.place valueForKey:key];            
        }

        return cell;
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        // adjust height of description section
        return CGRectGetHeight(self.descriptionLabel.bounds) + 20;
    }
    else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

#pragma mark - Segues and actions

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"viewOnMap"]) {
        FFMapViewController *viewController = (FFMapViewController*)segue.destinationViewController;
        viewController.places = [NSArray arrayWithObject:self.place];
    }
    else if ([segue.identifier isEqualToString:@"viewPhotos"]) {
        MWPhotoBrowser *viewController = (id) segue.destinationViewController;
        viewController.delegate = self;
    }
}


- (IBAction)siteTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.place.site]];
}

- (IBAction)mailTapped:(id)sender {
    NSString *mail = [NSString stringWithFormat:@"mailto:%@", self.place.email];
    NSURL *url = [NSURL URLWithString:mail];

    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to send email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - MWPhotoBrowserDelegate

-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [self.photos count];
}

-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return [self.photos objectAtIndex:index];
}

@end
