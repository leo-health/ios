//
//  PracticeScheduleException.m
//  Leo
//
//  Created by Zachary Drossman on 4/26/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "PracticeScheduleException.h"
#import "NSDictionary+Extensions.h"

@implementation PracticeScheduleException

- (instancetype)initWithStartDate:(NSDate *)startDate
                          endDate:(NSDate *)endDate {

    self = [super init];

    if (self) {

        _startDate = startDate;
        _endDate = endDate;
    }

    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {

    NSDate *startDate = [jsonResponse leo_itemForKey:@"start_date"];
    NSDate *endDate = [jsonResponse leo_itemForKey:@"end_date"];

    return [self initWithStartDate:startDate
                           endDate:endDate];
}

+ (NSArray *)exceptionsWithJSONArray:(NSArray *)jsonResponse {

    NSMutableArray *mutableExceptions = [NSMutableArray new];

    for (NSDictionary *exceptionDictionary in jsonResponse) {

        PracticeScheduleException *exception =
        [[self alloc] initWithJSONDictionary:exceptionDictionary];
        
        [mutableExceptions addObject:exception];
    }

    return [mutableExceptions copy];
}

@end
