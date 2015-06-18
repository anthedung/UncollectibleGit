//
//  ACAddNewPersonViewController.h
//  Uncollectible
//
//  Created by Ashley Corleone on 25/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ACAddNewPersonViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate,  ABPersonViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *personIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *personIDValue;
@property (weak, nonatomic) IBOutlet UILabel *debtorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNameValue;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *debtLoanSegmentedControl;

- (IBAction)updateTheList:(id)sender;

@end
