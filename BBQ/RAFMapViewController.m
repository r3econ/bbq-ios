
#import "RAFMapViewController.h"
#import "RAFDetailViewController.h"


@interface RAFMapViewController () <MKMapViewDelegate>
@property(nonatomic, weak) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end


@implementation RAFMapViewController


#pragma mark - Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"map_view_title", nil);
    
    self.navigationController.tabBarItem.image = [UIImage imageNamed:@"map_unselected"];
    self.navigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"map_selected"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    [self configureAnnotations];
}


- (void)configureAnnotations
{
    [_mapView removeAnnotations:self.mapView.annotations];
    [_mapView addAnnotations:[self.fetchedResultsController fetchedObjects]];

    [_mapView showAnnotations:_mapView.annotations animated:YES];
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
            annotationView.image = [UIImage imageNamed:@"pin"];
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
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


@end