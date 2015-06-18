//
//  ACPersonDetailedRecordCell.h
//  Uncollectible
//
//  Created by Ashley Corleone on 29/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACPersonDetailedRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *debtAmount;
@property (weak, nonatomic) IBOutlet UILabel *ownMe;
@property (weak, nonatomic) IBOutlet UILabel *dateUpdated;
@property (weak, nonatomic) IBOutlet UILabel *noOfDaysPassed;
@property (weak, nonatomic) IBOutlet UILabel *debtNote;

@end
