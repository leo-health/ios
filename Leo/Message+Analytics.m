//
//  Message+Analytics.m
//  Leo
//
//  Created by Annie Graham on 7/13/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Message+Analytics.h"

@implementation Message (Analytics)

- (NSDictionary *)getAttributes {

    NSDictionary *attributeDictionary =
    @{ @"Time of day": [self timeOfDay],
      @"Day of week": [self dayOfWeek],
      };

    return attributeDictionary;
}

- (NSString *)timeOfDay {

    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *components = [calendar components:NSCalendarUnitHour
                                               fromDate:[NSDate date]];

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

- (NSString *)dayOfWeek {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE"];

    return [formatter stringFromDate:[NSDate date]];
}


@end
