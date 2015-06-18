//
//  ACDebtManager.m
//  Uncollectible
//
//  Created by Ashley Corleone on 25/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import "ACDebtManager.h"
#import "ACPerson.h"
static NSMutableArray *personList = nil;

@implementation ACDebtManager

+(void) initialize
{
    if (!personList) {
        [ACDebtManager LoadPersonList];
    	personList = [NSMutableArray array];
    }
}

+(NSMutableArray *)personList{
    // TO AVOID MULTIPLE LOADING => EDIT LATER => USE NOMARL GET SET, ONLY LOAD WHEN FIRST TIME
    //[ACDebtManager LoadPersonList];
    
    return personList;
}

+(NSMutableArray *)personNameList{
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableArray *tempPersons = [ACDebtManager personList] ;
    for (int i = 0 ; i < [tempPersons count]; i++){
        [tempArray addObject:[[tempPersons objectAtIndex:i] name]];
    }
    
    return tempArray;
}

+(NSMutableArray *)uncollectedPersonList{
    return [ACDebtManager GetUnCollectedOnlyList];
}
//helper
+ (void) PrintPersonList{
    for(int i = 0; i <[personList count]; i++){
//        NSLog(@"AC-PRINT_PERSON_LIST: %@", [personList objectAtIndex:i]);
    }
}

+ (void)setPersonList:(NSMutableArray *)newPersonList{
    personList = newPersonList;
}

+(NSMutableArray *)GetNewlyLoadedPersonList{
    [ACDebtManager LoadPersonList];
    return personList;
}

// init with style helper method
+ (void) LoadPersonList{
    NSString *filePath = [ACDebtManager PathForItems];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        personList = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else {
        personList = [NSMutableArray array];
    }
    
    personList = [ACDebtManager SortByDateAndZero:personList];
}

+ (NSString *) PathForItems{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [paths lastObject];
    return [document stringByAppendingPathComponent:@"personList.plist"];
}

+ (void) SavePersonLists:(NSMutableArray*)updatedPersonList{
    // SORT BY DATE
    NSMutableArray *tempPersonList = [ACDebtManager SortByDateAndZero:updatedPersonList];
    
    [ACDebtManager setPersonList:tempPersonList];
    NSString *filePath = [ACDebtManager PathForItems];
    [NSKeyedArchiver archiveRootObject:tempPersonList toFile:filePath];
}

+ (void) SavePersonLists{
    // SORT BY DATE
    NSMutableArray *tempPersonList = [ACDebtManager SortByDateAndZero:personList];

    [ACDebtManager setPersonList:tempPersonList];
    NSString *filePath = [ACDebtManager PathForItems];
    [NSKeyedArchiver archiveRootObject:tempPersonList toFile:filePath];
}

+ (NSMutableArray *) GetDebtorOnlyList{
    NSMutableArray *tempList = [NSMutableArray array];
    for (int i = 0; i < [personList count]; i++){
        if ([[personList objectAtIndex:i] debtAmount] > 0){
            [tempList addObject:[personList objectAtIndex:i]];
        }
    }
    
    return tempList;
}

+ (NSMutableArray *) GetLoanerOnlyList{
    NSMutableArray *tempList = [NSMutableArray array];
    for (int i = 0; i < [personList count]; i++){
        if ([[personList objectAtIndex:i] debtAmount] < 0){
            [tempList addObject:[personList objectAtIndex:i]];
        }
    }
    
    return tempList;
}

+ (NSMutableArray *) GetUnCollectedOnlyList{
    NSMutableArray *tempList = [NSMutableArray array];
    for (int i = 0; i < [personList count]; i++){
        if ([[personList objectAtIndex:i] debtAmount] != 0){
            [tempList addObject:[personList objectAtIndex:i]];
        }
    }
    
    return tempList;
}


// OI ME OI, BLOCK SORT SUPERPOWERFUL
+ (NSMutableArray *)SortByDate:(NSMutableArray *)personList{
    NSArray *sortedArray;
    sortedArray = [personList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(ACPerson*)a lastUpdatedDate];
        NSDate *second = [(ACPerson*)b lastUpdatedDate];
        return [second compare:first];
    }];
    
    return [NSMutableArray arrayWithArray:sortedArray];
}

// OI ME OI, BLOCK SORT SUPERPOWERFUL
+ (NSMutableArray *)SortDebtRecordByDate:(NSMutableArray *)debtRecords{
    NSArray *sortedArray;
    sortedArray = [debtRecords sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(ACDebtRecord*)a dateCreated];
        NSDate *second = [(ACDebtRecord*)b dateCreated];
        return [second compare:first];
    }];
    
    return [NSMutableArray arrayWithArray:sortedArray];
}

// OI ME OI, BLOCK SORT SUPERPOWERFUL
+ (NSMutableArray *)SortByDateReverse:(NSMutableArray *)personList{
    NSArray *sortedArray;
    sortedArray = [personList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(ACPerson*)a lastUpdatedDate];
        NSDate *second = [(ACPerson*)b lastUpdatedDate];
        return [first compare:second];
    }];
    
    return [NSMutableArray arrayWithArray:sortedArray];
}

+ (NSMutableArray *) SortByDateAndZero:(NSMutableArray *)personList{
    personList = [ACDebtManager SortByDate:personList];
    
    NSMutableArray *tempArrayWithoutZero = [NSMutableArray array];
    NSMutableArray *tempArrayWithZero = [NSMutableArray array];
    
    for (int i = 0; i < [personList count]; i++){
        ACPerson *temp = [personList objectAtIndex:i];
        if (temp.debtAmount == 0){
            [tempArrayWithZero addObject:temp];
        } else {
            [tempArrayWithoutZero addObject:temp];
        }
    }

    //SORT 2 LIST
    tempArrayWithoutZero = [ACDebtManager SortByDate:tempArrayWithoutZero];
    tempArrayWithZero = [ACDebtManager SortByDateReverse:tempArrayWithZero];
    NSArray *tempArray = [NSArray arrayWithArray:tempArrayWithZero];
    //NSArray *tempArray2 = [NSArray arrayWithArray:tempArrayWithoutZero];
    [tempArrayWithoutZero addObjectsFromArray:tempArray];
    
    return tempArrayWithoutZero;
}

+ (int) TotalNumberOfDebtRecord {
    NSMutableArray *tempArray = [ACDebtManager personList];
    
    int sum = 0;
    for (int i = 0; i < [tempArray count]; i++){
        sum = sum + [[[tempArray objectAtIndex:i] debtRecords] count];
    }
    
    //NSLog(@"AC - TOTAL NUMBER OF RECORDS: %d", sum);
    
    return sum;
}

+ (int) TotalNumberPersonRecord {
    return [personList count];
}

@end
