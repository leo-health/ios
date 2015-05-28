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

+ (Appointment * __nonnull)insertEntityWithDate:(nonnull NSDate *)date duration:(nonnull NSNumber *)duration appointmentType:(nonnull NSNumber *)leoAppointmentType patientID:(nonnull NSString *)leoPatientID providerID:(nonnull NSString *)leoProviderID familyID:(nonnull NSString *)familyID managedObjectContext:(nonnull NSManagedObjectContext *)context;
+ (Appointment * __nonnull)insertEntityWithJSONDictionary:(nonnull NSDictionary *)jsonResponse managedObjectContext:(nonnull NSManagedObjectContext *)context;

- (AppointmentState)appointmentState;
- (nonnull User *)primaryForAppointment; //FIXME: implementation makes potential for nullable...
- (nonnull User *)doctorForAppointment;
- (nonnull User *)administratorForAppointment;

- (nonnull NSString *)stringifiedAppointmentDate;
- (nonnull NSString *)stringifiedAppointmentTime;

+ (nonnull NSArray *)stringRepresentationOfActionsAvailableForState:(AppointmentState)state;
@end
