//
//  PracticeSchedule.h
//  Leo
//
//  Created by Zachary Drossman on 4/26/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DayOfWeek) {

    DayOfWeekUnknown = 0,
    DayOfWeekSunday = 1,
    DayOfWeekMonday = 2,
    DayOfWeekTuesday = 3,
    DayOfWeekWednesday = 4,
    DayOfWeekThursday = 5,
    DayOfWeekFriday = 6,
    DayOfWeekSaturday = 7,
};

@interface DailyPracticeSchedule : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic) DayOfWeek dayOfWeek;
@property (copy, nonatomic) NSString *dayOfWeekName;
@property (copy, nonatomic) NSString *startTimeString;
@property (copy, nonatomic) NSString *endTimeString;

- (instancetype)initWithDayOfWeekName:(NSString *)dayOfWeekName
                      startTimeString:(NSString *)startTimeString
                        endTimeString:(NSString *)endTimeString;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

+ (NSArray *)dailySchedulesFromJSONArray:(NSArray *)jsonResponse;


NS_ASSUME_NONNULL_END
@end
