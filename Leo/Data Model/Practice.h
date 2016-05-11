//
//  Practice.h
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PracticeStatus) {

    PracticeStatusOpen,
    PracticeStatusClosed
};

@interface Practice : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (copy, nonatomic) NSString *objectID;
@property (copy, nonatomic, readonly) NSArray *staff;
@property (copy, nonatomic, readonly) NSArray *providers;
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *addressLine1;
@property (copy, nonatomic, readonly) NSString *addressLine2;
@property (copy, nonatomic, readonly) NSString *city;
@property (copy, nonatomic, readonly) NSString *state;
@property (copy, nonatomic, readonly) NSString *zip;
@property (copy, nonatomic, readonly) NSString *phone;
@property (copy, nonatomic, readonly) NSString *email;
@property (copy, nonatomic, readonly) NSString *fax;
@property (strong, nonatomic) NSTimeZone *timeZone;
@property (copy, nonatomic) NSArray *activeSchedulesByDayOfWeek;
@property (copy, nonatomic) NSArray *scheduleExceptions;
@property (nonatomic) PracticeStatus status;

- (instancetype)initWithObjectID:(NSString *)objectID name:(NSString *)name staff:(NSArray *)staff addressLine1:(NSString *)addressLine1 addressLine2:(NSString *)addressLine2 city:(NSString *)city state:(NSString *)state zip:(NSString *)zip phone:(NSString *)phone email:(NSString *)email fax:(NSString *)fax timeZone:(NSTimeZone *)timeZone activeSchedulesByDayOfWeek:(NSArray *)activeSchedulesByDayOfWeek scheduleExceptions:(NSArray *)scheduleExceptions;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

NS_ASSUME_NONNULL_END
@end
