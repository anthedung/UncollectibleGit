//
//  ACAddNewPersonRecord2ViewController.m
//  Uncollectible
//
//  Created by Ashley Corleone on 25/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import "ACAddNewPersonRecord2ViewController.h"
#import "ACPerson.h"
#import "ACDebtManager.h"
#import "ACDebtRecord.h"
#import "ACAppDelegate.h"
#import "ACUtility.h"
#import "ACAppSetting.h"
#import "MOGlassButton.h"

@interface ACAddNewPersonRecord2ViewController ()
@property BOOL isPersonExisting;
@property NSString *firstName;
@property NSString *lastName;
@property NSString *fullName;
@property ABRecordID personID;
@end

@implementation ACAddNewPersonRecord2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isPersonExisting = FALSE;
        
        // DELEGATE to DISMISS KEYBOARD
        self.debtNote.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // DELEGATE to DISMISS KEYBOARD
    self.debtNote.delegate = self;
    [self.debtNote setReturnKeyType:UIReturnKeyDone];
    
    if (self.currentPerson){
        [self displayPersonFromDetailRecord:self.currentPerson];
    } else {
        [self addPersonDebtFromContactListShowPicker];
    }
    
    // GUI
    
    // FONT
    [self.amountTextField setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:29]];
    
    if ([self.debtLoanSegmentedControl selectedSegmentIndex] == 0) {
        [self.amountTextField setTextColor:[ACUtility GetDebtColor]];
    } else {
        [self.amountTextField setTextColor:[ACUtility GetLoanColor]];
    }
    
    // GlassButton
    [self.addButton setupAsRedButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Address Book implementation
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    [self dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

- (BOOL) personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}
// End of Address Book Delegate

// Addressbook Picker
- (void)addPersonDebtFromContactListShowPicker {
    [self startPicking];
    // Request authorization to Address Book
//    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
//    
//    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
//        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
//            // First time access has been granted, add the contact
//            if (granted) {
//             [self startPicking];
//            } else {
//                //[self.navigationController popToRootViewControllerAnimated:YES];
//            }
//        });
//    }
//    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
//        // The user has previously given access, add the contact
//        [self startPicking];
//    }
//    else {
//        // The user has previously denied access
//        // Send an alert telling user to change privacy setting in settings app
//        //if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
//        [ACUtility showACGeneralAlertMsg:@"Allow Uncollectible to access to your contact in Setting" title:@"Setting"];
//        //[self.navigationController popToRootViewControllerAnimated:YES];
//    }
    
    
}

- (void) startPicking
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    picker.navigationBar.barStyle = UIBarStyleBlack;
    
    [self presentViewController:picker animated:NO completion:nil];
}
// END

- (void)displayPerson:(ABRecordRef)person
{
    NSMutableArray *tempPersonList = [ACDebtManager personList];
    self.lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                   kABPersonLastNameProperty);
    if (!self.lastName){
        self.lastName = @""; // AVOID NULL
    }
    self.firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    if (!self.firstName){
        self.firstName = self.lastName; // assign FirstName as Last Name if Null
        self.lastName = @"";
    }
    
    self.personID = ABRecordGetRecordID(person);
    self.fullName = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    
    // SHORTEN NAME DISPLAYED
    if ([self.fullName length] < 15){
        self.personNameValue.text = self.fullName;
    } else {
        self.personNameValue.text = self.firstName;
    }
    
    [self calculateAndSetRecordADDUser:self.personID fromList:tempPersonList];
    
}

- (void)displayPersonFromDetailRecord:(ACPerson *)acPerson
{
    NSMutableArray *tempPersonList = [ACDebtManager personList];
    self.firstName = acPerson.firstName;
    self.lastName = acPerson.lastName;
    self.personID = acPerson.personID;
    self.fullName = acPerson.name;
    
    // SHORTEN NAME DISPLAYED
    if ([self.fullName length] < 15){
        self.personNameValue.text = acPerson.name;
    } else {
        self.personNameValue.text = acPerson.firstName;
    }
    
    [self calculateAndSetRecordADDUser:self.personID fromList:tempPersonList];
}

- (IBAction)changeUpdateTheList:(id)sender {
//    [self.addButton setBackgroundImage:[UIImage imageNamed:@"addButtonActive.png"] forState:UIControlStateHighlighted | UIControlStateHighlighted];
//    [self.addButton setBackgroundImage:[UIImage imageNamed:@"addButtonNormal.png"] forState:UIControlStateNormal];
    
    if ([ACAppSetting IAPItemPurchased]
        || [ACDebtManager TotalNumberOfDebtRecord] <= [ACAppSetting getNoOfRecordsAllowed]){
        
        if (![self.personNameValue.text isEqualToString:@"-"] &&
            ![self.personIDValue.text isEqualToString:@"-"] &&
            ![self.amountTextField.text isEqualToString:@""]){
            
            NSMutableArray *personList = [ACDebtManager personList];
            
            // Segment
            NSInteger selectedSegment = [self.debtLoanSegmentedControl selectedSegmentIndex];
            BOOL isOwningMe = FALSE;
            if (selectedSegment == 0){
                isOwningMe = TRUE;
            }
            //End Segment
            
            float amount = 0;
            if (isOwningMe && [self.amountTextField.text floatValue] > 0){
                amount = [self.amountTextField.text floatValue];
            } else {
                amount = -[self.amountTextField.text floatValue];
            }
            NSString *tempDebtNote = self.debtNote.text;
            ACDebtRecord *newDebtRecord = nil;
            
            newDebtRecord = [ACDebtRecord createNewACDebtRecordWithName:self.fullName amount:amount andDebtNote:tempDebtNote];
            NSLog(@"%@", newDebtRecord);
            
            if ([self isExistingInPersonListUsingPersonID:self.personID] && newDebtRecord){
                int count = [personList count];
                
                ACPerson *tempPerson = nil;
                for (int i = 0; i < count; i++){
                    tempPerson = [personList objectAtIndex:i];
                    ABRecordID tempPersonID = [tempPerson personID];
                    
                    if (tempPersonID == self.personID){
                        [(ACPerson *)[personList objectAtIndex:i] addDebtRecord:newDebtRecord];
                        // UPDATE lastUpdated
                        [(ACPerson *)[personList objectAtIndex:i] setLastUpdatedDate:[NSDate date]];
                        
                        // UPDATE FIRST AND LAST NAME AND NAME INCASE IT'S CHANGED IN CONTACT
                        if (!self.lastName){
                            self.lastName = @""; // avoid (null) case
                        }
                        if (!self.firstName){
                            self.firstName = self.lastName; // avoid empty firstName case
                            self.lastName = @"";
                        }
                        [(ACPerson *)[personList objectAtIndex:i] setFirstName:self.firstName];
                        [(ACPerson *)[personList objectAtIndex:i] setLastName:self.lastName];
                        [(ACPerson *)[personList objectAtIndex:i] setName:[NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName]];
                        
                        // Update the list before delegate to avoid the inconsistent Seciont count
                        [ACDebtManager SavePersonLists:personList];
                        //[ACDebtManager PrintPersonList];
                        break;
                    }
                }
                
                //Delegate
                [self.delegateDetailedView controller:self didSaveRecord:newDebtRecord];
                [self.delegate controller:self didUpdateRecord:tempPerson];
                
            } else {
                ACPerson *newPerson = [ACPerson createNewPersonWitFirsthName:self.firstName andLastName:self.lastName andPersonID:self.personID];
                [newPerson addDebtRecord:newDebtRecord];
                [personList addObject:newPerson];
                
                [ACDebtManager SavePersonLists:personList];
                
                // DELEGATE:
                [self.delegate controller:self didSaveRecord:newPerson];
                
            }
            
            //Reset isPersonExisting
            self.isPersonExisting = FALSE;
            
            [self.navigationController popViewControllerAnimated:YES];
        } else{
            //Alert
            [ACUtility showACGeneralAlert:@"How much?"];
        }
    } else {
        [ACUtility showACGeneralAlertMsg:@"You have reached Uncollectible Free's limit of 7 entries. \nGo Pro to remove the limit!" title:@"Uncollectible Pro"];
    }
}

- (IBAction)tappedEnd:(id)sender {
    //self.amountTextField.text = [NSString stringWithFormat:@"$%@", self.amountTextField.text];
    [self.view endEditing:YES];
}

- (IBAction)onFinishedEditingAmount:(id)sender {
    float tempAmt = [self.amountTextField.text floatValue];
    if (tempAmt != 0.0) { // DON'T ALLOW 0.0 ENTRY + DISPLAY
        self.amountTextField.text = [NSString stringWithFormat:@"%04.2f", tempAmt];
    }else {
        self.amountTextField.text = @"";
    }
}

// CHECK IF ALREADY EXIST
//- (BOOL) isExistingInPersonList:(NSString *)checkingName{
//    NSMutableArray *tempPersonList = [ACDebtManager personList];
//
//    // USING PREDICATE
//    for (ACPerson *person in tempPersonList) {
//
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ MATCHES %@", checkingName, person.name];
//        NSArray *filteredArray = [tempPersonList filteredArrayUsingPredicate:predicate];
//        if ([filteredArray count] > 0) {
//            self.isPersonExisting = TRUE;
//            return TRUE;
//            break;
//        }
//    }
//
//    return FALSE;
//}

// CHECK IF ALREADY EXIST
- (BOOL) isExistingInPersonListUsingPersonID:(ABRecordID)personID{
    NSMutableArray *tempPersonList = [ACDebtManager personList];
    
    // USING PREDICATE
    for (ACPerson *person in tempPersonList) {
        // USING STRING INSTEAD OF NUMBER TO AVOID "Can't create a regex expression from object" EXCEPTION
        NSString *checkingID = [NSString stringWithFormat:@"%d", personID];
        NSString *loopingPersonID = [NSString stringWithFormat:@"%d", person.personID];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ MATCHES %@", checkingID, loopingPersonID];
        NSArray *filteredArray = [tempPersonList filteredArrayUsingPredicate:predicate];
        if ([filteredArray count] > 0) {
            self.isPersonExisting = TRUE;
            return TRUE;
            break;
        }
    }
    
    return FALSE;
}

// To add the debt-loan descriptive sentences at the end
- (void) calculateAndSetRecordADDUser:(ABRecordID)checkingPersonID fromList:(NSMutableArray *)tempPersonList{
    // NORMAL WAY
    ACPerson *tempPerson = nil;
    for (int i = 0 ; i < [tempPersonList count]; i++) {
        if (checkingPersonID == [[tempPersonList objectAtIndex:i] personID]){
            tempPerson = [tempPersonList objectAtIndex:i];
        }
    }
    
    if ([self isExistingInPersonListUsingPersonID:[tempPerson personID]] && tempPerson){
        
        // DATE FORMATTER
        NSString *formattedDate = [ACUtility FormatDate:[[tempPerson.debtRecords objectAtIndex:0] dateCreated]];
        
        // RANDOM SEX GENERATOR
        NSInteger randomNumber = arc4random() % 1;
        BOOL isBoy = FALSE;
        
        if (randomNumber == 0) {
            isBoy = TRUE;
        }
        
        //[ACUtility showACGeneralAlert:@"EXIST - UPDATING.."];
        if ([tempPerson debtAmount] > 0){
            self.recordsOfAddedUser.text = [NSString stringWithFormat:@"%@ is currently owing you $%04.2f, since %@.",tempPerson.name, tempPerson.debtAmount, formattedDate];
        } else if ([tempPerson debtAmount] < 0) {
            if (isBoy){
                self.recordsOfAddedUser.text = [NSString stringWithFormat:@"You are currently owing %@ $%04.2f, since %@.",tempPerson.name, -tempPerson.debtAmount, formattedDate];
            } else {
                self.recordsOfAddedUser.text = [NSString stringWithFormat:@"You are currently owing %@ $%04.2f, since %@.",tempPerson.name, tempPerson.debtAmount, formattedDate];
            }
        } else {
            self.recordsOfAddedUser.text = [NSString stringWithFormat:@"You guys used to be in debt to each other. What happened?"];
        }
    } else {
        self.recordsOfAddedUser.text = [NSString stringWithFormat:@"Congratulations! Keep the debtful relationship alive!"];
    }
}

// DEGEGATE TO DISMISS TEXTFIELD KEYBOARD => DOESN'T WORK
//- (void) textFieldDidEndEditing:(UITextField *)textField{
//    [textField resignFirstResponder];
//}
// OR ALTERNATIVE TO DISMISS
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// EVENT HANDLER
- (IBAction)changeColorBySegmented:(id)sender {
    if ([self.debtLoanSegmentedControl selectedSegmentIndex] == 0){
        self.amountTextField.textColor = [ACUtility GetDebtColor];
    } else {
        self.amountTextField.textColor = [ACUtility GetLoanColor];
    }
}

@end
