//
//  Practice.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Practice.h"
#import "Provider.h"
#import "Support.h"
#import "UserFactory.h"
#import "NSDictionary+Extensions.h"
#import "NSDate+Extensions.h"
#import <NSDate+DateTools.h>
#import "DailyPracticeSchedule.h"
#import "PracticeScheduleException.h"

@implementation Practice

//TODO: Having this and using it in Practice is a code smell. Return to this and determine whether a change to the model might be ideal.
static NSString *const RoleProvider = @"clinical";

- (instancetype)initWithObjectID:(NSString *)objectID name:(NSString *)name staff:(NSArray *)staff addressLine1:(NSString *)addressLine1 addressLine2:(NSString *)addressLine2 city:(NSString *)city state:(NSString *)state zip:(NSString *)zip phone:(NSString *)phone email:(NSString *)email fax:(NSString *)fax timeZone:(NSTimeZone *)timeZone activeSchedulesByDayOfWeek:(NSArray *)activeSchedulesByDayOfWeek scheduleExceptions:(NSArray *)scheduleExceptions {

    self = [super init];
    
    if (self) {

        _objectID = objectID;
        _name = name;
        _staff = staff;
        _addressLine1 = addressLine1;
        _addressLine2 = addressLine2;
        _city = city;
        _state = state;
        _zip = zip;
        _phone = phone;
        _email = email;
        _fax = fax;
        _timeZone = timeZone;

        _activeSchedulesByDayOfWeek = activeSchedulesByDayOfWeek;
        _scheduleExceptions = scheduleExceptions;
    }
    
    return self;
}

- (PracticeStatus)status {

    DayOfWeek dayOfWeek = [NSDate date].weekday;

    NSPredicate *dayOfWeekFilter = [NSPredicate predicateWithFormat:@"SELF.dayOfWeek == %d", dayOfWeek];

    DailyPracticeSchedule *relevantHours = [self.activeSchedulesByDayOfWeek filteredArrayUsingPredicate:dayOfWeekFilter][0];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"America/New_York"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"HH:mm"];

    NSDate *startTime = [formatter dateFromString:relevantHours.startTimeString];
    NSDate *endTime = [formatter dateFromString:relevantHours.endTimeString];

    NSDate *startDate = [NSDate dateWithYear:[NSDate date].year month:[NSDate date].month day:[NSDate date].day hour:startTime.hour minute:startTime.minute second:0];
    NSDate *endDate = [NSDate dateWithYear:[NSDate date].year month:[NSDate date].month day:[NSDate date].day hour:endTime.hour minute:endTime.minute second:0];

    if ([[NSDate date] isLaterThanOrEqualTo:endDate] || [[NSDate date] isEarlierThan:startDate]) {
        return PracticeStatusClosed;
    }

    NSPredicate *exceptionFilter = [NSPredicate predicateWithFormat:@"(SELF.startDate <= %@) AND (SELF.endDate >= %@)", [NSDate date], [NSDate date]];

    NSArray *exceptionsFound = [self.scheduleExceptions filteredArrayUsingPredicate:exceptionFilter];

    if (exceptionsFound.count > 0) {
        return PracticeStatusClosed;
    }

    return PracticeStatusOpen;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *objectID = [[jsonResponse leo_itemForKey:APIParamID] stringValue];
    
    NSArray *staffDictionaries = [jsonResponse leo_itemForKey:APIParamUserStaff];

    NSMutableArray *staff = [[NSMutableArray alloc] init];
    
    for (NSDictionary *staffDictionary in staffDictionaries) {
        
        User *staffMember = [UserFactory userFromJSONDictionary:staffDictionary];
        [staff addObject:staffMember];
    }
    
    NSString *name = [jsonResponse leo_itemForKey:APIParamPracticeName];
    NSString *fax = [jsonResponse leo_itemForKey:APIParamPracticeFax];
    
    NSString *addressLine1 = [jsonResponse leo_itemForKey:APIParamPracticeLocationAddressLine1];
    NSString *addressLine2 = [jsonResponse leo_itemForKey:APIParamPracticeLocationAddressLine2];
    NSString *city = [jsonResponse leo_itemForKey:APIParamPracticeLocationCity];
    NSString *state = [jsonResponse leo_itemForKey:APIParamPracticeLocationState];
    NSString *zip = [jsonResponse leo_itemForKey:APIParamPracticeLocationZip];
    NSString *phone = [jsonResponse leo_itemForKey:APIParamPracticePhone];
    NSString *email = [jsonResponse leo_itemForKey:APIParamPracticeEmail];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:[jsonResponse leo_itemForKey:APIParamPracticeTimeZone]];

    //FIXME: Need to get APIParams for above to complete this and remove warning.

    NSArray *activeScheduleJSON = [jsonResponse leo_itemForKey:APIParamPracticeActiveSchedule];

    NSArray *activeSchedulesByDayOfWeek =
    [DailyPracticeSchedule dailySchedulesFromJSONArray:activeScheduleJSON];

    NSArray *scheduleExceptionsJSON = [jsonResponse leo_itemForKey:APIParamPracticeScheduleExceptions];

    NSArray *scheduleExceptions = [PracticeScheduleException exceptionsWithJSONArray:scheduleExceptionsJSON];

    return [self initWithObjectID:objectID name:name staff:[staff copy] addressLine1:addressLine1 addressLine2:addressLine2 city:city state:state zip:zip phone:phone email:email fax:fax timeZone:timeZone activeSchedulesByDayOfWeek:activeSchedulesByDayOfWeek scheduleExceptions:scheduleExceptions];
}

- (NSArray *)providers {

    NSPredicate *providerFilter = [NSPredicate predicateWithFormat:@"self isKindOfClass:%@",[Provider class]];
    return [self.staff filteredArrayUsingPredicate:providerFilter];
}

@end
