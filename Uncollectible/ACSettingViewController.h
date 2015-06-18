//
//  ACSettingViewController.h
//  Uncollectible
//
//  Created by Ashley Corleone on 6/5/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h> 
#import "MOGlassButton.h"
#import <Social/Social.h>
#import <GooglePlus/GooglePlus.h>
//#import "SHK.h"

@interface ACSettingViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver, UIAlertViewDelegate, GPPShareDelegate> {
    UIAlertView *askToPurchase; 
}

@property (weak, nonatomic) IBOutlet UIImageView *proFreeBanner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *purchasingStatusIndicator;
@property (weak, nonatomic) IBOutlet MOGlassButton *purchaseBtn;

@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *twitterBtn;
- (IBAction)shareOnFacebook:(UIButton *)sender;
- (IBAction)shareOnTwitter:(id)sender;
- (IBAction)goToFacebookPage:(UIButton *)sender;
- (IBAction)shareOnGooglePlus:(id)sender;



- (IBAction)showThankYou:(UIButton *)sender;


- (IBAction)deleteKeyChain:(id)sender;
- (IBAction)purchaseNow:(UIButton *)sender;

// UNUSED
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseSttLabel;

@end
