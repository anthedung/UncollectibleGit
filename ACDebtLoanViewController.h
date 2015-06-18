//
//  ACDebtLoanViewController.h
//  Uncollectible
//
//  Created by Ashley Corleone on 25/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACUtility.h"
#import "ACAddNewPersonRecord2ViewController.h"
#import "ACEditRecordViewController.h"
//#import "PSMenuItem.h" // FOR POPUP

@interface ACDebtLoanViewController : UITableViewController <ACAddNewPersonRecord2ViewControllerDelegate,ACEditRecordViewControllerDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *skullBarItem;

- (IBAction)editItem:(id)sender;
- (IBAction)buttonPressed:(UIButton *)button ;
- (IBAction)buttonChangeColor:(UIButton *)button;
- (IBAction)buttonChangeColorBack:(UIButton *)button;
@end
