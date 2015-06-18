//
//  ACDebtManager.h
//  Uncollectible
//
//  Created by Ashley Corleone on 25/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACDebtManager : NSObject
+(NSMutableArray *)personList;
+(NSMutableArray *)personNameList;
+(void) SavePersonLists:(NSMutableArray*)updatedPersonList;
+ (void) SavePersonLists;
+ (NSMutableArray *) GetDebtorOnlyList;
+ (NSMutableArray *) GetLoanerOnlyList;
+(NSMutableArray *)uncollectedPersonList;
+ (NSMutableArray *)SortDebtRecordByDate:(NSMutableArray *)debtRecords;

+ (int) TotalNumberOfDebtRecord;
+ (int) TotalNumberPersonRecord;
+ (void) LoadPersonList;
+ (void) PrintPersonList;
@end
