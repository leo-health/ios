//
//  LEOAnalyticEvent.h
//  Leo
//
//  Created by Annie Graham on 6/24/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Appointment.h"

@class Family;
@interface LEOAnalyticEvent : NSObject

+ (NSDictionary *)getAttributesWithFamily:(Family *)family;
+ (void)tagEvent:(NSString *)eventName
  withAttributes:(NSDictionary *)attributeDictionary
       andFamily:(Family *)family;
+ (void)tagEvent:(NSString *)eventName
      withFamily:(Family *)family;
+ (void)tagEvent:(NSString *)eventName
  withAttributes:(NSDictionary *)attributeDictionary;
+ (void)tagEvent:(NSString *)eventName;

+ (void)tagEvent:(NSString *)eventName
     withPatient:(Patient *)patient;

+ (void)tagEvent:(NSString *)eventName
 withAppointment:(Appointment *)appointment
  withAttributes:(NSDictionary *)attributeDictionary
       andFamily:(Family *)family;
+ (void)tagEvent:(NSString *)eventName
 withAppointment:(Appointment *)appointment
       andFamily:(Family *)family;
+ (void)tagEvent:(NSString *)eventName
 withAppointment:(Appointment *)appointment
   andAttributes:(NSDictionary *)attributeDictionary;
+ (void)tagEvent:(NSString *)eventName
 withAppointment:(Appointment *)appointment;


@end
