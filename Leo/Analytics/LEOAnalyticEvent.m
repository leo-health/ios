//
//  LEOAnalyticEvent.m
//  Leo
//
//  Created by Annie Graham on 6/24/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOAnalyticEvent.h"
#import "LEOSession.h"
#import "Guardian+Analytics.h"
#import "Appointment+Analytics.h"
#import "Patient+Analytics.h"
#import "Family+Analytics.h"
#import "Message+Analytics.h"
#import "LEOUserService.h"

@implementation LEOAnalyticEvent

+ (NSDictionary *)getAttributesWithFamily:(Family *)family {

    Guardian *guardian = [[LEOUserService new] getCurrentUser];

    NSMutableDictionary *attributeDictionary = [[family getAttributes] mutableCopy];
    [attributeDictionary addEntriesFromDictionary:[guardian getAttributes]];

    return attributeDictionary;
}

+ (void)tagEvent:(NSString *)eventName
  withAttributes:(NSDictionary *)attributeDictionary
       andFamily:(Family *)family {

    NSMutableDictionary *mutableAttributeDictionary =
    [[self getAttributesWithFamily:family] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:attributeDictionary];
    [self tagEvent:eventName
    withAttributes:mutableAttributeDictionary];
}

+ (void)tagEvent:(NSString *)eventName
  withAttributes:(NSDictionary *)attributeDictionary
      andPatient:(Patient *)patient {
    
    NSMutableDictionary *mutableAttributeDictionary = [attributeDictionary mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:[patient getAttributes]];
    [self tagEvent:eventName
    withAttributes:mutableAttributeDictionary];
}

+ (void)tagEvent:(NSString *)eventName
     withPatient:(Patient *)patient {
    [self tagEvent:eventName
    withAttributes:[patient getAttributes]];
}

+ (void)tagEvent:(NSString *)eventName
 withAppointment:(Appointment *)appointment
  withAttributes:(NSDictionary *)attributeDictionary
       andFamily:(Family *)family{
    
    NSMutableDictionary *mutableAttributeDictionary =
    [[self getAttributesWithFamily:family] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:attributeDictionary];
    [mutableAttributeDictionary addEntriesFromDictionary:[appointment getAttributes]];
    
    [self tagEvent:eventName
    withAttributes:mutableAttributeDictionary];
}

+ (void)tagEvent:(NSString *)eventName
 withAppointment:(Appointment *)appointment
       andFamily:(Family *)family{
    
    
    NSMutableDictionary *mutableAttributeDictionary = [[self getAttributesWithFamily:family] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:[appointment getAttributes]];
    
    
    [self tagEvent:eventName
    withAttributes:mutableAttributeDictionary];
}

+ (void)tagEvent:(NSString *)eventName
 withAppointment:(Appointment *)appointment
   andAttributes:(NSDictionary *)attributeDictionary{
    
    NSMutableDictionary *mutableAttributeDictionary = [attributeDictionary mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:[appointment getAttributes]];
    
    [self tagEvent:eventName
    withAttributes:mutableAttributeDictionary];
}

+ (void)tagEvent:(NSString *)eventName
 withAppointment:(Appointment *)appointment{
    [self tagEvent:eventName withAttributes:[appointment getAttributes]];
}


+ (void)tagEvent:(NSString *)eventName
      withFamily:(Family *)family {

    NSDictionary *attributeDictionary = [self getAttributesWithFamily:family];
    [self tagEvent:eventName
    withAttributes:attributeDictionary];
}

+ (void)tagEvent:(NSString *)eventName
  withAttributes:(NSDictionary *)attributeDictionary {

    [Localytics tagEvent:eventName
              attributes:attributeDictionary];
}

+ (void)tagEvent:(NSString *)eventName {
    [self tagEvent:eventName
    withAttributes:nil];
}

+ (void)tagEvent:(NSString *)eventName
     withMessage:(Message *)message{

    NSDictionary *attributeDictionary = [message getAttributes];
    [self tagEvent:eventName
    withAttributes:attributeDictionary];
}


@end
