//
//  ACAddNewPersonRecord2ViewController.h
//  Uncollectible
//
//  Created by Ashley Corleone on 25/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ACPerson.h"
#import "ACAddNewPersonRecord2ViewController.h"
#import "MOGlassButton.h"

@protocol ACAddNewPersonRecord2ViewControllerDelegate;
@interface ACAddNewPersonRecord2ViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate,  ABPersonViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, assign) id<ACAddNewPersonRecord2ViewControllerDelegate> delegate;
@property (nonatomic, assign) id<ACAddNewPersonRecord2ViewControllerDelegate> delegateDetailedView;
@property ACPerson *currentPerson;

@property (weak, nonatomic) IBOutlet UILabel *personIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *personIDValue;
@property (weak, nonatomic) IBOutlet UILabel *debtorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNameValue;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *debtLoanSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *debtNote;
@property (weak, nonatomic) IBOutlet UILabel *recordsOfAddedUser;
@property (weak, nonatomic) IBOutlet MOGlassButton *addButton;

- (IBAction)changeUpdateTheList:(id)sender;
- (IBAction)tappedEnd:(id)sender;
- (IBAction)onFinishedEditingAmount:(id)sender;
- (IBAction)changeColorBySegmented:(id)sender;
@end

@protocol ACAddNewPersonRecord2ViewControllerDelegate <NSObject>
- (void)controller:(ACAddNewPersonRecord2ViewController *)controller didSaveRecord:(id)aRecord;
- (void)controller:(ACAddNewPersonRecord2ViewController *)controller didUpdateRecord:(id)aRecord;
@end
