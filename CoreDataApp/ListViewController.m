//
//  ListViewController.m
//  CoreDataApp
//
//  Created by Abhishek Desai on 9/11/14.
//  Copyright (c) 2014 Abhishek Desai. All rights reserved.
//

#import "ListViewController.h"
#import "AppDelegate.h"
#import "SimpleTableCell.h"
#import "AddViewController.h"

@interface ListViewController ()

@property (strong, nonatomic) NSMutableArray *assignmentList;

@end

@implementation ListViewController


/*
 * Function for removing the record if the current day is passed
 */
- (void)removeFromManagedObjectContext
{
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Assignmentlist"];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDateTextField" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [request setSortDescriptors:sortDescriptors];

    self.assignmentList = [[managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    
    NSDate *date = [NSDate date];
    
    for (NSManagedObject *managedObject in self.assignmentList) {
        //NSLog(@"display Date %@",[managedObject valueForKey:@"dueDateTextField"]);
        //NSTimeInterval interval = [[managedObject valueForKey:@"dueDateTextField"] timeIntervalSinceDate:date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                   fromDate:date
                                                     toDate:[managedObject valueForKey:@"dueDateTextField"]
                                                    options:0];
        //NSLog(@"interval %i",components.day);
        if(components.day < 0)
        {
            [managedObjectContext deleteObject:managedObject];
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddRecord) ];
    
    self.title = @"List";
    
    // Load the table list with all records
    [self loadList];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self loadList];
    
}

/*
 * Function for loading all the records in the table view
 */
- (void) loadList {
    
    [self removeFromManagedObjectContext];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Assignmentlist"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDateTextField" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.assignmentList = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
    
}

/*
 * Function for navigating to the AddViewController
 */
-(void) AddRecord
{
    AddViewController *addViewController = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:addViewController animated:YES];
    
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.assignmentList count];
}

/*
 * Function for customizing the row for displaying the data.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Single row is displaying from the SimpleTableCell (Custom Table View Cell)
    static NSString *CellIdentifier = @"SimpleTableCell";
    
    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSManagedObject *list = [self.assignmentList objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *formattedDate = [dateFormatter stringFromDate:[list valueForKey:@"dueDateTextField"]];
    
    [cell.dueDateLabel setText:[NSString stringWithFormat:@"%@",formattedDate]];
    [cell.courseLabel setText:[NSString stringWithFormat:@"%@",[list valueForKey:@"courseTextField"]]];
    [cell.assignmentLabel setText:[NSString stringWithFormat:@"%@",[list valueForKey:@"assignmentTextField"]]];
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:[self.assignmentList objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove device from table view
        [self.assignmentList removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
 * Setting custom height for the row
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}



@end
