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

#import "RAFDetailViewController.h"

@interface RAFDetailViewController ()<MKMapViewDelegate>

@property(nonatomic, strong) Placemark *placemark;
@property(nonatomic, strong) MKMapView *mapView;
@property(nonatomic, strong) UILabel *descriptionLabel;
@property(nonatomic, strong) UILabel *activitiesLabel;
@property(nonatomic, strong) UILabel *publicTransportationLabel;
@property(nonatomic, strong) UIImageView *infoImageView;
@property(nonatomic, strong) UIImageView *activitiesImageView;
@property(nonatomic, strong) UIImageView *transportationImageView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) NSLayoutConstraint *contentViewBottomConstraint;
@property(nonatomic, strong) UIButton *toggleMapFullscreenButton;
@property(nonatomic, strong) UIButton *showUserLocationButton;
@property(nonatomic, assign) BOOL shouldZoomToUserLocation;
@property(nonatomic, assign) BOOL isMapFullscreen;

@end


@implementation RAFDetailViewController

#pragma mark - Lifecycle

+ (RAFDetailViewController *)controllerWithPlacemark:(Placemark *)placemark {
    RAFDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RAFDetailViewController"];
    
    vc.placemark = placemark;
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configureMapView];
    [self configureNavigationBar];
    
    [self configureViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[RAFTracking sharedInstance] trackPageView:@"PlaceDetailsView"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {
    [_mapView showAnnotations:@[_placemark] animated:YES];
}

- (void)zoomToUserLocationOnFirstUpdate {
    if (_shouldZoomToUserLocation) {
        _shouldZoomToUserLocation = NO;
        
        if (_mapView.userLocation) {
            [_mapView showAnnotations:@[_mapView.userLocation] animated:YES];
        }
    }
}

#pragma mark - Strings

- (NSAttributedString *)placeDescriptionString {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_placemark.placeDescription];
    
    [string addAttributes:@{
                            NSForegroundColorAttributeName : [RAFAppearance defaultTextColor],
                            NSFontAttributeName : [RAFAppearance defaultFontOfSize:13.0f],
                            }
                    range:NSMakeRange(0, [string length])];
    
    return string;
}

- (NSAttributedString *)activitiesString {
    NSMutableAttributedString *string = nil;
    
    if (_placemark.activities) {
        string = [[NSMutableAttributedString alloc] initWithString:_placemark.activities];
        
        [string addAttributes:@{
                                NSForegroundColorAttributeName : [RAFAppearance secondaryTextColor],
                                NSFontAttributeName : [RAFAppearance defaultFontOfSize:13.0f],
                                }
                        range:NSMakeRange(0, [string length])];
    }
    
    return string;
}

- (NSAttributedString *)publicTransportationString {
    NSMutableAttributedString *string = nil;
    
    if (_placemark.publicTransportation) {
        string = [[NSMutableAttributedString alloc] initWithString:_placemark.publicTransportation];
        
        [string addAttributes:@{
                                NSForegroundColorAttributeName : [RAFAppearance secondaryTextColor],
                                NSFontAttributeName : [RAFAppearance defaultFontOfSize:13.0f],
                                }
                        range:NSMakeRange(0, [string length])];
    }
    
    return string;
}

#pragma mark - Configuration

- (void)configureMapView {
    _mapView = [[MKMapView alloc] init];
    _mapView.delegate = self;
    _mapView.showsCompass = true;
    _mapView.showsScale = true;
    [_mapView addAnnotation:_placemark];

    if ([[RAFLocationManager sharedInstance] locationServicesAllowed]) {
        _mapView.showsUserLocation = YES;
    }
    
    [self.view addSubview:_mapView];
}

- (void)configureViews {
    // Configure content view.
    _contentView = [[UIView alloc] init];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView.backgroundColor = [RAFAppearance secondaryViewColor];
    
    // Add border to the view.
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), 0.5f);
    topBorder.backgroundColor = [UIColor grayColor].CGColor;
    [_contentView.layer addSublayer:topBorder];


    // Configure label with place description.
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.attributedText = [self placeDescriptionString];
    
    // Configure label with activities.
    _activitiesLabel = [[UILabel alloc] init];
    _activitiesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _activitiesLabel.numberOfLines = 0;
    _activitiesLabel.attributedText = [self activitiesString];
    
    // Configure label with transportation info.
    _publicTransportationLabel = [[UILabel alloc] init];
    _publicTransportationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _publicTransportationLabel.numberOfLines = 0;
    _publicTransportationLabel.attributedText = [self publicTransportationString];
    
    // Add labels to the view.
    [_contentView addSubview:_descriptionLabel];
    [_contentView addSubview:_activitiesLabel];
    [_contentView addSubview:_publicTransportationLabel];
    
    // Configure image views.
    _infoImageView = [[UIImageView  alloc] initWithImage:[IMAGE_NAMED(@"info_icon") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    _activitiesImageView = [[UIImageView  alloc] initWithImage:[IMAGE_NAMED(@"runner_icon") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    _transportationImageView = [[UIImageView  alloc] initWithImage:[IMAGE_NAMED(@"bus_icon") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    _infoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _activitiesImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _transportationImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Add image views to the view.
    [_contentView addSubview:_infoImageView];
    [_contentView addSubview:_activitiesImageView];
    [_contentView addSubview:_transportationImageView];
    
    // Add content view to the main view.
    [self.view addSubview:_contentView];
    
    // Configure button for switching to fullscreen mode.
    _toggleMapFullscreenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _toggleMapFullscreenButton.tintColor = [RAFAppearance secondaryViewColor];
    _toggleMapFullscreenButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_toggleMapFullscreenButton setImage:IMAGE_NAMED(@"expand_arrows") forState:UIControlStateNormal];
    [_toggleMapFullscreenButton addTarget:self
                                   action:@selector(toggleMapFullScreenButtonTapped:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_toggleMapFullscreenButton];
    
    // Configure button for showing user location.
    _showUserLocationButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _showUserLocationButton.tintColor = [RAFAppearance secondaryViewColor];
    _showUserLocationButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_showUserLocationButton setImage:IMAGE_NAMED(@"user_location") forState:UIControlStateNormal];
    [_showUserLocationButton addTarget:self
                                action:@selector(centerAtUserLocationButtonTapped:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_showUserLocationButton];
    
    // Set up constraints
    [self configureConstraints];
}

- (void)configureConstraints {
    CGFloat verticalMargin = 15.0f;
    CGFloat horizontalMargin = 15.0f;
    CGFloat horizontalPadding = 10.0f;
    CGFloat verticalPadding = 10.0f;
    
    _descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.bounds) - 40 - 2 * horizontalMargin;
    _publicTransportationLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.bounds) - 40 - 2 * horizontalMargin;
    _activitiesLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.bounds) - 40 - 2 * horizontalMargin;
    
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
    
    // Content view leading.
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    // Content view top based on its contents.
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_descriptionLabel
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:-verticalMargin]];
    
    // Info image view leading.
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_infoImageView
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1.0f
                                                              constant:horizontalMargin]];

    // Info image view center Y based on description label center Y.
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_infoImageView
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_descriptionLabel
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0f
                                                              constant:0.0f]];
    
    // Keep info button original size.
    [_infoImageView setContentHuggingPriority:UILayoutPriorityRequired
                                      forAxis:UILayoutConstraintAxisHorizontal];
    
    // Description label leading with a padding.
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_infoImageView
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0f
                                                              constant:horizontalPadding]];
    
    // Description label trailing.
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0f
                                                              constant:-horizontalMargin]];
    
    // Description label bottom on top of the activities label.
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_activitiesLabel
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0f
                                                              constant:-verticalPadding]];
    
    // Activities image view leading.
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_activitiesImageView
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1.0f
                                                              constant:horizontalMargin]];
    
    // Activities image view center Y based on activities label center Y.
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_activitiesImageView
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_activitiesLabel
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0f
                                                              constant:0.0f]];
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_activitiesLabel
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_activitiesImageView
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0f
                                                              constant:horizontalPadding]];
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_activitiesLabel
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0f
                                                              constant:-horizontalMargin]];
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_activitiesLabel
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_publicTransportationLabel
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0f
                                                              constant:-verticalPadding]];
    
    // Transportation image view leading.
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_transportationImageView
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1.0f
                                                              constant:horizontalMargin]];
    
    // Transportation image view center Y based on transportation label center Y.
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_transportationImageView
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_publicTransportationLabel
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0f
                                                              constant:0.0f]];
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_publicTransportationLabel
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_transportationImageView
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0f
                                                              constant:horizontalPadding]];
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_publicTransportationLabel
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0f
                                                              constant:-horizontalMargin]];
    
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_publicTransportationLabel
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0f
                                                              constant:-verticalMargin]];
    
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
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_showUserLocationButton
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_contentView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:-2.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_showUserLocationButton
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0f
                                                           constant:-2.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_showUserLocationButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:40.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_showUserLocationButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:40.0f]];
    
    // Show user location button
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_toggleMapFullscreenButton
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:-2.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_toggleMapFullscreenButton
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0f
                                                           constant:2.0f]];
    
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

- (void)configureNavigationBar {
    self.title = _placemark.name;
    self.navigationItem.prompt = _placemark.district;
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                               target:self
                                                                               action:@selector(shareButtonTapped:)];
    
    self.navigationItem.rightBarButtonItem = shareItem;
}

#pragma mark - Actions

- (void)shareButtonTapped:(id)sender {
    NSArray * activityItems = @[[NSString stringWithFormat:@"%@, %@.\n\n%@",
                                 _placemark.name,
                                 _placemark.district,
                                 _placemark.publicTransportation]];
    
    NSArray * applicationActivities = nil;
    NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint];
    
    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
    activityController.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityController animated:YES completion:nil];
}

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

- (IBAction)toggleMapFullScreenButtonTapped:(id)sender {
    [_toggleMapFullscreenButton setImage:_isMapFullscreen ? IMAGE_NAMED(@"expand_arrows") : IMAGE_NAMED(@"collapse_arrows")
                                forState:UIControlStateNormal];
    [self toggleMapFullscreen];
}

#pragma mark - Map fullscreen animations

- (void)toggleMapFullscreen {
    if (_isMapFullscreen == NO)
    {
        [self enterMapFullscreen];
    }
    else
    {
        [self exitMapFullscreen];
    }
}

- (void)enterMapFullscreen {
    _toggleMapFullscreenButton.userInteractionEnabled = NO;
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.4f
                     animations:^{
                         _contentViewBottomConstraint.constant = CGRectGetHeight(_contentView.bounds);
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         _isMapFullscreen = YES;
                         _toggleMapFullscreenButton.userInteractionEnabled = YES;
                     }];
}

- (void)exitMapFullscreen {
    _toggleMapFullscreenButton.userInteractionEnabled = NO;
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         _contentViewBottomConstraint.constant = 0;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         _isMapFullscreen = NO;
                         _toggleMapFullscreenButton.userInteractionEnabled = YES;
                     }];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation {
    if ([annotation isKindOfClass:[Placemark class]]) {
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
        
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"pin"];
        }
        
        annotationView.annotation = annotation;
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - Appearance

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [RAFAppearance preferredStatusBarStyle];
}

@end

