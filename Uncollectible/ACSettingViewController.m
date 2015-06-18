//
//  ACSettingViewController.m
//  Uncollectible
//
//  Created by Ashley Corleone on 6/5/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import "ACSettingViewController.h"
#import "ACAppSetting.h"
#import "ACUtility.h"
#import "SFHFKeychainUtils.h"


@interface ACSettingViewController ()

@end

@implementation ACSettingViewController
#define kStoredData @"com.anthedung.uncollectible.pro"

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
    [self.purchaseBtn setupAsRedButton];
    
    self.purchasingStatusIndicator.hidesWhenStopped = YES;
    self.statusLabel.hidden = YES;
    self.purchaseSttLabel.hidden = YES;
    
    if ([ACAppSetting IAPItemPurchased]) {
        [self.proFreeBanner setImage:[UIImage imageNamed:@"ACProVersionBanner.png"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)purchaseNow:(UIButton *)sender {
//    [self.purchaseBtn setBackgroundImage:[UIImage imageNamed:@"ActiveBuyButton.png"] forState:UIControlStateHighlighted | UIControlStateHighlighted];
//    [self.purchaseBtn setBackgroundImage:[UIImage imageNamed:@"NormalBuyButton.png"] forState:UIControlStateNormal];
    
    if ([ACAppSetting IAPItemPurchased]) {
        
        [ACUtility showACGeneralAlertMsg:@"You are already an Uncollectible Pro!" title:@"Uncollectible Pro"];
        
    } else {
        
        // Check Internet Connection
        if (![self connectedToInternet]){
            [ACUtility showACGeneralAlertMsg:@"Please check your internet connection" title:@"Internet Connection"];
        } else {
        
            // not purchased so show a view to prompt for purchase
            
            askToPurchase = [[UIAlertView alloc]
                             
                             initWithTitle:@"Uncollectible Pro"
                             
                             message:@"Love more? \nGo Pro for unlimited entries!"
                             
                             delegate:self
                             
                             cancelButtonTitle:nil
                             
                             otherButtonTitles:@"Yes", @"No", nil];
            
            askToPurchase.delegate = self;
            
            [askToPurchase show];
        }
    }
    
}




#pragma - In App Purchase
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response

{
    // remove wait view here
    SKProduct *validProduct = nil;
    
    int count = [response.products count];

    if (count>0) {
        
        validProduct = [response.products objectAtIndex:0];
        
        SKPayment *payment = [SKPayment paymentWithProduct:validProduct];
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        [[SKPaymentQueue defaultQueue] addPayment:payment]; // <-- KA CHING!
        
    } else {
        
        UIAlertView *tmp = [[UIAlertView alloc]
                            
                            initWithTitle:@"Not Available"
                            
                            message:@"No products to purchase"
                            
                            delegate:self
                            
                            cancelButtonTitle:nil
                            
                            otherButtonTitles:@"Ok", nil];
        
        [tmp show];
    }
}

-(void)requestDidFinish:(SKRequest *)request
{
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Failed to connect with error: %@", [error localizedDescription]);
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                
                // show wait view here
                self.statusLabel.text = @"Processing...";
                [self.purchasingStatusIndicator startAnimating];
                
                break;
                
            case SKPaymentTransactionStatePurchased:
            {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                // remove wait view and unlock feature 2
                self.statusLabel.text = @"Done!";
                UIAlertView *tmp = [[UIAlertView alloc]
                                    initWithTitle:@"Congratulations!"
                                    message:@"You are now an \nUncollectible Pro!"
                                    delegate:self
                                    cancelButtonTitle:nil
                                    otherButtonTitles:@"Ok", nil];
                [tmp show];
                
                
                NSError *error = nil;
                [SFHFKeychainUtils storeUsername:@"uncollectible@gmail.com" andPassword:@"Uncollectible46AshleyCorleone" forServiceName:kStoredData updateExisting:YES error:&error];
                
                // do other thing to enable the features
                [self.purchasingStatusIndicator stopAnimating];
                [self.proFreeBanner setImage:[UIImage imageNamed:@"ACProVersionBanner.png"]];
                
                break;
            }
            case SKPaymentTransactionStateRestored:
            {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                // remove wait view here
                self.statusLabel.text = @"";
                
                [self.purchasingStatusIndicator stopAnimating];
                break;
            }
            case SKPaymentTransactionStateFailed:
            {
                if (transaction.error.code != SKErrorPaymentCancelled) {
                    NSLog(@"Error payment cancelled: %@", transaction.error.localizedDescription);
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                // remove wait view here
                [ACUtility showACGeneralAlertMsg:@"Unsuccessful In-App Purchase \nPlease try again later" title:@"Uncollectible Pro"];
                
                
                [self.purchasingStatusIndicator stopAnimating];
                break;
            }
            default:
                break;
        }
    }
}



// UIALERTVIEW delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView==askToPurchase) {
        
        if (buttonIndex==0) {
            
            // user tapped YES, but we need to check if IAP is enabled or not.
            
            if ([SKPaymentQueue canMakePayments]) {
                
                SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"com.anthedung.uncollectible.pro"]];
                
                request.delegate = self;
                
                [request start];
                
            } else {
                UIAlertView *tmp = [[UIAlertView alloc]
                                    
                                    initWithTitle:@"Prohibited"
                                    
                                    message:@"Parental Control is enabled, cannot make a purchase!"
                                    
                                    delegate:self
                                    
                                    cancelButtonTitle:nil
                                    
                                    otherButtonTitles:@"Ok", nil];
                
                [tmp show];
            }
        }
    }
}

#pragma - Social FrameWork
- (IBAction)shareOnFacebook:(UIButton *)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"Stay cool. Stay debtless. Check out Uncollectible!"];
        [controller addImage:[UIImage imageNamed:@"Uncollectible Icon-72@2x.png"]];
        [controller addURL:[NSURL URLWithString:@"http://facebook.com/Uncollectible"]];
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

- (IBAction)shareOnTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Stay cool. Stay debtless. Check out #Uncollectible  @AnUncollectible"];
//        [tweetSheet addImage:[UIImage imageNamed:@"AppStoreLogoUncollectible.png"]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (IBAction)goToFacebookPage:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://facebook.com/Uncollectible"]];
}



#pragma - Google Plus 
- (IBAction)shareOnGooglePlus:(id)sender {
    
    // To Track Post-Sharing
    [GPPShare sharedInstance].delegate = self;
    
    // Start building the message
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
    [shareBuilder setURLToShare:[NSURL URLWithString:@"https://facebook.com/Uncollectible"]];
    
//    [shareBuilder setTitle:@"Uncollectible"
//               description:@"Stay cool. Stay debtless."
//              thumbnailURL:[NSURL URLWithString:@"http://facebook.com/Uncollectible"]];
    
    [shareBuilder setContentDeepLinkID:@"rest=1234567"];
    [shareBuilder setPrefillText:@"Stay cool. Stay debtless. Check out #Uncollectible"];
    
    [shareBuilder open];
}

// Post Sharing Handler
- (void)finishedSharing: (BOOL)shared {
    // Remove the alert for consistency
    
//    if (shared) {
//        [ACUtility showACGeneralAlertMsg:@"You've just shared on Google+" title:@"Cool"];
//    } else {
//        [ACUtility showACGeneralAlertMsg:@"Failed to share on Google+" title:@"Not cool"];
//    }
}

//- (void)takeImage:(UITapGestureRecognizer *)tgr {
//    // Initialize Image Picker Controller
//    UIImagePickerController *ip = [[UIImagePickerController alloc] init];
//    // Set Delegate
//    [ip setDelegate:self];
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        // Set Source Type to Camera
//        [ip setSourceType:UIImagePickerControllerSourceTypeCamera];
//    } else {
//        // Set Source Type to Photo Library
//        [ip setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//    }
//    // Present View Controller
//    [self presentViewController:ip animated:YES completion:nil];
//}



- (IBAction)showThankYou:(UIButton *)sender {
//    [ACUtility showACGeneralAlertMsg:@"Thank you for using Uncollectible. Give us your valued feedback at uncollectible@gmail.com!" title:@"Uncollectible"];
}

-(IBAction)deleteKeyChain:(id)sender {
    
    NSError *error = nil;
    
    [SFHFKeychainUtils deleteItemForUsername:@"uncollectible@gmail.com" andServiceName:kStoredData error:&error];
    
    NSLog(@"AC - KeyChainDeleted");
    [self.proFreeBanner setImage:[UIImage imageNamed:@"ACFreeVersionBanner.png"]];
}

- (BOOL) connectedToInternet
{
    unsigned int minNumber = 0;
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] encoding:minNumber error:nil];
    return ( URLString != NULL ) ? YES : NO;
}

@end
