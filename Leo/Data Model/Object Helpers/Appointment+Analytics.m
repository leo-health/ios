//
//  Appointment+Analytics.m
//  Leo
//
//  Created by Annie Graham on 7/1/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Appointment+Analytics.h"
#import "Patient+Analytics.h"
#import "Appointment.h"
#import "AppointmentType.h"
#import "Guardian.h"

@implementation Appointment (Analytics)

- (NSDictionary *)analyticAttributes {
    
    NSMutableDictionary *mutableAttributeDictionary= [[self.patient analyticAttributes] mutableCopy];
    
    NSDictionary *appointmentDictionary =
    @{@"Visit type": self.appointmentType.name,
      @"Time of day": [self timeOfDay],
      @"Number of days booked in advance": @([self daysBookedInAdvance]),
      @"Day of week": [self dayOfWeek],
      };
    
    [mutableAttributeDictionary addEntriesFromDictionary:appointmentDictionary];
    
    return [mutableAttributeDictionary copy];
}

- (NSString *)timeOfDay {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitHour
                                               fromDate:self.date];
    
    NSInteger hour = [components hour];
    
    if (hour < 11) {
        return @"Morning";
    } else if (hour < 13) {
        return @"Midday";
    } else if (hour < 16) {
        return @"Afternoon";
    }
    return @"Evening";
}

- (NSInteger)daysBookedInAdvance {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *today = [calendar dateBySettingHour:10 minute:0 second:0 ofDate:[NSDate date] options:0];
    NSDate *appointmentDay = [calendar dateBySettingHour:10 minute:0 second:0 ofDate:self.date options:0];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:today
                                                 toDate:appointmentDay options:0];
    
    return [difference day];
}

- (NSString *)dayOfWeek {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE"];
    
    return [formatter stringFromDate:self.date];
}


@end
