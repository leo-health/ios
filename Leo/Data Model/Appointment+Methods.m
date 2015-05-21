//
//  Appointment+Methods.m
//  
//
//  Created by Zachary Drossman on 5/14/15.
//
//

#import "Appointment+Methods.h"
#import "LEOConstants.h"

//@property (nonatomic, retain) NSNumber * bookedByUserID;
//@property (nonatomic, retain) NSDate * createdAt;
//@property (nonatomic, retain) NSNumber * familyID;
//@property (nonatomic, retain) NSNumber * rescheduledAppointmentID;
//@property (nonatomic, retain) NSString * status;
//@property (nonatomic, retain) NSDate * updatedAt;
//@property (nonatomic, retain) NSSet *users;

@implementation Appointment (Methods)


+ (Appointment * __nonnull)insertEntityWithDate:(nonnull NSDate *)date startTime:(nonnull NSDate *)startTime duration:(nonnull NSNumber *)duration appointmentType:(nonnull NSString *)leoAppointmentType patientID:(nonnull NSNumber *)leoPatientID providerID:(nonnull NSNumber *)leoProviderID familyID:(nonnull NSNumber *)familyID managedObjectContext:(nonnull NSManagedObjectContext *)context {
    
    Appointment *newAppointment = [NSEntityDescription insertNewObjectForEntityForName:@"Appointment" inManagedObjectContext:context];
    newAppointment.date = date;
    newAppointment.startTime = startTime;
    newAppointment.duration = duration;
    newAppointment.leoAppointmentType = leoAppointmentType;
    newAppointment.leoPatientID = leoPatientID;
    newAppointment.leoProviderID = leoProviderID;
    newAppointment.familyID = familyID;
    
    return newAppointment;
}

+ (Appointment * __nonnull)insertEntityWithJSONDictionary:(nonnull NSDictionary *)jsonResponse managedObjectContext:(nonnull NSManagedObjectContext *)context {
    
    Appointment *newAppointment = [NSEntityDescription insertNewObjectForEntityForName:@"Appointment" inManagedObjectContext:context];
    newAppointment.date = jsonResponse[APIParamApptDate];
    newAppointment.startTime = jsonResponse[APIParamApptStartTime];
    newAppointment.leoAppointmentType = jsonResponse[APIParamApptType];
    newAppointment.leoPatientID = jsonResponse[APIParamPatientID];
    newAppointment.leoProviderID = jsonResponse[APIParamProviderID];
    newAppointment.familyID = jsonResponse[APIParamUserFamilyID];
    
    return newAppointment;

}

@end
