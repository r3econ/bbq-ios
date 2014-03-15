#import "RAFDetailViewController.h"

#define kEnterMapFullscreenImage [IMAGE_NAMED(@"expand_arrows") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
#define kExitMapFullscreenImage [IMAGE_NAMED(@"collapse_arrows") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]


@interface RAFDetailViewController ()<MKMapViewDelegate>
@property(nonatomic, strong) Placemark *placemark;
@property(nonatomic, strong) MKMapView *mapView;
@property(nonatomic, strong) UILabel *descriptionLabel;
@property(nonatomic, strong) UILabel *publicTransportationLabel;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) NSLayoutConstraint *contentViewBottomConstraint;
@property(nonatomic, strong) UIButton *toggleMapFullscreenButton;
@property(nonatomic, assign) BOOL isMapFullscreen;

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
    
    _contentView = [[UIView alloc] init];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView.backgroundColor = [RAFAppearance secondaryViewColor];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), 0.5f);
    topBorder.backgroundColor = [RAFAppearance accessoryViewColor].CGColor;
    [_contentView.layer addSublayer:topBorder];
    
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
    
    [_contentView addSubview:descriptionLabel];
    [_contentView addSubview:publicTransportationLabel];
    [self.view addSubview:_contentView];
    
    _toggleMapFullscreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _toggleMapFullscreenButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_toggleMapFullscreenButton setImage:kEnterMapFullscreenImage forState:UIControlStateNormal];
    [_toggleMapFullscreenButton addTarget:self
                                   action:@selector(toggleMapFullScreenButtonTapped:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_toggleMapFullscreenButton];
    
    // Constraints
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    // Keep a reference to the bottom constant to animate it later.
    _contentViewBottomConstraint = [NSLayoutConstraint constraintWithItem:_contentView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f
                                                                 constant:0.0f];
    [self.view addConstraint:_contentViewBottomConstraint];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:descriptionLabel
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:-margin]];
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:descriptionLabel
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_contentView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1.0f
                                                             constant:0.0f]];
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:descriptionLabel
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_contentView
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1.0f
                                                             constant:-2 * margin]];
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:descriptionLabel
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:publicTransportationLabel
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0f
                                                             constant:-margin]];
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:publicTransportationLabel
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_contentView
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1.0f
                                                             constant:0.0f]];
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:publicTransportationLabel
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_contentView
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1.0f
                                                             constant:-2 * margin]];
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:publicTransportationLabel
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_contentView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0f
                                                             constant:-margin]];
    
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_contentView
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
    
    // Toggle map fullscreen button
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_toggleMapFullscreenButton
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_contentView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:-2.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_toggleMapFullscreenButton
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0f
                                                           constant:-2.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_toggleMapFullscreenButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:40.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_toggleMapFullscreenButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:40.0f]];
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


- (IBAction)toggleMapFullScreenButtonTapped:(id)sender
{
    [_toggleMapFullscreenButton setImage:_isMapFullscreen ? kEnterMapFullscreenImage : kExitMapFullscreenImage
                                forState:UIControlStateNormal];
    [self toggleMapFullscreen];
}


#pragma mark - Map fullscreen animations


- (void)toggleMapFullscreen
{
    if (_isMapFullscreen == NO)
    {
        [self enterMapFullscreen];
    }
    else
    {
        [self exitMapFullscreen];
    }
}


- (void)enterMapFullscreen
{
    _toggleMapFullscreenButton.userInteractionEnabled = NO;
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.2f
                     animations:^
     {
         _contentViewBottomConstraint.constant = CGRectGetHeight(_contentView.bounds);
         [self.view layoutIfNeeded];
     }
                     completion:^(BOOL finished)
     {
         _isMapFullscreen = YES;
         _toggleMapFullscreenButton.userInteractionEnabled = YES;
     }];
}


- (void)exitMapFullscreen
{
    _toggleMapFullscreenButton.userInteractionEnabled = NO;
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.2f
                     animations:^
     {
         _contentViewBottomConstraint.constant = 0;
         [self.view layoutIfNeeded];
     }
                     completion:^(BOOL finished)
     {
         _isMapFullscreen = NO;
         _toggleMapFullscreenButton.userInteractionEnabled = YES;
     }];
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