//
//  ACAddNewPersonRecordViewController.m
//  Uncollectible
//
//  Created by Ashley Corleone on 25/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import "ACAddNewPersonRecordViewController.h"
#import "ACPerson.h"
#import "ACDebtManager.h"
#import "ACDebtRecord.h"

@interface ACAddNewPersonRecordViewController ()
@property BOOL isPersonExisting;
@end

@implementation ACAddNewPersonRecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isPersonExisting = FALSE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addPersonDebtFromContactListShowPicker];
    
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//}


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
    
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            
            [self startPicking];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self startPicking];
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
}

- (void) startPicking
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}
// END

- (void)displayPerson:(ABRecordRef)person
{
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    ABRecordID personID = ABRecordGetRecordID(person);
    
    self.personNameValue.text = name;
    self.personIDValue.text = [NSString stringWithFormat:@"%d", personID];
    
    [self isExistingInPersonList:name];
}

- (IBAction)changeUpdateTheList:(id)sender {
    //validation
    if (![self.personNameValue.text isEqualToString:@"-"] &&
        ![self.personIDValue.text isEqualToString:@"-"] &&
        ![self.amountTextField.text isEqualToString:@""]){
        
        NSMutableArray *personList = [ACDebtManager personList];
        
        BOOL isOwningMe = [self.debtLoanSegmentedControl isEnabledForSegmentAtIndex:0];
        NSString *name = self.personNameValue.text;
        int personID = [self.personIDValue.text intValue];
        float amount = [self.amountTextField.text floatValue];
        ACDebtRecord *newDebtRecord = [ACDebtRecord createNewACDebtRecordWithName:name isDebt:isOwningMe amount:amount];
        
        if (self.isPersonExisting){
            int count = [personList count];
            
            for (int i = 0; i < count; i++){
                NSString *tempPerson = [[personList objectAtIndex:i] name];
                
                if ([tempPerson isEqualToString:name]){
                    [(ACPerson *)[personList objectAtIndex:i] addDebtRecord:newDebtRecord];
                }
                
                break;
            }
        } else {
            ACPerson *newPerson = [ACPerson createNewPersonWithName:name andPersonID:personID];
            [newPerson addDebtRecord:newDebtRecord];
            
            [personList addObject:newPerson];
            //[self.delegate controller:self didSavePerson:newPerson];
        }
    
        [ACDebtManager SavePersonLists:personList];
        
        
        
        //Reset isPersonExisting
        self.isPersonExisting = FALSE;
        NSLog(@"ADDDED");
    } else{
        //Alert
        [self showAlert:@"Enter required field"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tappedEnd:(id)sender {
    [self.view endEditing:YES];
}


// CHECK IF ALREADY EXIST
- (void) isExistingInPersonList:(NSString *)checkingName{
    NSMutableArray *tempPersonList = [ACDebtManager personList];
    for (ACPerson *person in tempPersonList) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ MATCHES %@", checkingName, person.name];
        NSArray *filteredArray = [tempPersonList filteredArrayUsingPredicate:predicate];
        if ([filteredArray count] > 0) {
            self.isPersonExisting = TRUE;
        }
    }
    if (self.isPersonExisting){
        [self showAlert:@"EXIST"];
    }
}

- (void) showAlert:(NSString *)msg{
    //Alert
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Hello AC! %@",msg]
                                                      message:msg
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}
@end
