//
//  Family+Analytics.m
//  Leo
//
//  Created by Annie Graham on 6/20/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Family+Analytics.h"
#import "Patient.h"

@implementation Family (Analytics)

- (int)numberOfChildren{
    int numberOfPatients = (int)[self.patients count];
    return numberOfPatients;
}


- (int)numberOfPatientsBetweenAge:(int)olderThan andAge:(int)youngerThan{
    NSArray *patients = self.patients;
    NSDate *now = [NSDate date];
    NSDateComponents *dateBornAfter = [NSDateComponents new];
    NSDateComponents *dateBornBefore = [NSDateComponents new];
    dateBornAfter.year = youngerThan * -1;
    dateBornBefore.year = olderThan * -1;
    NSDate *bornAfter = [[NSCalendar currentCalendar] dateByAddingComponents: dateBornAfter
                                                                        toDate: now
                                                                       options:0];
    NSDate *bornBefore = [[NSCalendar currentCalendar] dateByAddingComponents: dateBornBefore
                                                                        toDate: now
                                                                       options:0];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dob >= %@ AND dob < %@", bornAfter, bornBefore];
    NSArray *patientsInAgeRange = [patients filteredArrayUsingPredicate:predicate];
    return (int)[patientsInAgeRange count];
}

- (int)numberOfChildrenZeroToTwo{
    return [self numberOfPatientsBetweenAge:0 andAge: 2];
}

- (int)numberOfChildrenTwoToFive{
    return [self numberOfPatientsBetweenAge:2 andAge: 5];
}

- (int)numberOfChildrenFiveToThirteen{
    return [self numberOfPatientsBetweenAge:5 andAge: 13];
}

- (int)numberOfChildrenThirteenToEighteen{
    return [self numberOfPatientsBetweenAge:13 andAge: 18];
}

- (int)numberOfChildrenEighteenOrOlder{
    return [self numberOfPatientsBetweenAge:18 andAge: 26];
}

- (int)calculateAgeFromDOB:(NSDate*)dob{
    NSDate *now = [NSDate date];
    NSDateComponents *dobToPresent = [[NSCalendar currentCalendar]
                                      components: NSCalendarUnitYear
                                      fromDate:dob
                                      toDate:now
                                      options:0];
    return (int)dobToPresent.year;
}

- (NSArray*)youngestToOldest{
    NSArray *children = self.patients;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dob" ascending:NO];
    NSArray *youngestToOldest = [children sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    return youngestToOldest;
}

- (int)ageOfOldestChild{
    NSArray *youngestToOldest = [self youngestToOldest];
    Patient *oldest = [youngestToOldest lastObject];
    NSDate *dob = [oldest dob];
    int yearsOld = [self calculateAgeFromDOB:dob];
    return yearsOld;
}

- (int)ageOfYoungestChild{
    NSArray *youngestToOldest = [self youngestToOldest];
    Patient *youngest = youngestToOldest[0];
    NSDate *dob = [youngest dob];
    int yearsOld = [self calculateAgeFromDOB:dob];
    return yearsOld;
}






@end
