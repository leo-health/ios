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

- (instancetype)initWithObjectID:(NSString *)objectID
                            name:(NSString *)name
                           staff:(NSArray *)staff
                    addressLine1:(NSString *)addressLine1
                    addressLine2:(NSString *)addressLine2
                            city:(NSString *)city
                           state:(NSString *)state
                             zip:(NSString *)zip
                           phone:(NSString *)phone
                           email:(NSString *)email
                             fax:(NSString *)fax
                        timeZone:(NSTimeZone *)timeZone
      activeSchedulesByDayOfWeek:(NSArray *)activeSchedulesByDayOfWeek
              scheduleExceptions:(NSArray *)scheduleExceptions
                          status:(PracticeStatus)status {

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
        _status = status;
    }
    
    return self;
}

/*
        NOTE: AF

        isClosedAtThisTimeBasedOnTheActiveSchedule: and isClosedForAnExceptionAtThisTime:
        are no longer used since implementing practice change pusher events.
        Leaving them in for now in case we need them
 */
- (BOOL)isClosedAtThisTimeBasedOnTheActiveSchedule:(NSDate *)date {

    NSPredicate *dayOfWeekFilter =
    [NSPredicate predicateWithFormat:@"SELF.dayOfWeek == %d", date.weekday];

    //Find the hours for the day of the week of the date requested
    DailyPracticeSchedule *relevantHours =
    [self.activeSchedulesByDayOfWeek filteredArrayUsingPredicate:dayOfWeekFilter].firstObject;

    if (relevantHours) {

        //Get the start time and end time formatted as dates
        NSDate *startTime = [NSDate leo_timeFromHourMinuteString:relevantHours.startTimeString
                                                    withTimeZone:self.timeZone];

        NSDate *endTime = [NSDate leo_timeFromHourMinuteString:relevantHours.endTimeString
                                                  withTimeZone:self.timeZone];

        //Concatenate the date provided with the opening and closing times for that day of week
        NSDate *startDate = [NSDate dateWithYear:date.year
                                           month:date.month
                                             day:date.day
                                            hour:startTime.hour
                                          minute:startTime.minute
                                          second:0];

        NSDate *endDate = [NSDate dateWithYear:date.year
                                         month:date.month
                                           day:date.day
                                          hour:endTime.hour
                                        minute:endTime.minute
                                        second:0];

        //If the time is after closing or before opening, then the practice is closed at this time
        return [[NSDate date] isLaterThanOrEqualTo:endDate] || [[NSDate date] isEarlierThan:startDate];
    }
    
    return YES;
}

- (BOOL)isClosedForAnExceptionAtThisTime:(NSDate *)date {

    //Check to see if the date requested is in our list of exception dates
    NSPredicate *exceptionFilter =
    [NSPredicate predicateWithFormat:@"(SELF.startDate <= %@) AND (SELF.endDate >= %@)", date, date];

    NSArray *exceptionsFound =
    [self.scheduleExceptions filteredArrayUsingPredicate:exceptionFilter];

    //If it is found at least once, then the practice is closed at this time
    if (exceptionsFound.count > 0) {
        return YES;
    }

    return NO;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    if (!jsonDictionary) {
        return nil;
    }
    
    NSString *objectID = [[jsonDictionary leo_itemForKey:APIParamID] stringValue];
    
    NSArray *staffDictionaries = [jsonDictionary leo_itemForKey:APIParamUserStaff];

    NSMutableArray *staff = [[NSMutableArray alloc] init];
    
    for (NSDictionary *staffDictionary in staffDictionaries) {
        
        User *staffMember = [UserFactory userFromJSONDictionary:staffDictionary];
        [staff addObject:staffMember];
    }
    
    NSString *name = [jsonDictionary leo_itemForKey:APIParamPracticeName];
    NSString *fax = [jsonDictionary leo_itemForKey:APIParamPracticeFax];
    NSString *addressLine1 = [jsonDictionary leo_itemForKey:APIParamPracticeLocationAddressLine1];
    NSString *addressLine2 = [jsonDictionary leo_itemForKey:APIParamPracticeLocationAddressLine2];
    NSString *city = [jsonDictionary leo_itemForKey:APIParamPracticeLocationCity];
    NSString *state = [jsonDictionary leo_itemForKey:APIParamPracticeLocationState];
    NSString *zip = [jsonDictionary leo_itemForKey:APIParamPracticeLocationZip];
    NSString *phone = [jsonDictionary leo_itemForKey:APIParamPracticePhone];
    NSString *email = [jsonDictionary leo_itemForKey:APIParamPracticeEmail];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:[jsonDictionary leo_itemForKey:APIParamPracticeTimeZone]];

    NSArray *activeScheduleJSON = [[jsonDictionary leo_itemForKey:APIParamPracticeActiveSchedule] leo_itemForKey:APIParamPracticeDailyHours];
    NSArray *activeSchedulesByDayOfWeek =
    [DailyPracticeSchedule deserializeManyFromJSON:activeScheduleJSON];

    NSArray *scheduleExceptionsJSON = [jsonDictionary leo_itemForKey:APIParamPracticeScheduleExceptions];
    NSArray *scheduleExceptions = [PracticeScheduleException deserializeManyFromJSON:scheduleExceptionsJSON];

    PracticeStatus status =
    [[jsonDictionary leo_itemForKey:APIParamPracticeMessagingAvailable] boolValue] ?
    PracticeStatusOpen : PracticeStatusClosed;

    return [self initWithObjectID:objectID
                             name:name
                            staff:[staff copy]
                     addressLine1:addressLine1
                     addressLine2:addressLine2
                             city:city
                            state:state
                              zip:zip
                            phone:phone
                            email:email
                              fax:fax
                         timeZone:timeZone
       activeSchedulesByDayOfWeek:activeSchedulesByDayOfWeek
               scheduleExceptions:scheduleExceptions
                           status:status];
}

- (NSArray *)providers {

    NSPredicate *providerFilter =
    [NSPredicate predicateWithFormat:@"self isKindOfClass:%@",[Provider class]];

    return [self.staff filteredArrayUsingPredicate:providerFilter];
}

+ (NSDictionary *)serializeToJSON:(Practice *)practice {

    if (!practice) {
        return nil;
    }

    NSMutableDictionary *json = [NSMutableDictionary new];

    json[APIParamID] = practice.objectID;
    json[APIParamPracticeName] = practice.name;
    json[APIParamPracticeFax] = practice.fax;
    json[APIParamPracticeLocationAddressLine1] = practice.addressLine1;
    json[APIParamPracticeLocationAddressLine2] = practice.addressLine2;
    json[APIParamPracticeLocationCity] = practice.city;
    json[APIParamPracticeLocationState] = practice.state;
    json[APIParamPracticeLocationZip] = practice.zip;
    json[APIParamPracticePhone] = practice.phone;
    json[APIParamPracticeEmail] = practice.email;
    json[APIParamPracticeTimeZone] = practice.timeZone.name;
    json[APIParamUserStaff] = [User serializeManyToJSON:practice.staff];
    json[APIParamPracticeScheduleExceptions] = [PracticeScheduleException serializeManyToJSON:practice.scheduleExceptions];
    json[APIParamPracticeMessagingAvailable] = @(practice.status == PracticeStatusOpen);
    NSArray *schedules = [DailyPracticeSchedule serializeManyToJSON:practice.activeSchedulesByDayOfWeek];
    if (schedules) {
        json[APIParamPracticeActiveSchedule] = @{APIParamPracticeDailyHours: schedules};
    }

    return [json copy];
}

@end
