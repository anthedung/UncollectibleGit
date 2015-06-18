//
//  ACAboutViewController.m
//  Uncollectible
//
//  Created by Ashley Corleone on 30/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import "ACAboutViewController.h"
#import "ACUtility.h"

@interface ACAboutViewController ()

@end

@implementation ACAboutViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)thankYouAlert:(id)sender {
    [ACUtility showACGeneralAlertMsg:@"Feel free to complaint about Uncollectible \nat anthedung@gmail.com.  \nFeedback appreciated! \n\n -- ACiOS ChickBong --" title:@"Thank you"];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
