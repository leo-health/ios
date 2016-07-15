//
//  LEOAnalytic+Extension.m
//  Leo
//
//  Created by Annie Graham on 7/14/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOAnalytic+Extension.h"
#import "Patient+Analytics.h"
#import "Appointment+Analytics.h"
#import "Family+Analytics.h"
#import "LEOAnalyticEvent.h"
#import "LEOAnalyticIntent.h"
#import "LEOAnalyticScreen.h"
#import "Guardian+Analytics.h"
#import "Message+Analytics.h"

@implementation LEOAnalytic (Extension)

+ (void)tagType:(LEOAnalyticType)type
      eventName:(NSString *)eventName
         family:(Family *)family {

    switch(type){

        case LEOAnalyticTypeEvent:
            [LEOAnalyticEvent tagEvent:eventName
                        attributes:[family attributes]];
            break;

        case LEOAnalyticTypeIntent:
            [LEOAnalyticIntent tagEvent:eventName
                         attributes:[family attributes]];
            break;

        case LEOAnalyticTypeScreen:
            [LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}

+ (void)tagType:(LEOAnalyticType)type
      eventName:(NSString *)eventName
         family:(Family *)family
       guardian:(Guardian *)guardian {

    NSMutableDictionary *mutableAttributeDictionary = [[family attributes] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:[guardian attributes]];

    switch(type){

        case LEOAnalyticTypeEvent:

            [LEOAnalyticEvent tagEvent:eventName
                            attributes:mutableAttributeDictionary];
            break;

        case LEOAnalyticTypeIntent:

            [LEOAnalyticIntent tagEvent:eventName
                             attributes:mutableAttributeDictionary];
            break;

        case LEOAnalyticTypeScreen:

            [LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}

+ (void)tagType:(LEOAnalyticType)type
      eventName:(NSString *)eventName
    appointment:(Appointment *)appointment {

    switch(type){

        case LEOAnalyticTypeEvent:

            [LEOAnalyticEvent tagEvent:eventName
                            attributes:[appointment attributes]];
            break;
        case LEOAnalyticTypeIntent:

            [LEOAnalyticIntent tagEvent:eventName
                             attributes:[appointment attributes]];
            break;
        case LEOAnalyticTypeScreen:

            [LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}

+ (void)tagType:(LEOAnalyticType)type
      eventName:(NSString *)eventName
    appointment:(Appointment *)appointment
     attributes:(NSDictionary *)attributes{

    NSMutableDictionary *mutableAttributeDictionary = [[appointment attributes] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:attributes];

    switch(type){

        case LEOAnalyticTypeEvent:

            [LEOAnalyticEvent tagEvent:eventName
                            attributes:mutableAttributeDictionary];
            break;
        case LEOAnalyticTypeIntent:

            [LEOAnalyticIntent tagEvent:eventName
                             attributes:mutableAttributeDictionary];
            break;
        case LEOAnalyticTypeScreen:

            [LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}

+ (void)tagType:(LEOAnalyticType)type
      eventName:(NSString *)eventName
    appointment:(Appointment *)appointment
       guardian:(Guardian *)guardian {

    NSMutableDictionary *mutableAttributeDictionary = [[appointment attributes] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:[guardian attributes]];

    switch(type){

        case LEOAnalyticTypeEvent:

            [LEOAnalyticEvent tagEvent:eventName
                            attributes:mutableAttributeDictionary];
            break;
        case LEOAnalyticTypeIntent:

            [LEOAnalyticIntent tagEvent:eventName
                             attributes:mutableAttributeDictionary];
            break;
        case LEOAnalyticTypeScreen:
            [LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}

+ (void)tagType:(LEOAnalyticType)type
      eventName:(NSString *)eventName
        patient:(Patient *)patient {

    switch(type){

        case LEOAnalyticTypeEvent:

            [LEOAnalyticEvent tagEvent:eventName
                            attributes:[patient attributes]];
            break;
        case LEOAnalyticTypeIntent:

            [LEOAnalyticIntent tagEvent:eventName
                             attributes:[patient attributes]];
            break;
        case LEOAnalyticTypeScreen:

            [LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}

+ (void)tagType:(LEOAnalyticType)type
      eventName:(NSString *)eventName
        patient:(Patient *)patient
       guardian:(Guardian *)guardian {

    NSMutableDictionary *mutableAttributeDictionary = [[patient attributes] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:[guardian attributes]];

    switch(type){

        case LEOAnalyticTypeEvent:

            [LEOAnalyticEvent tagEvent:eventName
                            attributes:mutableAttributeDictionary];
            break;
        case LEOAnalyticTypeIntent:

            [LEOAnalyticIntent tagEvent:eventName
                             attributes:mutableAttributeDictionary];
            break;

        case LEOAnalyticTypeScreen:

            [LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}

+ (void)tagType:(LEOAnalyticType)type
      eventName:(NSString *)eventName
    appointment:(Appointment *)appointment
         family:(Family *)family {

    NSMutableDictionary *mutableAttributeDictionary = [[family attributes] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:[appointment attributes]];

    switch(type){

        case LEOAnalyticTypeEvent:

            [LEOAnalyticEvent tagEvent:eventName
                            attributes:mutableAttributeDictionary];
            break;

        case LEOAnalyticTypeIntent:

            [LEOAnalyticIntent tagEvent:eventName
                             attributes:mutableAttributeDictionary];
            break;

        case LEOAnalyticTypeScreen:

            [LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}

+ (void)tagType:(LEOAnalyticType)type
      eventName:(NSString *)eventName
    appointment:(Appointment *)appointment
        family:(Family *)family
       guardian:(Guardian *)guardian {

    NSMutableDictionary *mutableAttributeDictionary = [[family attributes] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:[appointment attributes]];
    [mutableAttributeDictionary addEntriesFromDictionary:[guardian attributes]];

    switch(type){

        case LEOAnalyticTypeEvent:

            [LEOAnalyticEvent tagEvent:eventName
                            attributes:mutableAttributeDictionary];
            break;

        case LEOAnalyticTypeIntent:

            [LEOAnalyticIntent tagEvent:eventName
                             attributes:mutableAttributeDictionary];
            break;

        case LEOAnalyticTypeScreen:

            [LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}

+ (void)tagType:(LEOAnalyticType)type
      eventName:(NSString *)eventName
         family:(Family *)family
        patient:(Patient *)patient {

    NSMutableDictionary *mutableAttributeDictionary = [[family attributes] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:[patient attributes]];

    switch(type){

        case LEOAnalyticTypeEvent:

            [LEOAnalyticEvent tagEvent:eventName
             attributes:mutableAttributeDictionary];
            break;

        case LEOAnalyticTypeIntent:

            [LEOAnalyticIntent tagEvent:eventName
                             attributes:mutableAttributeDictionary];
            break;

        case LEOAnalyticTypeScreen:

            [LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}

+ (void)tagType:(LEOAnalyticType)type
      eventName:(NSString *)eventName
         family:(Family *)family
        patient:(Patient *)patient
       guardian:(Guardian *)guardian {

    NSMutableDictionary *mutableAttributeDictionary = [[family attributes] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:[patient attributes]];
    [mutableAttributeDictionary addEntriesFromDictionary:[guardian attributes]];

    switch(type){

        case LEOAnalyticTypeEvent:

            [LEOAnalyticEvent tagEvent:eventName
                            attributes:mutableAttributeDictionary];
            break;

        case LEOAnalyticTypeIntent:

            [LEOAnalyticIntent tagEvent:eventName
                             attributes:mutableAttributeDictionary];
            break;

        case LEOAnalyticTypeScreen:

            [LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}

+ (void)tagType:(LEOAnalyticType)type
      eventName:(NSString *)eventName
       guardian:(Guardian *)guardian {

    switch(type){

        case LEOAnalyticTypeEvent:

            [LEOAnalyticEvent tagEvent:eventName
                            attributes:[guardian attributes]];
            break;

        case LEOAnalyticTypeIntent:

            [LEOAnalyticIntent tagEvent:eventName
                             attributes:[guardian attributes]];
            break;

        case LEOAnalyticTypeScreen:

            [LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}

+ (void)tagType:(LEOAnalyticType)type
      eventName:(NSString *)eventName
       message:(Message *)message {

    switch(type){

        case LEOAnalyticTypeEvent:

            [LEOAnalyticEvent tagEvent:eventName
                            attributes:[message attributes]];
            break;

        case LEOAnalyticTypeIntent:

            [LEOAnalyticIntent tagEvent:eventName
                             attributes:[message attributes]];
            break;

        case LEOAnalyticTypeScreen:

            [LEOAnalyticScreen tagScreen:eventName];
            break;
    }
}


@end
