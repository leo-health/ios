//
//  Family+Analytics.h
//  Leo
//
//  Created by Annie Graham on 6/20/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Family.h"

@interface Family (Analytics)

- (NSInteger)numberOfChildren;
- (NSInteger)numberOfChildrenZeroToTwo;
- (NSInteger)numberOfChildrenTwoToFive;
- (NSInteger)numberOfChildrenFiveToThirteen;
- (NSInteger)numberOfChildrenThirteenToEighteen;
- (NSInteger)numberOfChildrenEighteenOrOlder;
- (NSInteger)ageOfOldestChild;
- (NSInteger)ageOfYoungestChild;
- (NSDictionary *)attributes;

@end
