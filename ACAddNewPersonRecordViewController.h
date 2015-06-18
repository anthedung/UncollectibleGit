//
//  ACAddNewPersonRecordViewController.h
//  Uncollectible
//
//  Created by Ashley Corleone on 25/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ACPerson.h"

//@protocol ACAddNewPersonRecordViewControllerDelegate;
@interface ACAddNewPersonRecordViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate,  ABPersonViewControllerDelegate>
//@property (weak) id<ACAddNewPersonRecordViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *personIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *personIDValue;
@property (weak, nonatomic) IBOutlet UILabel *debtorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNameValue;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *debtLoanSegmentedControl;
- (IBAction)changeUpdateTheList:(id)sender;
- (IBAction)tappedEnd:(id)sender;
@end

//@protocol ACAddNewPersonRecordViewControllerDelegate <NSObject>
//- (void)controller:(ACAddNewPersonRecordViewController *)controller didSavePerson:(ACPerson *)acPerson;
//@end
