//
//  Appointment+Methods.h
//  
//
//  Created by Zachary Drossman on 5/14/15.
//
//

#import "Appointment.h"

typedef enum AppointmentState : NSUInteger {
    AppointmentStateBooking = 0,
    AppointmentStateCancelling = 1,
    AppointmentStateConfirmingCancelling = 2,
    AppointmentStateRecommending = 3,
    AppointmentStateReminding = 4,
} AppointmentState;

//typedef enum AppointmentType : NSUInteger {
//    AppointmentTypeWell = 0,
//    AppointmentTypeSick = 1,
//    AppointmentTypeFollowup = 2,
//    AppointmentTypeUndefined = 3
//} AppointmentType;

@interface Appointment (Methods)

+ (Appointment * __nonnull)insertEntityWithDate:(nullable NSDate *)date appointmentType:(nonnull NSNumber *)leoAppointmentType patient:(nonnull User *)patient provider:(nonnull User *)provider familyID:(nonnull NSString *)familyID bookedByUser:(nonnull User *)bookedByUser state:(nonnull NSNumber *)state managedObjectContext:(nonnull NSManagedObjectContext *)context;

+ (Appointment * __nonnull)insertEntityWithJSONDictionary:(nonnull NSDictionary *)jsonResponse managedObjectContext:(nonnull NSManagedObjectContext *)context;

- (AppointmentState)appointmentState;

- (nonnull NSString *)stringifiedAppointmentDate;
- (nonnull NSString *)stringifiedAppointmentTime;

//+ (nonnull NSArray *)stringRepresentationOfActionsAvailableForState:(AppointmentState)state;
@end
