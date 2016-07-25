//
//  LEOAnalytic+Extension.h
//  Leo
//
//  Created by Annie Graham on 7/14/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOAnalytic.h"

@class Family, Appointment, Patient, Guardian, Message;

@interface LEOAnalytic (Extensions)

/**
 *  Captures analytic data of a screen, event or intent
 *  associated with an appointment.
 *
 *  @param type        The type of analytic (screen, event, intent)
 *  @param eventName   The name of the event
 *  @param appointment Appointment associated with the event
 */
+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
    appointment:(Appointment *)appointment;

/**
 *  Captures analytic data of a screen, event or intent
 *  associated with an appointment and other attributes.
 *
 *  @param type        The type of analytic (screen, event, intent)
 *  @param eventName   The name of the event
 *  @param appointment Appointment associated with the event
 *  @param attributes  Attributes associated with the event
 */
+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
    appointment:(Appointment *)appointment
     attributes:(NSDictionary *)attributes;

/**
 *  Captures analytic data of a screen, event or intent
 *  associated with a patient.
 *
 *  @param type      The type of analytic (screen, event, intent)
 *  @param eventName The name of the event
 *  @param patient   Patient associated with the event
 */
+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
        patient:(Patient *)patient;

/**
 *  Captures analytic data of a screen, event or intent
 *  associated with a message.
 *
 *  @param type      The type of analytic (screen, event, intent)
 *  @param eventName The name of the event
 *  @param message   Message associated with the event
 */
+ (void)tagType:(LEOAnalyticType)type
           name:(NSString *)eventName
        message:(Message *)message;

@end
