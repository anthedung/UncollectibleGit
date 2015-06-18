//
//  ACEditRecordViewController.h
//  Uncollectible
//
//  Created by Ashley Corleone on 1/5/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACPerson.h"
#import "ACDebtRecord.h"
#import "ACDebtManager.h"
#import "ACUtility.h"
#import "MOGlassButton.h"

@protocol ACEditRecordViewControllerDelegate;
@interface ACEditRecordViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, assign) id<ACEditRecordViewControllerDelegate> delegate;
@property (nonatomic, assign) id<ACEditRecordViewControllerDelegate> delegateDebtLoanViewController;
@property (weak, nonatomic) IBOutlet UILabel *personNameValue;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *debtLoanSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *debtNote;
@property (weak, nonatomic) IBOutlet UITextField *dateCreated;
@property (weak, nonatomic) IBOutlet UISwitch *uncollectibleSwitch;
@property (weak, nonatomic) IBOutlet MOGlassButton *updateButton;

@property ACPerson *currentCellPerson;
@property ACDebtRecord *currentCellDebtRecord;
- (IBAction)changeColorBySegmented:(id)sender;
- (IBAction)updateDebtRecord:(id)sender;
- (IBAction)tappedEnd:(id)sender;
- (IBAction)onFinishedEditingAmount:(id)sender;

@end

@protocol ACEditRecordViewControllerDelegate <NSObject>

- (void)controller:(ACEditRecordViewController *)controller didUpdateSingleDebtRecord:(id)aRecord;

@end
