//
//  Appointment+Methods.h
//  
//
//  Created by Zachary Drossman on 5/14/15.
//
//

#import "Appointment.h"

@interface Appointment (Methods)

+ (Appointment * __nonnull)insertEntityWithDate:(nonnull NSDate *)date startTime:(nonnull NSDate *)startTime duration:(nonnull NSNumber *)duration appointmentType:(nonnull NSString *)leoAppointmentType patientID:(nonnull NSNumber *)leoPatientID providerID:(nonnull NSNumber *)leoProviderID familyID:(nonnull NSNumber *)familyID managedObjectContext:(nonnull NSManagedObjectContext *)context;
+ (Appointment * __nonnull)insertEntityWithJSONDictionary:(nonnull NSDictionary *)jsonResponse managedObjectContext:(nonnull NSManagedObjectContext *)context;

@end
