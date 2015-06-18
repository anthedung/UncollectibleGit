//
//  ACUtility.h
//  Uncollectible
//
//  Created by Ashley Corleone on 25/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACUtility : NSObject
+ (void) showACGeneralAlert:(NSString *)msg;
+ (void) showACGeneralAlertMsg:(NSString *)msg title:(NSString *)titleStr;
+ (NSString *)FormatDate:(NSDate *) formattingDate;
+ (NSString *)FormatDateNumberOnly:(NSDate *) formattingDate;


+ (UIColor *) GetDebtColor;
+ (UIColor *) GetLoanColor;
+ (UIColor *) GetUncollectibleColor;
+ (UIColor *) GetCollectedColor;


@end
