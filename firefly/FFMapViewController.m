//
//  FFMapViewController.m
//  firefly
//
//  Created by Victor Grigoriev on 9/1/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import "FFMapViewController.h"
#import "MKMapView+ZoomToFitAnnotations.h"
#import "Libraries/AFNetworking/AFNetworking.h"
#import "Libraries/AFNetworking/UIImageView+AFNetworking.h"


@interface FFMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation FFMapViewController
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.selectedIndex) {
        [self.mapView addAnnotation:[self.places objectAtIndex:self.selectedIndex]];
    }
    else {
        [self.places enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.mapView addAnnotation:obj];
        }];
    }
}

- (void)viewDidUnload
{
    [self setPlaces:nil];
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mapView zoomToFitMapAnnotations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString* identifier = @"Place";
    if ([annotation isKindOfClass:[FFPlaceModel class]]) {
        MKAnnotationView* view = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!view) {
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            UIButton *annotationButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            view.rightCalloutAccessoryView = annotationButton;
        }
        view.canShowCallout = YES;
        return view;
    } else {
        return nil;
    }
    
}

//- (void)annotationTouchedUp:(UIButton*)sender
//{
//    [self performSegueWithIdentifier:@"placeViewDetails" sender:self];
//    NSLog(@"annotationTouchedUp: %@", sender);
//}
//
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FFPlaceViewController *viewController = (id)[segue destinationViewController];
    viewController.place = [self.places objectAtIndex:self.selectedIndex];
    NSLog(@"segue %@, dest view: %@, place: %@", segue.identifier, viewController, viewController.place);
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{    
    self.selectedIndex = [self.places indexOfObject:view.annotation];
    [self performSegueWithIdentifier:@"placeViewDetails" sender:self];
    NSLog(@"annotationTouchedUp: %d", self.selectedIndex);
}

@end
