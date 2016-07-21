//
//  PracticeScheduleException.m
//  Leo
//
//  Created by Zachary Drossman on 4/26/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "PracticeScheduleException.h"
#import "NSDictionary+Extensions.h"
#import "NSDate+Extensions.h"

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

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    if (!jsonDictionary) {
        return nil;
    }
    
    NSDate *startDate = [NSDate leo_dateFromDateTimeString:[jsonDictionary leo_itemForKey:APIParamStartDateTime]];
    NSDate *endDate = [NSDate leo_dateFromDateTimeString:[jsonDictionary leo_itemForKey:APIParamEndDateTime]];

    return [self initWithStartDate:startDate
                           endDate:endDate];
}

+ (NSDictionary *)serializeToJSON:(PracticeScheduleException *)object {

    NSMutableDictionary *json = [NSMutableDictionary new];
    json[APIParamStartDateTime] = [NSDate leo_stringifiedDateTime:object.startDate];
    json[APIParamEndDateTime] = [NSDate leo_stringifiedDateTime:object.endDate];
    return [json copy];
}

@end
