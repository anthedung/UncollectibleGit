//
//  ACPersonDetailRecordsViewController.m
//  Uncollectible
//
//  Created by Ashley Corleone on 29/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.

#import "ACPersonDetailRecordsViewController.h"
#import "ACEditRecordViewController.h"

@interface ACPersonDetailRecordsViewController ()

@end

@implementation ACPersonDetailRecordsViewController

// SEGUE:
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailedView2NewUncollectible"]) {
        ACAddNewPersonRecord2ViewController *secondVC =
        (ACAddNewPersonRecord2ViewController *) segue.destinationViewController;
        [secondVC setDelegateDetailedView:self];
        [secondVC setDelegate:self.debtLoanViewController];
        [secondVC setCurrentPerson:self.currentCellPerson];
    } else if([segue.identifier isEqualToString:@"detailRecord2EditDetailRecord"]) {
        ACEditRecordViewController *secondVC =
        (ACEditRecordViewController *) segue.destinationViewController;
        [secondVC setDelegateDebtLoanViewController:self.debtLoanViewController];
        [secondVC setDelegate:self];
        [secondVC setCurrentCellPerson:self.currentCellPerson];
        
        // SELECTED CELL:
        // Assume self.view is the table view
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        ACDebtRecord *tempDebtRecord = [[self.currentCellPerson debtRecords] objectAtIndex:[path row]];
        [secondVC setCurrentCellDebtRecord:tempDebtRecord];
    }
}

- (void)controller:(ACAddNewPersonRecord2ViewController *)controller didSaveRecord:(id)aRecord {
    // Add Row to Table View
    //NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([[acPerson debtRecords] count] - 1) inSection:0];
    // IF ADD THEN EXTRA ROW, ADD AND REFRESHED ALREADY
    //ACDebtRecord *debtRecord = (ACDebtRecord *) aRecord;
    //[self.currentCellPerson addDebtRecord:debtRecord];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:YES];
    [self.tableView reloadData];
}

- (void) controller:(ACAddNewPersonRecord2ViewController *)controller didUpdateRecord:(ACPerson *)aRecord
{
    
}

- (void)controller:(ACEditRecordViewController *)controller didUpdateSingleDebtRecord:(id)aRecord{
    [self.tableView reloadData];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // SET BACKGROUN IMAGE
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yellowish.png"]];
    //NSLog(@"AC - DetailedView Person Name: %@", self.currentCellPerson.name);
    
    self.title = self.currentCellPerson.name;
    
    [self.navigationItem.backBarButtonItem setTitle:@"Back"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ACPERSON

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.currentCellPerson debtRecords] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    ACPersonDetailedRecordCell *cell = (ACPersonDetailedRecordCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[ACPersonDetailedRecordCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell... order by latest first
    //    ACDebtRecord *debtRecord = [[self.currentCellPerson debtRecords] objectAtIndex:[indexPath row]];
    
    // InsertNewDebt on top everytime => just loop normally
    ACDebtRecord *debtRecord = [[self.currentCellPerson debtRecords] objectAtIndex:[indexPath row]];
    
    
    if (debtRecord.debtAmount >= 0) {
        [cell.debtAmount setText:[NSString stringWithFormat:@"$%.02f", debtRecord.debtAmount]];
        [cell.ownMe setText:[NSString stringWithFormat:@"owes me.."]];
        cell.debtAmount.textColor = [ACUtility GetDebtColor];
    } else {
        [cell.debtAmount setText:[NSString stringWithFormat:@"$%.02f", -debtRecord.debtAmount]];
        [cell.ownMe setText:[NSString stringWithFormat:@"I owe.."]];
        cell.debtAmount.textColor = [ACUtility GetLoanColor];
    }
    
    // COLLECTED OR UNCOLLECTIBLE
    
    if (debtRecord.isCollected){
        cell.debtAmount.textColor = [ACUtility GetCollectedColor];
        if (debtRecord.debtAmount >= 0) {
            [cell.ownMe setText:[NSString stringWithFormat:@"I paid.."]];
        } else {
            [cell.ownMe setText:[NSString stringWithFormat:@"Paid me.."]];
        }
    }
    
    if (debtRecord.isUncollectible){
        cell.debtAmount.textColor = [ACUtility GetUncollectibleColor];
        if (debtRecord.debtAmount < 0) {
            [cell.ownMe setText:[NSString stringWithFormat:@"Lost.."]];
        } else {
            [cell.ownMe setText:[NSString stringWithFormat:@"Earned.."]];
        }
    }
    
    // Uncollectible Color
    if (debtRecord.isUncollectible){
        cell.debtAmount.textColor = [ACUtility GetUncollectibleColor];
    }
    
    // DATE FORMATTER
    NSString *formattedDate = [ACUtility FormatDate:debtRecord.dateCreated];
    [cell.dateUpdated setText:[NSString stringWithFormat:@"%@", formattedDate]];
    
    // FIND NO OF DAYS DIFFERENCE BETWEEN TODAY AND CREATED
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:[debtRecord dateCreated]
                                                          toDate:[NSDate date]
                                                         options:1];
    // using hours to roundUp
    int noOfDays = [components day];
    //    int noOfHours = [components hour];
    //    int noOfDaysRounded = floorf(noOfHours/24) + 1; // Round down then + 1
    
    
    if(noOfDays == 0){
        cell.noOfDaysPassed.text = @"Today";
    } else if(noOfDays == 1) {
        cell.noOfDaysPassed.text = @"Yesterday";
    }else {
        cell.noOfDaysPassed.text = [NSString stringWithFormat:@"%d Days", noOfDays];
    }
    
    if (![debtRecord.debtNote isEqualToString:@""]) {
        cell.debtNote.text = debtRecord.debtNote;
    } else {
        cell.debtNote.text = @"~";
    }
    
//    // UNCOLLECTIBLE DEBT NOTE
//    if (debtRecord.isUncollectible && [debtRecord.debtNote isEqualToString:@""]){
//        cell.debtNote.text = [NSString stringWithFormat:@"*Uncollectible"];
//    } else if (debtRecord.isUncollectible){
//        cell.debtNote.text = [NSString stringWithFormat:@"%@ *Uncollectible", cell.debtNote.text];
//    }
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        // DELETE IF MORE THAN 1, OTHERWISE REMOVE TOTALLY
        if ([self.currentCellPerson.debtRecords count] > 1 ) {
            [self.currentCellPerson.debtRecords removeObjectAtIndex:[indexPath row]];
            [self.currentCellPerson reCalculateDebtAmount]; // Recalculate debtAmount to update views
            [self.currentCellPerson setLastUpdatedDate:[NSDate date]];
            [ACDebtManager SavePersonLists];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.debtLoanViewController.tableView reloadData];
            // Scroll to TOP
            [self scrollToTop];
        } else {
            NSMutableArray *tempArray = [ACDebtManager personList];
            
            for (int i = 0 ; i < [tempArray count]; i++){
                if (self.currentCellPerson.personID == [[tempArray objectAtIndex:i] personID]){
                    [tempArray removeObjectAtIndex:i];
                    [ACDebtManager SavePersonLists:tempArray];
                    
                    // POP VIEW
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.debtLoanViewController.tableView reloadData];
                    // Scroll to TOP
                    [self scrollToTop];
                    break;
                }
            }
        }
    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }
}

- (void) scrollToTop{
    if ([ACDebtManager TotalNumberPersonRecord] > 0){
        NSIndexPath* ipath = [NSIndexPath indexPathForRow: 0 inSection: 0];
        [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    //NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    //    NSLog(@"AC - At Detailed View %@ - path row: %d", indexPath, [indexPath row]);
}

@end
