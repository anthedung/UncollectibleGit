//
//  ACGraphViewController.h
//  Uncollectible
//
//  Created by Ashley Corleone on 29/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import <QuartzCore/QuartzCore.h>
static int GraphRadius = 110;
static int labelRadius = 80;

@interface ACGraphViewController : UIViewController <XYPieChartDelegate, XYPieChartDataSource>
@property (strong, nonatomic) IBOutlet XYPieChart *pieChart;
@property(nonatomic, strong) NSMutableArray *slices;
@property (weak, nonatomic) IBOutlet UILabel *toChaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *theDebtorsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *percentageImage;
@property (strong, nonatomic) IBOutlet UILabel *percentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedSliceLabel;
@property (strong, nonatomic) IBOutlet UITextField *numOfSlices;
@property (strong, nonatomic) IBOutlet UISegmentedControl *indexOfSlices;
@property (weak, nonatomic) IBOutlet UILabel *debtorName;
@property (weak, nonatomic) IBOutlet UILabel *debtAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeSlideBtn;
@property (weak, nonatomic) IBOutlet UIButton *undoGraphBtn;
- (IBAction)removeSlice:(id)sender;
- (IBAction)undoGraph:(id)sender;

@property(nonatomic, strong) NSArray        *sliceColors;
@end
