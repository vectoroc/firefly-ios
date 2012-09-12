//
//  FFObjectsListViewController.m
//  firefly
//
//  Created by Victor Grigoriev on 8/25/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import "FFDownloadManager.h"
#import "FFPlacesListViewController.h"
#import "FFPlaceViewController.h"
#import "Libraries/AFNetworking/AFNetworking.h"
#import "Libraries/AFNetworking/UIImageView+AFNetworking.h"

#import <CoreLocation/CoreLocation.h>

#import "FFPlaceTableViewCell.h"

@interface FFPlacesListViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager* locationManager;

@end

@implementation FFPlacesListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:kFFDownloadManagerNotificationPlacesData object:nil];
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setDelegate:self];
    [self.locationManager setPurpose:@"Obtain current location to sort results"];
    [self.locationManager startMonitoringSignificantLocationChanges];

    if (!self.dataSource) {
        [[FFDownloadManager sharedInstance] requestPlacesDataWithCategory:self.category andCoordinates:self.locationManager.location.coordinate];
    }
}


- (void)viewDidUnload
{
    [self setDataSource:nil];
    [self setMyTableView:nil];
    [self setLocationManager:nil];
    [self setMapView:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFPlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"objectListCell"];
    return CGRectGetHeight(cell.frame);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFPlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"objectListCell"];
    FFPlaceModel *object = [self.dataSource.places objectAtIndex:indexPath.row];
    
    cell.textLabel.text = object.title;
    [cell.textLabel sizeToFit];
	cell.detailTextLabel.text = object.metier;
    [cell.detailTextLabel sizeToFit];
    [cell.imageView setImageWithURL:[NSURL URLWithString:object.logo] placeholderImage:cell.imageView.image];
    
    // TODO: do not call it every time / static flag ?
    [[cell.imageView layer] setCornerRadius:4.0f];
    
    CLLocationDistance distance = [object.location distanceFromLocation:self.locationManager.location];
    cell.distLabel.text = [NSString stringWithFormat:@"~%.2fkm", distance / 1000];
    [cell.distLabel sizeToFit];

    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.dataSource.places removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"placeViewDetails" isEqualToString:segue.identifier]) {
        NSIndexPath *index = [self.tableView indexPathForCell:sender];
        FFPlaceModel *place = [self.dataSource.places objectAtIndex:index.row];
        [[segue destinationViewController] setPlace:place];
    }
}

- (IBAction)selectMap:(UISegmentedControl*)sender {
    NSLog(@"selected segment %d", sender.selectedSegmentIndex);
    if (sender.selectedSegmentIndex == 1) {
//        [self->_deletedRows addObject:[NSNumber numberWithInt:2]];
//        [self->_deletedRows addObject:[NSNumber numberWithInt:4]];
        
        NSArray *paths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0], [NSIndexPath indexPathForRow:4 inSection:0], nil];

        [self.myTableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
    }
}

#pragma Location events

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"New location %@", newLocation);
    [[FFDownloadManager sharedInstance] requestPlacesDataWithCategory:self.category andCoordinates:newLocation.coordinate];
}

-(void)notificationHandler:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kFFDownloadManagerNotificationPlacesData]) {
        NSLog(@"%@:%@", notification.name, notification.object);
        self.dataSource = [[FFPlacesListModel alloc] initWithObject:notification.object];
        [self.myTableView reloadData];
    }
}


@end
