//
//  Appointment+Methods.h
//  
//
//  Created by Zachary Drossman on 5/14/15.
//
//

#import "Appointment.h"

typedef enum AppointmentState : NSUInteger {
    AppointmentStateBooking,
    AppointmentStateCancelling,
    AppointmentStateConfirmingCancelling,
    AppointmentStateRecommending,
    AppointmentStateReminding
} AppointmentState;

@interface Appointment (Methods)

+ (Appointment * __nonnull)insertEntityWithDate:(nonnull NSDate *)date duration:(nonnull NSNumber *)duration appointmentType:(nonnull NSNumber *)leoAppointmentType patient:(nonnull User *)patient provider:(nonnull User *)provider familyID:(nonnull NSString *)familyID bookedByUser:(nonnull User *)bookedByUser managedObjectContext:(nonnull NSManagedObjectContext *)context;

+ (Appointment * __nonnull)insertEntityWithJSONDictionary:(nonnull NSDictionary *)jsonResponse managedObjectContext:(nonnull NSManagedObjectContext *)context;

- (AppointmentState)appointmentState;

- (nonnull NSString *)stringifiedAppointmentDate;
- (nonnull NSString *)stringifiedAppointmentTime;

//+ (nonnull NSArray *)stringRepresentationOfActionsAvailableForState:(AppointmentState)state;
@end
