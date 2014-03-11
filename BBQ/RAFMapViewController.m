
#import "RAFMapViewController.h"

@interface RAFMapViewController ()
@property(nonatomic, weak) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end


@implementation RAFMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}


- (NSArray *)getPlacemarks
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Set entity to be queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Placemark"
                                              inManagedObjectContext:[RAFAppDelegate managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext with generated fetch request.
    NSArray *fetchedRecords = [[RAFAppDelegate managedObjectContext] executeFetchRequest:fetchRequest
                                                                                   error:&error];
    
    // Return fetched records.
    return fetchedRecords;
}


- (IBAction)centerAtUserLocationButtonTapped:(id)sender
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
