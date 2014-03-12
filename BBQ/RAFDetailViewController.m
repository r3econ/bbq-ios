#import "RAFDetailViewController.h"

@interface RAFDetailViewController ()
@property(nonatomic, strong) Placemark *placemark;
@property(nonatomic, weak) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) UILabel *descriptionLabel;
@property(nonatomic, strong) UILabel *publicTransportationLabel;
@property(nonatomic, strong) UIView *contentView;
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
    
    [self configureContentView];
    
    [_mapView addAnnotation:_placemark];
    [_mapView showAnnotations:_mapView.annotations animated:YES];
}


- (void)configureContentView
{
    CGFloat margin = 20.0f;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), 0.5f);
    topBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [contentView.layer addSublayer:topBorder];
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    descriptionLabel.text = _placemark.placeDescription;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.bounds) - 2 * margin;
    descriptionLabel.font = [UIFont systemFontOfSize:13.0f];
    
    UILabel *publicTransportationLabel = [[UILabel alloc] init];
    publicTransportationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    publicTransportationLabel.text = [NSString stringWithFormat:@"Verkehrsanbindung: %@", _placemark.publicTransportation];
    publicTransportationLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.bounds) - 2 * margin;
    publicTransportationLabel.numberOfLines = 0;
    publicTransportationLabel.font = [UIFont systemFontOfSize:12.0f];

    [contentView addSubview:descriptionLabel];
    [contentView addSubview:publicTransportationLabel];
    [self.view addSubview:contentView];
    
    // Constraints
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0f
                                                           constant:0.0f]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:descriptionLabel
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:-margin]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:descriptionLabel
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1.0f
                                                             constant:0.0f]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:descriptionLabel
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1.0f
                                                             constant:-2 * margin]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:descriptionLabel
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:publicTransportationLabel
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0f
                                                             constant:-margin]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:publicTransportationLabel
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1.0f
                                                             constant:0.0f]];
  
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:publicTransportationLabel
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1.0f
                                                             constant:-2 * margin]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:publicTransportationLabel
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0f
                                                             constant:-margin]];
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