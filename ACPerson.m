//
//  ACPerson.m
//  Uncollectible
//
//  Created by Ashley Corleone on 25/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import "ACPerson.h"
#import "ACDebtManager.h"

@implementation ACPerson

// NSCoding:
- (void) encodeWithCoder:(NSCoder *)coder{
    [coder encodeInt32:self.personID forKey:@"personID"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.firstName forKey:@"firstName"];
    [coder encodeObject:self.lastName forKey:@"lastName"];
    [coder encodeObject:self.lastUpdatedDate forKey:@"lastUpdatedDate"];
    [coder encodeBool:(self.isOwningMe) forKey:@"isOwningMe"];
    [coder encodeObject:self.debtRecords forKey:@"debtRecords"];
    [coder encodeFloat:self.debtAmount forKey:@"debtAmount"];
}

- (id) initWithCoder:(NSCoder *)decoder{
    self = [super init];
    
    if(self){
        [self setPersonID:[decoder decodeInt32ForKey:@"personID"]];
        [self setName:[decoder decodeObjectForKey:@"name"]];
        [self setFirstName:[decoder decodeObjectForKey:@"firstName"]];
        [self setLastName:[decoder decodeObjectForKey:@"lastName"]];
        [self setLastUpdatedDate:[decoder decodeObjectForKey:@"lastUpdatedDate"]];
        [self setIsOwningMe:[decoder decodeBoolForKey:@"isOwningMe"]];
        [self setDebtRecords:[decoder decodeObjectForKey:@"debtRecords"]];
        [self setDebtAmount:[decoder decodeFloatForKey:@"debtAmount"]];
    }
    
    return self;
}

+ (ACPerson *)createNewPersonWitFirsthName:(NSString *)firstName andLastName:(NSString*) lastName andPersonID:(ABRecordID)personID{
    ACPerson *newPerson = [[ACPerson alloc] init];
    
    [newPerson setFirstName:firstName];
    [newPerson setLastName:lastName];
    NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    [newPerson setName:name];
    [newPerson setPersonID:personID];
    [newPerson setLastUpdatedDate:[NSDate date]];
    [newPerson setDebtRecords:[NSMutableArray array]];
    
    return newPerson;
}

- (void) addDebtRecord:(ACDebtRecord *)debtRecord{
    // Add to records
    [self.debtRecords insertObject:debtRecord atIndex:0];//ADD at the begining
    
    // Sort the debt Record Date:
    self.debtRecords = [ACDebtManager SortDebtRecordByDate:self.debtRecords];
    
    // Calculate new debt amount;
    self.debtAmount = [self calculateDebtAmount];
    
    // Update lastUpdated
    self.lastUpdatedDate = [NSDate date];
//    NSLog(@"%@", self);
}

- (float) calculateDebtAmount{
    int count = [self.debtRecords count];
    float sum = 0;
    
    for (int i =0 ; i < count; i++){
        ACDebtRecord *temp = (ACDebtRecord *)[self.debtRecords objectAtIndex:i];
        sum = sum + [temp debtAmount];
    }
    
    return sum;
}

- (void) reCalculateDebtAmount{
    self.debtAmount = [self calculateDebtAmount];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"ACPerson: Name=%@ debtAmt=%f lastUpdated=%@", self.name, self.debtAmount, self.lastUpdatedDate];
}
@end
