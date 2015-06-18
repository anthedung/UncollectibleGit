//
//  ACDebtRecords.h
//  Uncollectible
//
//  Created by Ashley Corleone on 25/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACDebtRecord : NSObject <NSCoding>
@property NSString *uuid;
@property NSString *name;
//@property BOOL isDebt; // else LOAN
@property float debtAmount;
@property NSDate *dateCreated;
@property NSString *debtNote;
@property BOOL isUncollectible;
@property BOOL isCollected;

+(ACDebtRecord *)createNewACDebtRecordWithName:(NSString *)name amount:(float)debtAmount andDebtNote:(NSString *)debtNote;
+(ACDebtRecord *)createNewACDebtRecordWithName:(NSString *)name amount:(float)debtAmount debtNote:(NSString *)debtNote isCollected:(BOOL) isCollected andIsUncollectible:(BOOL) isUncollectible;
- (NSString *)description;
- (BOOL) isDebt;
- (BOOL) isIpaid;
@end
