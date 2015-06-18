//
//  ACDebtRecords.m
//  Uncollectible
//
//  Created by Ashley Corleone on 25/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import "ACDebtRecord.h"

@implementation ACDebtRecord

// NSCoding:
- (void) encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.uuid forKey:@"uuid"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeFloat:self.debtAmount forKey:@"debtAmount"];
    [coder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [coder encodeObject:self.debtNote forKey:@"debtNote"];
    [coder encodeBool:self.isUncollectible forKey:@"isUncollectible"];
    [coder encodeBool:self.isCollected forKey:@"isCollected"];
}

- (id) initWithCoder:(NSCoder *)decoder{
    self = [super init];
    
    if(self){
        [self setUuid:[decoder decodeObjectForKey:@"uuid"]];
        [self setName:[decoder decodeObjectForKey:@"name"]];
        [self setDateCreated:[decoder decodeObjectForKey:@"dateCreated"]];
        [self setDebtAmount:[decoder decodeFloatForKey:@"debtAmount"]];
        [self setDebtNote:[decoder decodeObjectForKey:@"debtNote"]];
        [self setIsUncollectible:[decoder decodeBoolForKey:@"isUncollectible"]];
        [self setIsCollected:[decoder decodeBoolForKey:@"isCollected"]];
    }
    
    return self;
}

+(ACDebtRecord *)createNewACDebtRecordWithName:(NSString *)name amount:(float)debtAmount andDebtNote:(NSString *)debtNote{
    ACDebtRecord *debtRecord = [[ACDebtRecord alloc] init];
    
    [debtRecord setUuid:[[NSUUID UUID] UUIDString]];
    [debtRecord setName:name];
    [debtRecord setDebtAmount:debtAmount];
    [debtRecord setDateCreated:[NSDate date]];
    [debtRecord setDebtNote:debtNote];
    [debtRecord setIsUncollectible:FALSE];
    return debtRecord;
}

+(ACDebtRecord *)createNewACDebtRecordWithName:(NSString *)name amount:(float)debtAmount debtNote:(NSString *)debtNote isCollected:(BOOL) isCollected andIsUncollectible:(BOOL) isUncollectible {
    ACDebtRecord *debtRecord = [[ACDebtRecord alloc] init];
    
    [debtRecord setUuid:[[NSUUID UUID] UUIDString]];
    [debtRecord setName:name];
    [debtRecord setDebtAmount:debtAmount];
    [debtRecord setDateCreated:[NSDate date]];
    [debtRecord setDebtNote:debtNote];
    [debtRecord setIsUncollectible:isUncollectible];
    [debtRecord setIsCollected:isCollected];
    return debtRecord;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"DebtRecord: Name=%@ debtAmt=%f dateCreated=%@ debtNote=%@", self.name, self.debtAmount, self.dateCreated, self.debtNote];
}

- (BOOL) isDebt {
    if (self.debtAmount > 0) {
        return TRUE;
    } else {
        return FALSE;
    }
}

- (BOOL) isIpaid{
    if(self.isCollected && self.debtAmount <0){
        return TRUE;
    } else {
        return FALSE;
    }
}
@end
