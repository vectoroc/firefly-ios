//
//  FFObjectsListViewController.m
//  firefly
//
//  Created by Victor Grigoriev on 8/25/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import "FFPlacesListViewController.h"
#import "FFPlaceViewController.h"
#import "Libraries/AFNetworking/AFNetworking.h"
#import "Libraries/AFNetworking/UIImageView+AFNetworking.h"

#import <CoreLocation/CoreLocation.h>

@interface FFPlacesListViewController () <FFPlacesListModelDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) CLLocationManager* locationManager;

@end

@implementation FFPlacesListViewController {
    NSMutableArray* _deletedRows;
}

@synthesize myTableView;
@synthesize dataSource;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"List->initWithNibName");
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    NSLog(@"List->initWithCoder");
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.dataSource = [FFPlacesListModel sharedInstance];
    self.dataSource.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setDelegate:self];
    [self.locationManager setPurpose:@"Obtain current location to sort results"];
    [self.locationManager startMonitoringSignificantLocationChanges];
        
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSLog(@"List->viewDidLoad");
    
    self->_deletedRows = [[NSMutableArray alloc] init];
}


- (void)viewDidUnload
{
    [self setDataSource:nil];
    [self setMyTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self->_deletedRows = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"List->viewDidApear");
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"numberOfRowsInSection: %d, deleted: %d", [self.dataSource.places count], [self->_deletedRows count]);
    return [self.dataSource.places count] - [self->_deletedRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"objectListCell"];    
    FFPlaceModel *object = [self.dataSource.places objectAtIndex:indexPath.row];
    
    cell.textLabel.text = object.title;
	cell.detailTextLabel.text = object.metier;
    [cell.imageView setImageWithURL:[NSURL URLWithString:object.logo] placeholderImage:cell.imageView.image];
    
    // TODO: do not call it every time / static flag ?
    [[cell.imageView layer] setCornerRadius:4.0f];

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

-(void)objectsListModeldidDataRecive
{
    CLLocation *location = [self.locationManager location];
    if (location) {
        [self.dataSource sortByLocation:location];
    }
    
    [self.myTableView reloadData];
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];

    NSLog(@"objectsListModeldidDataRecive / rows count: %d", [self.dataSource.places count]);
}

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
        [self->_deletedRows addObject:[NSNumber numberWithInt:2]];
        [self->_deletedRows addObject:[NSNumber numberWithInt:4]];
        
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

}


@end
