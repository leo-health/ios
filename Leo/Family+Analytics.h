//
//  Family+Analytics.h
//  Leo
//
//  Created by Annie Graham on 6/20/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Family.h"

@interface Family (Analytics)

- (int)numberOfChildren;
- (int)numberOfChildrenZeroToTwo;
- (int)numberOfChildrenTwoToFive;
- (int)numberOfChildrenFiveToThirteen;
- (int)numberOfChildrenThirteenToEighteen;
- (int)numberOfChildrenEighteenOrOlder;

@end
