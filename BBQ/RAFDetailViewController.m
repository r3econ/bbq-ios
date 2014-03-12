#import "RAFDetailViewController.h"

@interface RAFDetailViewController ()
@property(nonatomic, strong) Placemark *placemark;
@property(nonatomic, weak) IBOutlet MKMapView *mapView;
@property(nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property(nonatomic, weak) IBOutlet UILabel *publicTransportationLabel;
@property(nonatomic, weak) IBOutlet UIView *contentView;
@end


@implementation RAFDetailViewController


+ (RAFDetailViewController *)controllerWithPlacemark:(Placemark *)placemark
{
    RAFDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RAFDetailViewController"];
    
    vc.placemark = placemark;

    return vc;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureNavigationBar];
    
    _descriptionLabel.text = _placemark.placeDescription;
    _publicTransportationLabel.text = _placemark.publicTransportation;
    
    [_mapView addAnnotation:_placemark];
    [_mapView showAnnotations:_mapView.annotations animated:YES];
}


- (void)configureNavigationBar
{
    self.title = _placemark.name;
    self.navigationItem.prompt = _placemark.district;

    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                               target:self
                                                                               action:@selector(shareButtonTapped:)];
    self.navigationItem.rightBarButtonItem = shareItem;
}


#pragma mark - Actions


- (void)shareButtonTapped:(id)sender
{
    NSArray * activityItems = @[[NSString stringWithFormat:@"Some initial text."]];
    NSArray * applicationActivities = nil;
    NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint];
    
    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
    activityController.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityController animated:YES completion:nil];
}


#pragma mark - MKMapViewDelegate


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation
{
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if (!annotationView)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"pin"];
    }
    
    annotationView.annotation = annotation;
    
    return annotationView;
}


@end