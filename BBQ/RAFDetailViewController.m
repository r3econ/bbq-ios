#import "RAFDetailViewController.h"

@interface RAFDetailViewController ()<MKMapViewDelegate>
@property(nonatomic, strong) Placemark *placemark;
@property(nonatomic, strong) MKMapView *mapView;
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
    self.edgesForExtendedLayout = UIRectEdgeNone;

    _mapView = [[MKMapView alloc] init];
    [_mapView addAnnotation:_placemark];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    [self configureNavigationBar];
    
    [self configureViews];
}


- (void)viewDidLayoutSubviews
{
    [_mapView showAnnotations:_mapView.annotations animated:YES];
}


- (NSAttributedString *)placeDescriptionString
{
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSMutableAttributedString *placeDescription = [[NSMutableAttributedString alloc] initWithString:_placemark.placeDescription];
    
    [placeDescription addAttributes:@{
                                      NSForegroundColorAttributeName : [RAFAppearance defaultTextColor],
                                      NSFontAttributeName : [RAFAppearance defaultFontOfSize:13.0f],
                                      NSParagraphStyleAttributeName: paragraphStyle,
                                      NSBaselineOffsetAttributeName: [NSNumber numberWithFloat:0]
                                      }
                              range:NSMakeRange(0, [placeDescription length])];
    
    if (_placemark.activities)
    {
        NSMutableAttributedString *activitiesString = [[NSMutableAttributedString alloc] initWithString:_placemark.activities];
        
        [activitiesString addAttributes:@{
                                          NSForegroundColorAttributeName : [RAFAppearance defaultTextColor],
                                          NSFontAttributeName : [RAFAppearance defaultFontOfSize:13.0f],
                                          NSParagraphStyleAttributeName: paragraphStyle,
                                          NSBaselineOffsetAttributeName: [NSNumber numberWithFloat:0]
                                          }
                                  range:NSMakeRange(0, [activitiesString length])];
        
        [placeDescription appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
        [placeDescription appendAttributedString:activitiesString];
    }
    
    return placeDescription;
}


- (void)configureViews
{
    CGFloat margin = 15.0f;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [RAFAppearance secondaryViewColor];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), 0.5f);
    topBorder.backgroundColor = [RAFAppearance accessoryViewColor].CGColor;
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
    publicTransportationLabel.font = [RAFAppearance defaultFontOfSize:12.0f];
    publicTransportationLabel.textColor = [RAFAppearance accessoryTextColor];
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
    
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:contentView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:0.0f]];
     
    
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
     attribute:NSLayoutAttributeTop
     relatedBy:NSLayoutRelationEqual
     toItem:self.view
     attribute:NSLayoutAttributeTop
     multiplier:1.0f
     constant:0.0f]];
     
     
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
     attribute:NSLayoutAttributeWidth
     relatedBy:NSLayoutRelationEqual
     toItem:self.view
     attribute:NSLayoutAttributeWidth
     multiplier:1.0f
     constant:0.0f]];
     
     
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
     attribute:NSLayoutAttributeLeading
     relatedBy:NSLayoutRelationEqual
     toItem:self.view
     attribute:NSLayoutAttributeLeading
     multiplier:1.0f
     constant:0.0f]];
     
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