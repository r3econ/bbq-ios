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


- (NSAttributedString *)placeDescriptionString
{
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSMutableAttributedString *placeDescriptionString = [[NSMutableAttributedString alloc] initWithString:_placemark.placeDescription];
    
    [placeDescriptionString addAttributes:@{
                                            NSForegroundColorAttributeName : [UIColor blackColor],
                                            NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
                                            NSParagraphStyleAttributeName: paragraphStyle,
                                            NSBaselineOffsetAttributeName: [NSNumber numberWithFloat:0]
                                            }
                                    range:NSMakeRange(0, [placeDescriptionString length])];
    
    if (_placemark.activities)
    {
        NSMutableAttributedString *activitiesString = [[NSMutableAttributedString alloc] initWithString:_placemark.activities];
        
        [activitiesString addAttributes:@{
                                          NSForegroundColorAttributeName : [UIColor blackColor],
                                          NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
                                          NSParagraphStyleAttributeName: paragraphStyle,
                                          NSBaselineOffsetAttributeName: [NSNumber numberWithFloat:0]
                                          }
                                  range:NSMakeRange(0, [activitiesString length])];
        
        [placeDescriptionString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
        [placeDescriptionString appendAttributedString:activitiesString];
    }

    return placeDescriptionString;
}


- (void)configureContentView
{
    CGFloat margin = 15.0f;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), 0.5f);
    topBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [contentView.layer addSublayer:topBorder];
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.bounds) - 2 * margin;
    descriptionLabel.attributedText = [self placeDescriptionString];

    UILabel *publicTransportationLabel = [[UILabel alloc] init];
    publicTransportationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    publicTransportationLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.bounds) - 2 * margin;
    publicTransportationLabel.numberOfLines = 0;
    publicTransportationLabel.font = [UIFont systemFontOfSize:12.0f];
    publicTransportationLabel.textColor = [UIColor darkGrayColor];
    publicTransportationLabel.text = _placemark.publicTransportation;

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
    NSArray * activityItems = @[[NSString stringWithFormat:@"%@, %@. %@",
                                 _placemark.name,
                                 _placemark.district,
                                 _placemark.publicTransportation]];
    
    NSArray * applicationActivities = nil;
    NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint];
    
    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
    activityController.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityController animated:YES completion:nil];
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
        }
        
        annotationView.annotation = annotation;
        
        return annotationView;
    }
    
    return nil;
}


@end