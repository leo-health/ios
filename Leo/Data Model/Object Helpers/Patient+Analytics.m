//
//  Patient+Analytics.m
//  Leo
//
//  Created by Annie Graham on 7/1/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Patient+Analytics.h"

@implementation Patient (Analytics)

- (NSDictionary *)getAttributes {
    
    
    NSDictionary *attributeDictionary =
    @{@"Age group": [self ageGroup],
      @"Gender": self.gender};
    
    return attributeDictionary;
}

- (NSString *)ageGroup{
    if ([self patientIsGreaterThanOrEqualToAge:0 andUnderAge:2]) {
        
        return kAnalyticAgeGroupZeroTwo;
    } else if ([self patientIsGreaterThanOrEqualToAge:2 andUnderAge:5]){
        
        return kAnalyticAgeGroupTwoFive;
    } else if ([self patientIsGreaterThanOrEqualToAge:5 andUnderAge:13]){
        
        return kAnalyticAgeGroupFiveThirteen;
    } else if ([self patientIsGreaterThanOrEqualToAge:13 andUnderAge:18]){
        
        return kAnalyticAgeGroupThirteenEighteen;
    }
    
    return kAnalyticAgeGroupEighteenPlus;
}


- (BOOL)patientIsGreaterThanOrEqualToAge:(NSInteger)olderThan
                             andUnderAge:(NSInteger)youngerThan {
    
    NSDate *now = [NSDate date];
    NSDateComponents *dateBornAfter = [NSDateComponents new];
    NSDateComponents *dateBornBefore = [NSDateComponents new];
    dateBornAfter.year = youngerThan * -1;
    dateBornBefore.year = olderThan * -1;
    
    NSDate *bornAfter =
    [[NSCalendar currentCalendar] dateByAddingComponents: dateBornAfter
                                                  toDate: now
                                                 options:0];
    NSDate *bornBefore =
    [[NSCalendar currentCalendar] dateByAddingComponents: dateBornBefore
                                                  toDate: now
                                                 options:0];

    return ([self.dob timeIntervalSinceDate:bornAfter] > 0 && [bornBefore timeIntervalSinceDate:self.dob] > 0);
}

@end
