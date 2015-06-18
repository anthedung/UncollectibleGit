//
//  ACUtility.m
//  Uncollectible
//
//  Created by Ashley Corleone on 25/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import "ACUtility.h"
#import "SFHFKeychainUtils.h"

@implementation ACUtility


+ (void) showACGeneralAlert:(NSString *)msg{
    //Alert
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Uncollectible"]
                                                      message:msg
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

+ (void) showACGeneralAlertMsg:(NSString *)msg title:(NSString *)titleStr{
    //Alert
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:titleStr
                                                      message:msg
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

+ (NSString *)FormatDate:(NSDate *) formattingDate{
    // DATE FORMATTER
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *formattedDate = [dateFormatter stringFromDate:formattingDate];
    
    return formattedDate;
}

+ (NSString *)FormatDateNumberOnly:(NSDate *) formattingDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    
    NSString *formattedDate = [formatter stringFromDate:formattingDate];
    
    return formattedDate;
}

+ (UIColor *) GetDebtColor{
    return [UIColor redColor];
}

+ (UIColor *) GetLoanColor{
    UIColor * color = [UIColor colorWithRed:16/255.0f green:208/255.0f blue:15/255.0f alpha:1.0f];
    return color;
}

+ (UIColor *) GetUncollectibleColor{
    return [UIColor purpleColor];
}

+ (UIColor *) GetCollectedColor{
    return [UIColor blackColor];
}




@end
