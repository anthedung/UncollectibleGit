//
//  ACDebtLoanViewController.m
//  Uncollectible
//
//  Created by Ashley Corleone on 25/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import "ACDebtLoanViewController.h"
#import "ACPerson.h"
#import "ACDebtManager.h"
#import "ACDebtRecord.h"
#import "ACAddNewPersonRecord2ViewController.h"
#import "ACPersonDetailRecordsViewController.h"
#import "ACDebtLoanCell.h"
#import "ACUtility.h"
#import "ACAppSetting.h"
#import "PSMenuItem.h"

static NSString *COLLECTED = @"COLLECTED";
static NSString *UNCOLLECTIBLE = @"UNCOLLECTIBLE";
@interface ACDebtLoanViewController ()
@property NSMutableArray *personLocalLists;
@property UIImageView *backImage;
@end

@implementation ACDebtLoanViewController
NSArray *searchResults;

#pragma - init and viewLoad methods
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.tableView reloadData]; // TO CORRECT THE INCORRECTLY SCROLLED JUST ADDED RECORD => Not Working
    
    self.tableView.scrollEnabled = YES;
    self.personLocalLists = [ACDebtManager personList];
    
    [self scrollToTop];
    
    [self.navigationItem.backBarButtonItem setTitle:@"Back"]; // not working
    
    // SET BACKGROUND
    UIImage *image = [UIImage imageNamed: @"logoUncollectibleWhite6.png"];
    self.backImage = [[UIImageView alloc] initWithImage: image];
    self.backImage.alpha = 0.1;
    [self.view addSubview: self.backImage];
    [self.view sendSubviewToBack: self.backImage];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData]; // ONLY THIS SOLVE THE PROBLEM OF STUPID UITABLEVIEW NOT SCROLLING FAR ENOUGH TO THE BUTTON AND BOUNCE BACK
    
    // THIS IS CRUCIAL TO MAKE UIMENUITEM WORK AFTER SWITCHING TAB
    [self becomeFirstResponder];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // Only Display Logo if no record to avoid emptyness
    if ([ACDebtManager TotalNumberOfDebtRecord] != 0){
        self.backImage.hidden = TRUE;
    } else {
        self.backImage.hidden = FALSE;
    }
    [self scrollToTop];
}

// ACAddNewPersonRecordViewControllerDelegate implementation
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"debtLoanToAddView"]) {
        ACAddNewPersonRecord2ViewController *secondVC =
        (ACAddNewPersonRecord2ViewController *) segue.destinationViewController;
        [secondVC setDelegate:self];
        
        // CLOSE EDITDING MODE
        [self.tableView setEditing:FALSE animated:YES];
    }
    
    if ([segue.identifier isEqualToString:@"debtLoanToPersonRecordView"]) {
        // Assume self.view is the table view
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        ACPerson *tempPerson = [[ACDebtManager personList] objectAtIndex:[path row]];
        
        ACPersonDetailRecordsViewController *secondVC =
        (ACPersonDetailRecordsViewController *) segue.destinationViewController;
        [secondVC setCurrentCellPerson:tempPerson];
        [secondVC setDebtLoanViewController:self];
        
        // FOR SEARCH RESULT VIEW
        NSIndexPath *indexPath = nil;
        if ([self.searchDisplayController isActive]) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            [secondVC setCurrentCellPerson:[searchResults objectAtIndex:indexPath.row]];
        }
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"debtLoanToAddView"]) {
        // Request authorization to Address Book
        //BOOL returnBool = NO;;
        
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                // First time access has been granted, add the contact
                // Can't return here, so return at the end
            });
            
            if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
                return YES;
            } else {
                return NO;
            }
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            return YES;
        }
        else {
            // The user has previously denied access
            // Send an alert telling user to change privacy setting in settings app
            //if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
            [ACUtility showACGeneralAlertMsg:@"Allow Uncollectible's access to your Contacts from \nSetting > Privacy > Contacts > Uncollectible" title:@"Setting"];
            //[self.navigationController popToRootViewControllerAnimated:YES];
            return NO;
        }
        return YES;
    }
    return YES;
}

#pragma Delegates
- (void)controller:(ACAddNewPersonRecord2ViewController *)controller didSaveRecord:(id)aRecord {
    // Add Item to Data Source
    self.personLocalLists = [ACDebtManager personList];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow: inSection:0];
//    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height -100);
    
    [self.tableView reloadData];
    
    //NSLog([NSString stringWithFormat:@"AC- No of Row: %d", [self.tableView numberOfRowsInSection:0]]);
    
    [self scrollToTop];
    [self scrollToBottom];
}

- (void)controller:(ACAddNewPersonRecord2ViewController *)controller didUpdateRecord:(id)aRecord{
    // Fetch Item
    ACPerson *acPerson = (ACPerson *) aRecord;
    
    NSMutableArray *tempList = [ACDebtManager personList];
    for (int i = 0; i < [tempList count]; i ++){
        ACPerson *tempACPerson = [tempList objectAtIndex:i];
        
        if ([tempACPerson personID] == [acPerson personID]){
            // Update Table View Row
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        }
    }
    
    //Reload the whole table because of re-ordering by lastUpdated
    [self.tableView reloadData];
    // Scroll to TOP
    [self scrollToBottom];
    [self scrollToTop];
}

- (void)controller:(ACEditRecordViewController *)controller didUpdateSingleDebtRecord:(id)aRecord{
    
    [self.tableView reloadData];
    // Scroll to TOP
    [self scrollToTop];
}

// DELETE RECORD FROM DETAILVIEW
- (void)controller:(ACPersonDetailRecordsViewController *)controller didDeletePersonRecord:(ACPerson *)acPerson{
    NSMutableArray *tempList = [ACDebtManager personList];
    
    int recordRow = -1;
    for (int i = 0 ; i < [tempList count]; i++){
        if ([acPerson personID] == [[tempList objectAtIndex:i] personID]){
            recordRow = i;
            break;
        }
    }
    
    if (recordRow != -1){
        [tempList removeObjectAtIndex:recordRow];
        // save changes to disk
        [ACDebtManager SavePersonLists:tempList];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:recordRow inSection:0];
        // Delete the row from the data source
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView reloadData];
    [self scrollToTop];
    
}

#pragma Scrolling
- (void) scrollToTop{
    if ([ACDebtManager TotalNumberPersonRecord] > 0){
        NSIndexPath* ipath = [NSIndexPath indexPathForRow: 0 inSection: 0];
        [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    } else {
        self.backImage.hidden = FALSE;
    }
}

- (void) scrollToBottom{
    if ([ACDebtManager TotalNumberPersonRecord] > 0){
        NSIndexPath* ipath = [NSIndexPath indexPathForRow: ([ACDebtManager TotalNumberPersonRecord] - 1) inSection: 0];
        [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// To MAKE Gesture work
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    // USING SUBCLASS CELL WAY
    ACDebtLoanCell *cell = (ACDebtLoanCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ACDebtLoanCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    ACPerson *tempPerson = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tempPerson = (ACPerson *)[searchResults objectAtIndex:indexPath.row];
        cell = [[ACDebtLoanCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.text = tempPerson.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%4.02f", tempPerson.debtAmount ];
        
        if (tempPerson.debtAmount > 0){
            cell.detailTextLabel.textColor = [ACUtility GetDebtColor];
        } else if (tempPerson.debtAmount < 0) {
            cell.detailTextLabel.textColor = [ACUtility GetLoanColor];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%4.02f", -tempPerson.debtAmount];
        } else {
            cell.detailTextLabel.textColor = [ACUtility GetCollectedColor];
        }
        
        // accessory
        if (tempPerson.debtAmount != 0){
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        tempPerson = (ACPerson *)[[ACDebtManager personList] objectAtIndex:[indexPath row]];
    }
    
    cell.name.text = [tempPerson.firstName uppercaseString];
    cell.lastName.text = [tempPerson.lastName uppercaseString];
    cell.amount.text = [NSString stringWithFormat:@"%02f", tempPerson.debtAmount];
    // DATE FORMATTER
    NSString *formattedDate = [ACUtility FormatDate:tempPerson.lastUpdatedDate];
    [cell.lastUpdated setText:[NSString stringWithFormat:@"%@", formattedDate]];
    
    if (tempPerson.debtAmount > 0) {
        [cell.amount setText:[NSString stringWithFormat:@"%.02f", tempPerson.debtAmount]];
        cell.amount.textColor = [ACUtility GetDebtColor];
        [cell.ownMe setText:[NSString stringWithFormat:@"owes me.."]];
        cell.collecteBtn.hidden = FALSE;
    } else if (tempPerson.debtAmount < 0) {
        [cell.amount setText:[NSString stringWithFormat:@"%.02f", -tempPerson.debtAmount]];
        cell.amount.textColor = [ACUtility GetLoanColor];
        [cell.ownMe setText:[NSString stringWithFormat:@"I owe.."]];
        cell.collecteBtn.hidden = FALSE;
    } else {
        [cell.amount setText:[NSString stringWithFormat:@"%.02f", tempPerson.debtAmount]];
        cell.amount.textColor = [ACUtility GetCollectedColor];
        cell.ownMe.text = @"";
        cell.collecteBtn.hidden = TRUE;
    }
    cell.currentCellPerson = tempPerson;
    
    // INDENT WHILE EDITTING
    cell.shouldIndentWhileEditing = YES;
    [cell.amount setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:27]];
    
    return cell;
}

// FOR DETAIL DISCLOSURE
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    PSMenuItem *actionItem = [[PSMenuItem alloc] initWithTitle:@"Collected" block:^{
        [self uncollectibleUIMenuHandler:indexPath itemName:COLLECTED];
    }];
    
    PSMenuItem *action2Item = [[PSMenuItem alloc] initWithTitle:@"Uncollectible" block:^{
        [self uncollectibleUIMenuHandler:indexPath itemName:UNCOLLECTIBLE];
    }];
    
    ACDebtLoanCell *tempCell = (ACDebtLoanCell*)[self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath];
    
    [UIMenuController sharedMenuController].menuItems = @[actionItem, action2Item];
    [[UIMenuController sharedMenuController] setTargetRect:tempCell.bounds inView:tempCell];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

/* EDIT */
- (void)editItem:(id)sender {
    [self.tableView setEditing:![self.tableView isEditing] animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

//SWIPE to Delete
-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from items
//        NSLog(@"Ac - IndexPath row: %d", [indexPath row]);
        NSMutableArray *tempList = [ACDebtManager personList];
        [tempList removeObjectAtIndex:[indexPath row]];
        // save changes to disk
        [ACDebtManager SavePersonLists:tempList];
        
//        NSLog(@"AC - COUNT PersonList: %d", [[ACDebtManager personList] count]);
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // display back image
        if ([ACDebtManager TotalNumberPersonRecord] == 0){
            self.backImage.hidden = FALSE;
        }
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // Shift index source: http://www.icab.de/blog/2009/11/15/moving-objects-within-an-nsmutablearray/
    NSMutableArray *tempPersonList = [ACDebtManager personList];
    if ([toIndexPath row] != [fromIndexPath row]) {
        id obj = [tempPersonList objectAtIndex:[fromIndexPath row]];
        [tempPersonList removeObjectAtIndex:[fromIndexPath row]];
        if ([toIndexPath row] >= [tempPersonList count]) {
            [tempPersonList addObject:obj];
        } else {
            [tempPersonList insertObject:obj atIndex:[toIndexPath row]];
        }
    }
    
    [ACDebtManager SavePersonLists:tempPersonList];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

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
    
    // for search result
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self performSegueWithIdentifier: @"debtLoanToPersonRecordView" sender: self];
    }
}

#pragma mark - Search
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSArray *filteredArray;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@",searchText];
    filteredArray = [[ACDebtManager personList] filteredArrayUsingPredicate:predicate];
    searchResults = filteredArray;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    } else {
        return [[ACDebtManager personList] count];
    }
}

- (void)uncollectibleUIMenuHandler:(id)object itemName:(NSString *)itemName{
    
    if ([ACAppSetting IAPItemPurchased]
        || [ACDebtManager TotalNumberOfDebtRecord] <= [ACAppSetting getNoOfRecordsAllowed]){
        
        NSMutableArray *personList = [ACDebtManager personList];
        // Assume self.view is the table view
        //        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        
        // GET INDEXPATH OF SELECTED BUTTON
        
        
        ACPerson *tempPersonSelected;
        if ([self.searchDisplayController isActive]) {
            NSIndexPath *tempPath = (NSIndexPath *)object;
//            NSLog(@"AC- IndextForCell SearchView: %d", [tempPath row]);
            tempPersonSelected = [searchResults objectAtIndex:[tempPath row]];
        } else {
            UIButton *tempBtn = (UIButton *) object;
            ACDebtLoanCell *cell = (ACDebtLoanCell *)tempBtn.superview.superview; // BECAUSE OF CONTENTVIEW, not button.superview alone!
            NSIndexPath *path = [self.tableView indexPathForCell:cell];
//            NSLog(@"AC- IndextForCell MainView: %d", [path row]);
            tempPersonSelected = [[ACDebtManager personList] objectAtIndex:[path row]];
            [object setImage:[UIImage imageNamed:@"AC-196-radiation-enlargedCanvas@2x.png"] forState:UIControlStateNormal];
        }
        
        ACDebtRecord *newDebtRecord;
        NSString *tempDebtNote = @"";
        if ([itemName isEqualToString:UNCOLLECTIBLE]){
            if (tempPersonSelected.debtAmount > 0){
                tempDebtNote = @"* Uncollectible :(";
            } else {
                tempDebtNote = @"* Uncollectible :)";
            }
            
            newDebtRecord = [ACDebtRecord createNewACDebtRecordWithName:tempPersonSelected.name amount:-tempPersonSelected.debtAmount debtNote:tempDebtNote isCollected:FALSE andIsUncollectible:TRUE];// Reverse the debtAmount sign
        } else if ([itemName isEqualToString:COLLECTED]){
            if (tempPersonSelected.debtAmount > 0){
                tempDebtNote = @"- Collected -";
            } else {
                tempDebtNote = @"- Paid -";
            }
            
            newDebtRecord = [ACDebtRecord createNewACDebtRecordWithName:tempPersonSelected.name amount:-tempPersonSelected.debtAmount debtNote:tempDebtNote isCollected:TRUE andIsUncollectible:FALSE];// Reverse the debtAmount sign
        }
        
        // UPDATE PERSONLIST
        int count = [personList count];
        ACPerson *tempPerson = nil;
        for (int i = 0; i < count; i++){
            tempPerson = [personList objectAtIndex:i];
            ABRecordID tempPersonID = [tempPerson personID];
            
            if (tempPersonID == tempPersonSelected.personID){
                [(ACPerson *)[personList objectAtIndex:i] addDebtRecord:newDebtRecord];
                // UPDATE lastUpdated
                [(ACPerson *)[personList objectAtIndex:i] setLastUpdatedDate:[NSDate date]];
                
                // UPDATE FIRST AND LAST NAME AND NAME INCASE IT'S CHANGED IN CONTACT
                if (!tempPersonSelected.lastName){
                    tempPersonSelected.lastName = @""; // avoid (null) case
                }
                if (!tempPersonSelected.firstName){
                    tempPersonSelected.firstName = tempPersonSelected.lastName; // avoid empty firstName case
                    tempPersonSelected.lastName = @"";
                }
                [(ACPerson *)[personList objectAtIndex:i] setFirstName:tempPersonSelected.firstName];
                [(ACPerson *)[personList objectAtIndex:i] setLastName:tempPersonSelected.lastName];
                [(ACPerson *)[personList objectAtIndex:i] setName:[NSString stringWithFormat:@"%@ %@",tempPersonSelected.firstName,tempPersonSelected.lastName]];
                
                // Update the list before delegate to avoid the inconsistent Seciont count
                [ACDebtManager SavePersonLists:personList];
                [self.tableView reloadData];
                [self.searchDisplayController.searchResultsTableView reloadData]; // Reload tableView both
                
                
                // Scroll to bottom
                [self scrollToBottom];
                break;
            }
        }
        
        
    } else {
        [ACUtility showACGeneralAlertMsg:@"You have reached Uncollectible Free's limit of 7 entries. \nGo Pro to remove the limit!" title:@"Uncollectible Pro"];
    }
}

#pragma - PSMenuItem
// add support for PSMenuItem. Needs to be called once per class.
+ (void)load {
    [PSMenuItem installMenuHandlerForObject:self];
}

+ (void)initialize {
    [PSMenuItem installMenuHandlerForObject:self];
}

- (IBAction)buttonPressed:(UIButton *)button {
    // SWTICH TAB STILL APPEAR (GUESS THIS IS WRONG)
    //    [ACDebtLoanViewController load];
    //    [ACDebtLoanViewController initialize];
    
    PSMenuItem *actionItem = [[PSMenuItem alloc] initWithTitle:@"Collected" block:^{
        [self uncollectibleUIMenuHandler:button itemName:COLLECTED];
    }];
    
    PSMenuItem *action2Item = [[PSMenuItem alloc] initWithTitle:@"Uncollectible" block:^{
        [self uncollectibleUIMenuHandler:button itemName:UNCOLLECTIBLE];
    }];
    
    [UIMenuController sharedMenuController].menuItems = @[actionItem, action2Item];
    [[UIMenuController sharedMenuController] setTargetRect:button.bounds inView:button];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (IBAction)buttonChangeColor:(UIButton *)button {
    // CHANGE BUTTON WHILE PRESSED
    button.selected = YES;
    button.highlighted = YES;
    [button setImage:[UIImage imageNamed:@"AC-196-radiation-enlargedCanvasHighlighted@2x.png"] forState:UIControlStateHighlighted | UIControlStateSelected];
}

// DOESN'T SEEM TO WORK!
- (IBAction)buttonChangeColorBack:(UIButton *)button {
    button.selected = NO;
    button.highlighted = NO;
    [button setImage:[UIImage imageNamed:@"AC-196-radiation-enlargedCanvas@2x.png"] forState:UIControlStateNormal];
}



/*
 - (void)uncollectedUIMenuWithButton:(UIButton *)button{
 if ([ACDebtManager TotalNumberOfDebtRecord] <= [ACAppSetting getNoOfRecordsAllowed]){
 
 NSMutableArray *personList = [ACDebtManager personList];
 
 // GET INDEXPATH OF SELECTED BUTTON
 ACDebtLoanCell *cell = (ACDebtLoanCell *)button.superview.superview; // BECAUSE OF CONTENTVIEW, not button.superview alone!
 NSIndexPath *path = [self.tableView indexPathForCell:cell];
 NSLog(@"AC- IndextForCell: %d", [path row]);
 ACPerson *tempPersonSelected = [[ACDebtManager personList] objectAtIndex:[path row]];
 
 NSString *tempDebtNote = @"";
 if (tempPersonSelected.debtAmount > 0){
 tempDebtNote = @"- Collected -";
 } else {
 tempDebtNote = @"- Paid -";
 }
 
 ACDebtRecord *newDebtRecord = [ACDebtRecord createNewACDebtRecordWithName:tempPersonSelected.name amount:-tempPersonSelected.debtAmount debtNote:tempDebtNote isCollected:TRUE andIsUncollectible:FALSE];// Reverse the debtAmount sign
 
 // UPDATE PERSONLIST
 int count = [personList count];
 ACPerson *tempPerson = nil;
 for (int i = 0; i < count; i++){
 tempPerson = [personList objectAtIndex:i];
 ABRecordID tempPersonID = [tempPerson personID];
 
 if (tempPersonID == tempPersonSelected.personID){
 [(ACPerson *)[personList objectAtIndex:i] addDebtRecord:newDebtRecord];
 // UPDATE lastUpdated
 [(ACPerson *)[personList objectAtIndex:i] setLastUpdatedDate:[NSDate date]];
 
 // UPDATE FIRST AND LAST NAME AND NAME INCASE IT'S CHANGED IN CONTACT
 if (!tempPersonSelected.lastName){
 tempPersonSelected.lastName = @""; // avoid (null) case
 }
 if (!tempPersonSelected.firstName){
 tempPersonSelected.firstName = tempPersonSelected.lastName; // avoid empty firstName case
 tempPersonSelected.lastName = @"";
 }
 [(ACPerson *)[personList objectAtIndex:i] setFirstName:tempPersonSelected.firstName];
 [(ACPerson *)[personList objectAtIndex:i] setLastName:tempPersonSelected.lastName];
 [(ACPerson *)[personList objectAtIndex:i] setName:[NSString stringWithFormat:@"%@ %@",tempPersonSelected.firstName,tempPersonSelected.lastName]];
 
 // Update the list before delegate to avoid the inconsistent Seciont count
 [ACDebtManager SavePersonLists:personList];
 [self.tableView reloadData];
 
 // Scroll to bottom
 NSIndexPath* ipath = [NSIndexPath indexPathForRow: ([ACDebtManager TotalNumberPersonRecord] - 1) inSection: 0];
 [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
 break;
 }
 }
 } else {
 [ACUtility showACGeneralAlertMsg:@"You have reached the maximum of 1000 records" title:@"Max reached"];
 }
 
 [button setImage:[UIImage imageNamed:@"AC-196-radiation-enlargedCanvas@2x.png"] forState:UIControlStateNormal];
 }
 
 - (void)uncollectibleUIMenuWithObject:(id)object {
 if ([ACDebtManager TotalNumberOfDebtRecord] <= [ACAppSetting getNoOfRecordsAllowed]){
 
 NSMutableArray *personList = [ACDebtManager personList];
 // Assume self.view is the table view
 //        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
 
 // GET INDEXPATH OF SELECTED BUTTON
 
 
 ACPerson *tempPersonSelected;
 if ([self.searchDisplayController isActive]) {
 NSIndexPath *tempPath = (NSIndexPath *)object;
 NSLog(@"AC- IndextForCell SearchView: %d", [tempPath row]);
 tempPersonSelected = [searchResults objectAtIndex:[tempPath row]];
 } else {
 UIButton *tempBtn = (UIButton *) object;
 ACDebtLoanCell *cell = (ACDebtLoanCell *)tempBtn.superview.superview; // BECAUSE OF CONTENTVIEW, not button.superview alone!
 NSIndexPath *path = [self.tableView indexPathForCell:cell];
 NSLog(@"AC- IndextForCell MainView: %d", [path row]);
 tempPersonSelected = [[ACDebtManager personList] objectAtIndex:[path row]];
 [object setImage:[UIImage imageNamed:@"AC-196-radiation-enlargedCanvas@2x.png"] forState:UIControlStateNormal];
 }
 
 NSString *tempDebtNote = @"";
 if (tempPersonSelected.debtAmount > 0){
 tempDebtNote = @"* Uncollectible :(";
 } else {
 tempDebtNote = @"* Uncollectible :)";
 }
 
 ACDebtRecord *newDebtRecord = [ACDebtRecord createNewACDebtRecordWithName:tempPersonSelected.name amount:-tempPersonSelected.debtAmount debtNote:tempDebtNote isCollected:FALSE andIsUncollectible:TRUE];// Reverse the debtAmount sign
 
 // UPDATE PERSONLIST
 int count = [personList count];
 ACPerson *tempPerson = nil;
 for (int i = 0; i < count; i++){
 tempPerson = [personList objectAtIndex:i];
 ABRecordID tempPersonID = [tempPerson personID];
 
 if (tempPersonID == tempPersonSelected.personID){
 [(ACPerson *)[personList objectAtIndex:i] addDebtRecord:newDebtRecord];
 // UPDATE lastUpdated
 [(ACPerson *)[personList objectAtIndex:i] setLastUpdatedDate:[NSDate date]];
 
 // UPDATE FIRST AND LAST NAME AND NAME INCASE IT'S CHANGED IN CONTACT
 if (!tempPersonSelected.lastName){
 tempPersonSelected.lastName = @""; // avoid (null) case
 }
 if (!tempPersonSelected.firstName){
 tempPersonSelected.firstName = tempPersonSelected.lastName; // avoid empty firstName case
 tempPersonSelected.lastName = @"";
 }
 [(ACPerson *)[personList objectAtIndex:i] setFirstName:tempPersonSelected.firstName];
 [(ACPerson *)[personList objectAtIndex:i] setLastName:tempPersonSelected.lastName];
 [(ACPerson *)[personList objectAtIndex:i] setName:[NSString stringWithFormat:@"%@ %@",tempPersonSelected.firstName,tempPersonSelected.lastName]];
 
 // Update the list before delegate to avoid the inconsistent Seciont count
 [ACDebtManager SavePersonLists:personList];
 [self.tableView reloadData];
 [self.searchDisplayController.searchResultsTableView reloadData]; // Reload tableView both
 
 
 // Scroll to bottom
 NSIndexPath* ipath = [NSIndexPath indexPathForRow: ([ACDebtManager TotalNumberPersonRecord] - 1) inSection: 0];
 [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
 break;
 }
 }
 
 
 } else {
 [ACUtility showACGeneralAlertMsg:@"You have reached the maximum of 1000 records" title:@"Max reached"];
 }
 }
 */

@end