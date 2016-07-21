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
#import "LEOAnalyticEvent.h"
#import "LEOAnalyticIntent.h"
#import "LEOAnalyticScreen.h"
#import "Guardian+Analytics.h"
#import "Message+Analytics.h"

@implementation LEOAnalytic (Extensions)

+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
         family:(Family *)family {

    [self tagType:type
             name:eventName
       attributes:[family analyticAttributes]];
}

+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
         family:(Family *)family
       guardian:(Guardian *)guardian {

    NSMutableDictionary *mutableAttributeDictionary = [[family analyticAttributes] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:[guardian analyticAttributes]];

    [self tagType:type
             name:eventName
       attributes:mutableAttributeDictionary];
}

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
    appointment:(Appointment *)appointment
       guardian:(Guardian *)guardian {

    NSMutableDictionary *mutableAttributeDictionary = [[appointment analyticAttributes] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:[guardian analyticAttributes]];

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
        patient:(Patient *)patient
       guardian:(Guardian *)guardian {

    NSMutableDictionary *mutableAttributeDictionary = [[patient analyticAttributes] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:[guardian analyticAttributes]];

    [self tagType:type
             name:eventName
       attributes:mutableAttributeDictionary];
}

+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
    appointment:(Appointment *)appointment
         family:(Family *)family {

    NSMutableDictionary *mutableAttributeDictionary = [[family analyticAttributes] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:[appointment analyticAttributes]];

    [self tagType:type
             name:eventName
       attributes:mutableAttributeDictionary];
}

+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
    appointment:(Appointment *)appointment
         family:(Family *)family
       guardian:(Guardian *)guardian {

    NSMutableDictionary *mutableAttributeDictionary = [[family analyticAttributes] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:[appointment analyticAttributes]];
    [mutableAttributeDictionary addEntriesFromDictionary:[guardian analyticAttributes]];

    [self tagType:type
             name:eventName
       attributes:mutableAttributeDictionary];
}

+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
         family:(Family *)family
        patient:(Patient *)patient {

    NSMutableDictionary *mutableAttributeDictionary = [[family analyticAttributes] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:[patient analyticAttributes]];

    [self tagType:type
             name:eventName
       attributes:mutableAttributeDictionary];
}

+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
         family:(Family *)family
        patient:(Patient *)patient
       guardian:(Guardian *)guardian {

    NSMutableDictionary *mutableAttributeDictionary = [[family analyticAttributes] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:[patient analyticAttributes]];
    [mutableAttributeDictionary addEntriesFromDictionary:[guardian analyticAttributes]];

    [self tagType:type
             name:eventName
       attributes:mutableAttributeDictionary];
}

+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
       guardian:(Guardian *)guardian {

    [self tagType:type
             name:eventName
       attributes:[guardian analyticAttributes]];
}

+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
        message:(Message *)message {
    
    [self tagType:type
             name:eventName
       attributes:[message analyticAttributes]];
}


@end
