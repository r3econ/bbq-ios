
#import "RAFMapViewController.h"
#import "RAFDetailViewController.h"


@interface RAFMapViewController () <MKMapViewDelegate>
@property(nonatomic, weak) IBOutlet MKMapView *mapView;
@property(nonatomic, weak) IBOutlet UIButton *showUserLocationButton;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, assign) BOOL shouldZoomToUserLocation;
@end


@implementation RAFMapViewController


#pragma mark - Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"map_view_title", nil);
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    [self configureAnnotations];
    
    _showUserLocationButton.tintColor = [RAFAppearance accessoryViewColor];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[RAFTracking sharedInstance] trackPageView:@"MapView"];
}


- (void)configureAnnotations
{
    if ([[RAFLocationManager sharedInstance] locationServicesAllowed])
    {
        _mapView.showsUserLocation = YES;
    }
    
    [_mapView addAnnotations:[self.fetchedResultsController fetchedObjects]];

    [_mapView showAnnotations:_mapView.annotations animated:YES];
}


- (void)zoomToUserLocationOnFirstUpdate
{
    if (_shouldZoomToUserLocation)
    {
        _shouldZoomToUserLocation = NO;
        
        if (_mapView.userLocation)
        {
            [_mapView showAnnotations:@[_mapView.userLocation] animated:YES];
        }
    }
}


#pragma mark - NSFetchedResultsController


/*
 Returns the fetched results controller.
 Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    // Create and configure a fetch request with the Book entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Placemark"
                                              inManagedObjectContext:[RAFAppDelegate managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    
    [fetchRequest setSortDescriptors:@[nameDescriptor]];
    
    // Create and initialize the fetch results controller.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:[RAFAppDelegate managedObjectContext]
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    
    [_fetchedResultsController performFetch:nil];
    
    return _fetchedResultsController;
}


#pragma mark - Actions



- (IBAction)centerAtUserLocationButtonTapped:(id)sender
{
    _mapView.showsUserLocation = YES;
    
    if ([RAFLocationManager sharedInstance].currentLocation)
    {
        [_mapView showAnnotations:@[_mapView.userLocation] animated:YES];
    }
    else
    {
        _shouldZoomToUserLocation = YES;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(zoomToUserLocationOnFirstUpdate)
                                                     name:RAFLocationDidChangeNotification
                                                   object:nil];
        
        [[RAFLocationManager sharedInstance] startLocating];
    }
    
}


#pragma mark - MKMapViewDelegate


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation
{
    if ([annotation isKindOfClass:[Placemark class]])
    {
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
        
        if (!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
            annotationView.canShowCallout = YES;
            annotationView.image = [[UIImage imageNamed:@"pin"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.tintColor = [RAFAppearance defaultTextColor];
        }
        
        annotationView.annotation = annotation;
        
        return annotationView;
    }
    
    return nil;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    Placemark *placemark = (Placemark *)view.annotation;
    
    RAFDetailViewController *vc = [RAFDetailViewController controllerWithPlacemark:placemark];
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc
                                         animated:YES];
}


#pragma mark - Appearance


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [RAFAppearance preferredStatusBarStyle];
}


@end