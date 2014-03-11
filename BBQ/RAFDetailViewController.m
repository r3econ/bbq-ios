#import "RAFDetailViewController.h"

@interface RAFDetailViewController ()
@property(nonatomic, strong) Placemark *placemark;
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
}


- (void)configureNavigationBar
{
    self.title = _placemark.name;
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                               target:self
                                                                               action:@selector(shareButtonTapped:)];
    self.navigationItem.rightBarButtonItem = shareItem;
}


- (void)shareButtonTapped:(id)sender
{
    NSArray * activityItems = @[[NSString stringWithFormat:@"Some initial text."]];
    NSArray * applicationActivities = nil;
    NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint];
    
    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
    activityController.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityController animated:YES completion:nil];
}


@end