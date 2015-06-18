//
//  ACAppSetting.h
//  Uncollectible
//
//  Created by Ashley Corleone on 7/5/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACAppSetting : NSObject
+ (void) setDisplayAll:(BOOL) setDisplay;
+ (BOOL) getDisplayALl;
+ (void) LoadDefaultSetting;
+ (void) setNoOfRecordsAllowed:(int) record;
+ (int) getNoOfRecordsAllowed;
+(BOOL)IAPItemPurchased;

@end
