//
//  ACEditRecordViewController.m
//  Uncollectible
//
//  Created by Ashley Corleone on 1/5/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import "ACEditRecordViewController.h"

@interface ACEditRecordViewController ()
@property NSDate *dateUpdatedValue;
@property UIDatePicker *datePicker;
@end

@implementation ACEditRecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // DELEGATE to DISMISS KEYBOARD
        self.debtNote.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadLabelFromCurrentCellPersonWithStyling];
    
    // DELEGATE to DISMISS KEYBOARD
    self.debtNote.delegate = self;
    [self.debtNote setReturnKeyType:UIReturnKeyDone];
    
    [self.updateButton setupAsRedButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadLabelFromCurrentCellPersonWithStyling
{
    // DATE PICKER
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.dateCreated.inputView = self.datePicker;
    // MAX-MIN DATE PICKER
    NSString *startDateStr = @"1991-06-04";
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [f dateFromString:startDateStr];
    self.datePicker.minimumDate = startDate;
    self.datePicker.maximumDate = [NSDate date];
    
    // IF COLLECTED OR UNCOLLECTED => HIDE SEGMENTED LEND-BORROW
    if (self.currentCellDebtRecord.isUncollectible || self.currentCellDebtRecord.isCollected){
        self.debtLoanSegmentedControl.enabled = FALSE;
    }
    
    if ([self.currentCellPerson.name length] < 15){
        self.personNameValue.text = self.currentCellPerson.name;
    }else {
        self.personNameValue.text = self.currentCellPerson.firstName;
    }
    
    self.debtNote.text = self.currentCellDebtRecord.debtNote;
    if (self.currentCellDebtRecord.debtAmount < 0) {
        self.amountTextField.text = [NSString stringWithFormat:@"%04.2f", -self.currentCellDebtRecord.debtAmount];
        self.amountTextField.textColor = [ACUtility GetLoanColor];
        [self.debtLoanSegmentedControl setSelectedSegmentIndex:1];// SET Selected Index at 1
    } else {
        self.amountTextField.text = [NSString stringWithFormat:@"%04.2f", self.currentCellDebtRecord.debtAmount];
        self.amountTextField.textColor = [ACUtility GetDebtColor];
    }
    // COLLECTED, UNCOLLECTIBLE COLOR
    if (self.currentCellDebtRecord.isCollected){
        self.amountTextField.textColor = [ACUtility GetCollectedColor];
    } else if (self.currentCellDebtRecord.isUncollectible){
        self.amountTextField.textColor = [ACUtility GetUncollectibleColor];
    }
    
    // DATE
    NSString *formattedDate = [ACUtility FormatDateNumberOnly:self.currentCellDebtRecord.dateCreated];
    [self.dateCreated setText:[NSString stringWithFormat:@"%@", formattedDate]];
    
    [self.amountTextField setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:29]];
    [self.dateCreated setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:21]];
}

- (IBAction)changeColorBySegmented:(id)sender {
    if ([self.debtLoanSegmentedControl selectedSegmentIndex] == 0){
        self.amountTextField.textColor = [ACUtility GetDebtColor];        
    } else {
        self.amountTextField.textColor = [ACUtility GetLoanColor];    
    }
}

- (IBAction)updateDebtRecord:(id)sender {
//    [self.updateButton setBackgroundImage:[UIImage imageNamed:@"updateActiveButton.png"] forState:UIControlStateHighlighted | UIControlStateHighlighted];
//    [self.updateButton setBackgroundImage:[UIImage imageNamed:@"u[dateButtonNormal.png"] forState:UIControlStateNormal];
    if (!([self.amountTextField.text floatValue] == 0)){
        
        // Update Date
        self.currentCellPerson.lastUpdatedDate = [NSDate date];
        if (self.dateUpdatedValue){
            self.currentCellDebtRecord.dateCreated = self.dateUpdatedValue;
            self.currentCellPerson.debtRecords = [ACDebtManager SortDebtRecordByDate:self.currentCellPerson.debtRecords]; // SORT 
        }
        
        if (self.currentCellDebtRecord.isCollected || self.currentCellDebtRecord.isUncollectible){
            if (self.currentCellDebtRecord.debtAmount > 0){ // PAID OR RECEIVED SAME SIGN
                self.currentCellDebtRecord.debtAmount = [self.amountTextField.text floatValue];
            } else {
                self.currentCellDebtRecord.debtAmount = -[self.amountTextField.text floatValue];
            }
        } else {
            if ([self.debtLoanSegmentedControl selectedSegmentIndex] == 0){
                self.currentCellDebtRecord.debtAmount = [self.amountTextField.text floatValue];
            } else {
                self.currentCellDebtRecord.debtAmount = -[self.amountTextField.text floatValue];
            }
        }
        
        self.currentCellDebtRecord.debtNote = self.debtNote.text;
        [self.currentCellPerson reCalculateDebtAmount];// recalculate debtAmount After updating the Debtrecord
        
        [ACDebtManager SavePersonLists:[ACDebtManager personList]];
        // Delegate to reloadView
        [self.delegate controller:self didUpdateSingleDebtRecord:self.currentCellDebtRecord];
        [self.delegateDebtLoanViewController controller:self didUpdateSingleDebtRecord:self.currentCellDebtRecord];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else{
        //Alert
        [ACUtility showACGeneralAlertMsg:@"How much?" title:@"Uncollectible"];
    }
}

// DISMISS TEXTVIEW
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)tappedEnd:(id)sender {
    //self.amountTextField.text = [NSString stringWithFormat:@"$%@", self.amountTextField.text];
    [self.view endEditing:YES];
//    self.dateCreatedPicker.hidden = TRUE;
}

// Amount Text
- (IBAction)onFinishedEditingAmount:(id)sender {
    float tempAmt = [self.amountTextField.text floatValue];
    if (tempAmt != 0.0) { // DON'T ALLOW 0.0 ENTRY + DISPLAY
        self.amountTextField.text = [NSString stringWithFormat:@"%04.2f", tempAmt];
    }else {
        self.amountTextField.text = @"";
    }
}

- (IBAction)showDatePicker:(id)sender {
    //self.dateCreatedPicker.hidden = FALSE;
}

- (void)datePickerValueChanged:(UIDatePicker *)sender {
    // DATE
    NSString *formattedDate = [ACUtility FormatDateNumberOnly:[self.datePicker date]];
    [self.dateCreated setText:[NSString stringWithFormat:@"%@", formattedDate]];
    self.dateUpdatedValue = [self.datePicker date];
}
@end
