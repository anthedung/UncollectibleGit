//
//  ACAppDelegate.m
//  Uncollectible
//
//  Created by Ashley Corleone on 25/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import "ACAppDelegate.h"
#import "ACAppSetting.h"
#import <GooglePlus/GooglePlus.h>
#import "iRate.h"

@implementation ACAppDelegate

static NSString * const kClientId = @"360772527215.apps.googleusercontent.com";

+ (void)initialize
{
    //configure iRate => Untested coz  couldnot be found on Apple Store
    [iRate sharedInstance].daysUntilPrompt = 5;
    [iRate sharedInstance].usesUntilPrompt = 15;
    [iRate sharedInstance].appStoreID = 647769735; // Optional
    //CFBridgingRetain(self).appStoreID = (unsigned int) 647769735;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // TESTFLIGHT TEAM TOKENS
//    [TestFlight takeOff:@"ce491e18646c1d5bdfe4bb4ad53d370d_MjE2MTcyMjAxMy0wNC0yNSAwNTo1MToxNi4xMDg4NDI"];
    
    // Override point for customization after application launch.
    [self customizeInterface];
    
    // GooglePlus Set app's client ID for |GPPSignIn| and |GPPShare|.
    [GPPSignIn sharedInstance].clientID = kClientId;
    
    // Planning for tab bar animation
    // UITableViewController *rootController = (UITableViewController *) self.window.rootViewController;
    
    // LOAD SETTING FIRST
    [ACAppSetting LoadDefaultSetting];
    
    //load personlist
    [ACDebtManager LoadPersonList];
    
    
    return YES;
}

#pragma - Google Plus To Track Post Sharing
- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)customizeInterface
{
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"selection-tab.png"]];
}

@end
