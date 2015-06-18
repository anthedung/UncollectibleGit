//
//  ACPerson.h
//  Uncollectible
//
//  Created by Ashley Corleone on 25/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

/*Every record in the Address Book database has a unique record identifier. This identifier always refers to the same record, unless that record is deleted or the MobileMe sync data is reset. Record identifiers can be safely passed between threads. They are not guaranteed to remain the same across devices.
 
 The recommended way to keep a long-term reference to a particular record is to store the first and last name, or a hash of the first and last name, in addition to the identifier. When you look up a record by ID, compare the record’s name to your stored name. If they don’t match, use the stored name to find the record, and store the new ID for the record.
 
 To get the record identifier of a record, use the function ABRecordGetRecordID. To find a person record by identifier, use the function ABAddressBookGetPersonWithRecordID. To find a group by identifier, use the function ABAddressBookGetGroupWithRecordID. To find a person record by name, use the function ABAddressBookCopyPeopleWithName.
*/

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ACDebtRecord.h"

@interface ACPerson : NSObject <NSCoding>
@property ABRecordID personID;
@property NSString *firstName;
@property NSString *lastName;
@property NSString *name;
@property NSDate *lastUpdatedDate;

// If isOwningMe = true, float is positive. Else negative or I'm owning somebody some money
@property BOOL isOwningMe;

@property NSMutableArray *debtRecords;
@property float debtAmount;

+ (ACPerson *)createNewPersonWitFirsthName:(NSString *)firstName andLastName:(NSString*) lastName andPersonID:(ABRecordID)personID;
- (void) addDebtRecord:(ACDebtRecord *)debtRecord;
- (NSString *)description;
- (void) reCalculateDebtAmount;
@end
