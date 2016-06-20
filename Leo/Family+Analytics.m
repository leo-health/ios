//
//  Family+Analytics.m
//  Leo
//
//  Created by Annie Graham on 6/20/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Family+Analytics.h"

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




@end
