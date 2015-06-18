//
//  ACLoanGraphViewController
//  Uncollectible
//
//  Created by Ashley Corleone on 29/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import "ACLoanGraphViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ACDebtManager.h"
#import "ACPerson.h"
#import "ACUtility.h"

@interface ACLoanGraphViewController ()
@property int selectedIndex;
@property UIImageView *imgView;
@end

@implementation ACLoanGraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self preparePieChart];
}

- (void) preparePieChart{
    // Do any additional setup after loading the view.
    
    // XYPieChart FOR DEBTOR
    // SETUP SLICES VALUES
    [self setUpSliceValues];
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setStartPieAngle:M_2_PI];	//optional
    [self.pieChart setAnimationSpeed:1.0];	//optional
    [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];	//optional
    //[self.pieChart setLabelColor:[UIColor blackColor]];	//optional, defaults to white
    [self.pieChart setLabelShadowColor:[UIColor blackColor]];	//optional, defaults to none (nil)
    [self.pieChart setLabelRadius:80];	//optional
    //    [self.pieChart setShowPercentage:YES];	//optional
    [self.pieChart setPieBackgroundColor:[UIColor whiteColor]];	//optional
    [self.pieChart setPieRadius:110];
    
    //SET POSITION
    [self.pieChart setPieCenter:CGPointMake(self.view.frame.size.width/2, 140)];	//default
    
    
    
    
    // ADDWD
    
}

- (void)viewDidUnload
{
    [self setPieChart:nil];
    [self setPercentageLabel:nil];
    [self setSelectedSliceLabel:nil];
    [self setIndexOfSlices:nil];
    [self setNumOfSlices:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // SETUP SLICES VALUES
    [self setUpSliceValues];
    [self.pieChart reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChart reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
    //    return 2;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index{
    
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index{
    NSMutableArray *tempPersonList = [ACDebtManager GetLoanerOnlyList];
    ACPerson *tempPerson = [tempPersonList objectAtIndex:index];
    
    self.debtorName.text = tempPerson.name;
    self.debtAmountLabel.text = [NSString stringWithFormat:@"$%04.2f", -tempPerson.debtAmount];
    
    // SET Selected index
    self.selectedIndex = index;
    //NSLog(@"AC - index: %d", index);
}

- (void) pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index{
    //    self.debtorName.text = @"";
    //    self.debtAmountLabel.text = @"";
    
//    self.selectedIndex = -1;
}

- (void) pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index{
    //    self.debtorName.text = @"";
    //    self.debtAmountLabel.text = @"";
    self.selectedIndex = -1; // GUESS THIS IS BEFORE didSelect => RIGHT
    // ORDER: willSelect => willDeselect => didSelect => didDeselect
}

// SETUP TO RELOAD
- (void) setUpSliceValues{
    NSMutableArray *tempPersonList = [ACDebtManager GetLoanerOnlyList];
    int countPersonList = [tempPersonList count];
    self.slices = [NSMutableArray arrayWithCapacity:countPersonList];
    
    for(int i = 0; i < countPersonList; i ++)
    {
        // MAKE IT POSITIVE TO DRAW GRAPH LOL
        NSNumber *one = [NSNumber numberWithFloat:(-1 * [[tempPersonList objectAtIndex:i] debtAmount])];
        [_slices addObject:one];
        //NSLog(@"[_slices addObject:one] = %@",one);
    }
    
    // iPhone 5!!
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            /*Do iPhone 5 stuff here.*/
            // RESET POSITION
            self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 210 , 100, 100)];
            self.imgView.contentMode = UIViewContentModeCenter;
            [self.imgView setImage:[UIImage imageNamed:@"percentage-circled-Smaller_right.png"]];
            
            [self.view addSubview:self.imgView];
            self.percentageImage.hidden = TRUE;
            [self.pieChart setPieCenter:CGPointMake(self.view.frame.size.width/2, 160)];
            [self.pieChart setLabelRadius:90];
            [self.pieChart setPieRadius:120];
            
            if (countPersonList > 0) {
                self.imgView.hidden = TRUE;
            } else {
                self.imgView.hidden = FALSE;
            }
        } else {
            if (countPersonList > 0) {
                self.percentageImage.hidden = TRUE;
            } else {
                self.percentageImage.hidden = FALSE;
            }
        }
    } else {
        /*Do iPad stuff here.*/
    }
    
    // RESET LABEL
    if (countPersonList > 0) {
        self.debtorName.text = @"Tap to slice up";
        self.removeSlideBtn.hidden = FALSE;
        self.undoGraphBtn.hidden = FALSE;
    } else {
        self.debtorName.text = @"Let's Go Borrow Money!";
        self.removeSlideBtn.hidden = TRUE;
        self.undoGraphBtn.hidden = TRUE;
    }
    self.debtAmountLabel.text = @"";
    
    
    
    // Slice Coloring
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:6/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],
                       [UIColor colorWithRed:246/255.0 green:15/255.0 blue:20/255.0 alpha:1],
                       [UIColor colorWithRed:19/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:13/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:6/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:19/255.0 alpha:1],
                       [UIColor colorWithRed:26/255.0 green:15/255.0 blue:20/255.0 alpha:1],
                       [UIColor colorWithRed:19/255.0 green:15/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:13/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:29/255.0 green:60/255.0 blue:15/255.0 alpha:1],
                       [UIColor colorWithRed:18/255.0 green:11/255.0 blue:19/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:13/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:209/255.0 green:60/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:11/255.0 blue:19/255.0 alpha:1],
                       [UIColor colorWithRed:26/255.0 green:5/255.0 blue:2/255.0 alpha:1],
                       [UIColor colorWithRed:1/255.0 green:15/255.0 blue:9/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:13/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:29/255.0 green:90/255.0 blue:15/255.0 alpha:1],
                       [UIColor colorWithRed:181/255.0 green:51/255.0 blue:129/255.0 alpha:1],nil];
    
    self.selectedIndex = -1;
    
    }

// ACcustomDelegate
- (void)ACcustomPieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index{
// Stupid
}

- (IBAction)removeSlice:(id)sender{
    if (self.selectedIndex != -1) {
        // WAY 1
        [self.slices removeObjectAtIndex:self.selectedIndex];
        
        // AND KEEP THE INDEX AND CHANGE TO ZERO ONLY TO AVOID THE OUT OF BOUND
        [self.slices addObject:[NSNumber numberWithFloat:0.0]];
        
        // KEEP THE CORRESPONDING COLOR
        NSMutableArray *tempColors = [NSMutableArray arrayWithArray:self.sliceColors];
        [tempColors removeObjectAtIndex:self.selectedIndex];
        self.sliceColors = tempColors;
        
        [self.pieChart reloadData];
    } else {
        [ACUtility showACGeneralAlertMsg:@"Select a slice first" title:@"Uncollectible"];
    }
   
    self.selectedIndex = - 1;
}

- (IBAction)undoGraph:(id)sender {
    // SETUP SLICES VALUES
    [self setUpSliceValues];
    [self.pieChart reloadData];
}

@end