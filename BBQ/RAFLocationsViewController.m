#import "RAFLocationsViewController.h"
#import "RAFDetailViewController.h"


@interface RAFLocationsViewController ()<NSFetchedResultsControllerDelegate>

@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end


@implementation RAFLocationsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"locations_view_title", nil);

    self.navigationController.tabBarItem.image = [UIImage imageNamed:@"list_unselected"];
    self.navigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"list_selected"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
	NSError *error;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


- (void)viewWillAppear
{    
    [self.tableView reloadData];
}


#pragma mark - Table view


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                            0.0f,
                                                            CGRectGetWidth(self.tableView.bounds),
                                                            28.0f)];
    
    view.backgroundColor = [RAFAppearance secondaryViewColor];

    // Display the district as a section heading.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,
                                                               0.0f,
                                                               CGRectGetWidth(self.tableView.bounds) - 10.0f,
                                                               28.0f)];
    label.textColor = [RAFAppearance accessoryTextColor];
    label.font = [RAFAppearance defaultFontOfSize:14.0f];
    label.text = [[[self.fetchedResultsController sections] objectAtIndex:section] name]; //uppercaseString];
    
    [view addSubview:label];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28.0f;
}


// Customize the appearance of table view cells.
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell to show the book's title
    Placemark *placemark = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = placemark.name;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"chevron_right"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        imageView.tintColor = [RAFAppearance accessoryViewColor];
        cell.accessoryView = imageView;
        
        cell.textLabel.textColor = [RAFAppearance defaultTextColor];
        cell.textLabel.font = [RAFAppearance defaultFontOfSize:16.0f];
    }
    
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Placemark *placemark = (Placemark *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    RAFDetailViewController *vc = [RAFDetailViewController controllerWithPlacemark:placemark];
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc
                                         animated:YES];
}


#pragma mark - Fetched results controller

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
    NSSortDescriptor *districtDescriptor = [[NSSortDescriptor alloc] initWithKey:@"district"
                                                                       ascending:YES];

    [fetchRequest setSortDescriptors:@[districtDescriptor, nameDescriptor]];
    
    // Create and initialize the fetch results controller.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:[RAFAppDelegate managedObjectContext]
                                                                      sectionNameKeyPath:@"district"
                                                                               cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


#pragma mark - NSFetchedResultsControllerDelegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    
    // The fetch controller has sent all current change notifications.
    // Tell the table view to process all updates.
    [self.tableView endUpdates];
}


#pragma mark - Memory


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end