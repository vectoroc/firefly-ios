//
//  MKMapView+ZoomToFitAnnotations.h
//  firefly
//
//  Created by Victor Grigoriev on 9/2/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomToFitAnnotations)
- (void)zoomToFitMapAnnotations;
- (void)zoomToFitMapAnnotations:(BOOL)inclueUserLocation;
@end
