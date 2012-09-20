//
//  MKMapView+ZoomToFitAnnotations.m
//  firefly
//
//  Created by Victor Grigoriev on 9/2/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import "MKMapView+ZoomToFitAnnotations.h"

@implementation MKMapView (ZoomToFitAnnotations)

- (void)zoomToFitMapAnnotations {
    [self zoomToFitMapAnnotations:NO];
}

- (void)zoomToFitMapAnnotations:(BOOL)includeUserLocation {    
    if ([self.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in self.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    if (self.userLocation && includeUserLocation) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, self.userLocation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, self.userLocation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, self.userLocation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, self.userLocation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [self regionThatFits:region];
    [self setRegion:region animated:YES];
}

@end
