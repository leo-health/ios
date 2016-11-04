//
//  PracticeSchedule.m
//  Leo
//
//  Created by Zachary Drossman on 4/26/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "DailyPracticeSchedule.h"
#import "NSDictionary+Extensions.h"
#import "NSDate+Extensions.h"
#import <DateTools/DateTools.h>

@implementation DailyPracticeSchedule

- (instancetype)initWithDayOfWeekName:(NSString *)dayOfWeekName
                      startTimeString:(NSString *)startTimeString
                        endTimeString:(NSString *)endTimeString {

    self = [super init];

    if (self) {

        _dayOfWeek = [DailyPracticeSchedule convertDayOfWeekName:dayOfWeekName];
        _dayOfWeekName = dayOfWeekName;
        _startTimeString = startTimeString;
        _endTimeString = endTimeString;
    }

    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    if (!jsonDictionary) {
        return nil;
    }

    NSString *dayOfWeekName = [jsonDictionary leo_itemForKey:APIParamDailyScheduleDayOfWeek];
    NSString *startTimeString = [jsonDictionary leo_itemForKey:APIParamDailyScheduleStartTime];
    NSString *endTimeString = [jsonDictionary leo_itemForKey:APIParamDailyScheduleEndTime];

    return [self initWithDayOfWeekName:dayOfWeekName
                       startTimeString:startTimeString
                         endTimeString:endTimeString];
}

+ (NSDictionary *)serializeToJSON:(DailyPracticeSchedule *)object {

    if (!object) {
        return nil;
    }

    NSMutableDictionary *json = [NSMutableDictionary new];

    json[APIParamDailyScheduleDayOfWeek] = object.dayOfWeekName;
    json[APIParamDailyScheduleStartTime] = object.startTimeString;
    json[APIParamDailyScheduleEndTime] = object.endTimeString;

    return [json copy];
}

+ (DayOfWeek)convertDayOfWeekName:(NSString *)dayOfWeekName {

    if ([dayOfWeekName isEqualToString:@"sunday"]) {
        return DayOfWeekSunday;
    }

    if ([dayOfWeekName isEqualToString:@"monday"]) {
        return DayOfWeekMonday;
    }

    if ([dayOfWeekName isEqualToString:@"tuesday"]) {
        return DayOfWeekTuesday;
    }

    if ([dayOfWeekName isEqualToString:@"wednesday"]) {
        return DayOfWeekWednesday;
    }

    if ([dayOfWeekName isEqualToString:@"thursday"]) {
        return DayOfWeekThursday;
    }

    if ([dayOfWeekName isEqualToString:@"friday"]) {
        return DayOfWeekFriday;
    }

    if ([dayOfWeekName isEqualToString:@"saturday"]) {
        return DayOfWeekSaturday;
    }

    return DayOfWeekUnknown;
}


@end
