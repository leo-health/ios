//
//  LEOAnalytic+Extension.m
//  Leo
//
//  Created by Annie Graham on 7/14/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOAnalytic+Extensions.h"
#import "Patient+Analytics.h"
#import "Appointment+Analytics.h"
#import "Family+Analytics.h"
#import "p_LEOAnalyticEvent.h"
#import "p_LEOAnalyticIntent.h"
#import "p_LEOAnalyticScreen.h"
#import "Guardian+Analytics.h"
#import "Message+Analytics.h"

@implementation LEOAnalytic (Extensions)

+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
    appointment:(Appointment *)appointment {

    [self tagType:type
             name:eventName
       attributes:[appointment analyticAttributes]];
}

+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
    appointment:(Appointment *)appointment
     attributes:(NSDictionary *)attributes{

    NSMutableDictionary *mutableAttributeDictionary = [[appointment analyticAttributes] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:attributes];

    [self tagType:type
             name:eventName
       attributes:mutableAttributeDictionary];
}

+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
        patient:(Patient *)patient {

    [self tagType:type
             name:eventName
       attributes:[patient analyticAttributes]];
}

+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
        message:(Message *)message {
    
    [self tagType:type
             name:eventName
       attributes:[message analyticAttributes]];
}


@end
