//
//  ACAppSetting.m
//  Uncollectible
//
//  Created by Ashley Corleone on 7/5/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import "ACAppSetting.h"
#import "SFHFKeychainUtils.h"

static int NoOfRecordsAllowed;
static BOOL displayAll;

@implementation ACAppSetting
#define kStoredData @"com.anthedung.uncollectible.pro"

+ (void) setDisplayAll:(BOOL) setDisplay{
    displayAll = setDisplay;
}
+ (BOOL) getDisplayALl{
    return displayAll;
}

+ (void) LoadDefaultSetting{
    displayAll = TRUE;
    
    if ([ACAppSetting IAPItemPurchased]){
        NoOfRecordsAllowed = -1;
    } else {
        NoOfRecordsAllowed = 7;
    }
}

+ (void) setNoOfRecordsAllowed:(int) record{
    NoOfRecordsAllowed = record;
}

+ (int) getNoOfRecordsAllowed{
    return NoOfRecordsAllowed;
}

+(BOOL)IAPItemPurchased {
    
    NSError *error = nil;
    
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:@"uncollectible@gmail.com" andServiceName:kStoredData error:&error];
    
    if ([password isEqualToString:@"Uncollectible46AshleyCorleone"]) return YES; else return NO;
}


@end
