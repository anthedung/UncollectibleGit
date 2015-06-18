//
//  ACPersonDetailRecordsViewController.h
//  Uncollectible
//
//  Created by Ashley Corleone on 29/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACPersonDetailedRecordCell.h"
#import "ACPerson.h"
#import "ACDebtRecord.h"
#import "ACUtility.h"
#import "ACAddNewPersonRecord2ViewController.h"
#import "ACDebtManager.h"
#import "ACDebtLoanViewController.h"

@protocol ACPersonDetailRecordsViewControllerDelegate;
@interface ACPersonDetailRecordsViewController : UITableViewController <ACAddNewPersonRecord2ViewControllerDelegate, ACEditRecordViewControllerDelegate>

@property ACPerson *currentCellPerson;
@property ACDebtLoanViewController *debtLoanViewController;
@end

@protocol ACPersonDetailRecordsViewControllerDelegate <NSObject>
- (void) controller: (ACPersonDetailRecordsViewController *) controller didDeletePersonRecord:(ACPerson *) acPerson;
@end
