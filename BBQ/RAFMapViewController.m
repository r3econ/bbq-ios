//
// Copyright (c) 2014 Rafał Sroka
//
// Licensed under the GNU General Public License, Version 3.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at:
//
//   https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "RAFMapViewController.h"
#import "RAFDetailViewController.h"
#import "RAFDataManager.h"

@interface RAFMapViewController () <MKMapViewDelegate>
@property(nonatomic, weak) IBOutlet MKMapView *mapView;
@property(nonatomic, weak) IBOutlet UIButton *showUserLocationButton;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, assign) BOOL shouldZoomToUserLocation;
@end

@implementation RAFMapViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureNavigationBar];
    [self configureAnnotations];

    _showUserLocationButton.tintColor = [RAFAppearance secondaryViewColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self showInformationAlert];
}

- (void)showInformationAlert {
    if (![[RAFAppDelegate sharedInstance] isFirstLaunch]) {
        return;
    }

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"warning_alert.title", nil)
                                                                   message:NSLocalizedString(@"warning_alert.message", nil)
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"warning_alert.accept_button", nil)
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert
                       animated:NO
                     completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [[RAFTracking sharedInstance] trackPageView:@"MapView"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Configuration

- (void)configureNavigationBar {
    self.title = NSLocalizedString(@"map_view_title", nil);

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];

    self.navigationController.navigationBar.standardAppearance = [RAFAppearance navigationBarAppearance];
    self.navigationController.navigationBar.scrollEdgeAppearance = [RAFAppearance navigationBarAppearance];
}


- (void)configureAnnotations {
    if ([[RAFLocationManager sharedInstance] locationServicesAllowed]) {
        _mapView.showsUserLocation = YES;
    }

    [_mapView addAnnotations:(self.fetchedResultsController).fetchedObjects];

    [_mapView showAnnotations:_mapView.annotations animated:YES];
}

- (void)zoomToUserLocationOnFirstUpdate {
    if (_shouldZoomToUserLocation) {
        _shouldZoomToUserLocation = NO;

        if (_mapView.userLocation) {
            [_mapView showAnnotations:@[_mapView.userLocation] animated:YES];
        }
    }
}

#pragma mark - NSFetchedResultsController

/*
 Returns the fetched results controller.
 Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSManagedObjectContext *context = RAFAppDelegate.sharedInstance.dataManager.viewContext;

    // Create and configure a fetch request with the Book entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Placemark"
                                              inManagedObjectContext:context];
    fetchRequest.entity = entity;

    // Create the sort descriptors array.
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];

    fetchRequest.sortDescriptors = @[nameDescriptor];

    // Create and initialize the fetch results controller.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:context
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];

    [_fetchedResultsController performFetch:nil];

    return _fetchedResultsController;
}

#pragma mark - Actions

- (IBAction)centerAtUserLocationButtonTapped:(id)sender {
    _mapView.showsUserLocation = YES;

    if ([RAFLocationManager sharedInstance].currentLocation) {
        [_mapView showAnnotations:@[_mapView.userLocation] animated:YES];
    }
    else {
        _shouldZoomToUserLocation = YES;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(zoomToUserLocationOnFirstUpdate)
                                                     name:RAFLocationDidChangeNotification
                                                   object:nil];

        [[RAFLocationManager sharedInstance] startLocating];
    }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation {
    if ([annotation isKindOfClass:[Placemark class]]) {
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];

        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
            annotationView.canShowCallout = YES;
            annotationView.image = IMAGE_NAMED(@"Pin");
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.rightCalloutAccessoryView.tintColor = [UIColor blackColor];
        }

        annotationView.annotation = annotation;

        return annotationView;
    }

    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    Placemark *placemark = (Placemark *)view.annotation;

    RAFDetailViewController *vc = [RAFDetailViewController controllerWithPlacemark:placemark];
    vc.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:vc
                                         animated:YES];
}

#pragma mark - Appearance

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [RAFAppearance preferredStatusBarStyle];
}

@end
