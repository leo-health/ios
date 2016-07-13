//
//  LEOAnalyticIntent.m
//  Leo
//
//  Created by Annie Graham on 6/21/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOAnalyticIntent.h"
#import "LEOSession.h"
#import "Family.h"
#import "Family+Analytics.h"
#import "Guardian+Analytics.h"

@implementation LEOAnalyticIntent

+(NSDictionary *)attributeDictionary:(Family *)family{
    Guardian *guardian = [LEOSession user];
    
    NSDictionary *attributeDictionary =
    @{@"Number of Children" : @([family numberOfChildren]),
                           @"Age of oldest child" : @([family ageOfOldestChild]),
                           @"Age of youngest child" : @([family ageOfYoungestChild]),
                           @"Number of children older than 0 & younger than 2" : @([family numberOfChildrenZeroToTwo]),
                           @"Number of children older than 2 & younger than 5" : @([family numberOfChildrenTwoToFive]),
                           @"Number of children older than 5 & younger than 13": @([family numberOfChildrenFiveToThirteen]),
                           @"Number of children older than 13 & younger than 18": @([family numberOfChildrenThirteenToEighteen]),
                           @"Number of children older than 18": @([family numberOfChildrenEighteenOrOlder]),
                           @"Primary guardian": [guardian isPrimaryString],
                           @"Membership type": [guardian membershipTypeString]};
    return attributeDictionary;
}

@end
