//
//  Appointment+Methods.m
//  
//
//  Created by Zachary Drossman on 5/14/15.
//
//

#import "Appointment+Methods.h"
#import "LEOConstants.h"
#import "User+Methods.h"
#import "Role+Methods.h"
#import "LEOCoreDataManager.h"

@implementation Appointment (Methods)


+ (Appointment * __nonnull)insertEntityWithDate:(nonnull NSDate *)date duration:(nonnull NSNumber *)duration appointmentType:(nonnull NSNumber *)leoAppointmentType patient:(nonnull User *)patient provider:(nonnull User *)provider familyID:(nonnull NSString *)familyID bookedByUser:(nonnull User *)bookedByUser state:(nonnull NSNumber *)state managedObjectContext:(nonnull NSManagedObjectContext *)context {

    Appointment *newAppointment = [NSEntityDescription insertNewObjectForEntityForName:@"Appointment" inManagedObjectContext:context];
    newAppointment.date = date;
    newAppointment.duration = duration;
    newAppointment.leoAppointmentType = leoAppointmentType;
    newAppointment.patient = patient;
    newAppointment.provider = provider;
    newAppointment.familyID = familyID;
    newAppointment.bookedByUser = bookedByUser;
    newAppointment.state = state;
    
    return newAppointment;
}

+ (Appointment * __nonnull)insertEntityWithJSONDictionary:(nonnull NSDictionary *)jsonResponse managedObjectContext:(nonnull NSManagedObjectContext *)context {
    
    Appointment *newAppointment = [NSEntityDescription insertNewObjectForEntityForName:@"Appointment" inManagedObjectContext:context];
    newAppointment.date = jsonResponse[APIParamApptDate];
    newAppointment.leoAppointmentType = jsonResponse[APIParamApptType];
    LEOCoreDataManager *coreDataManager = [LEOCoreDataManager sharedManager];
    newAppointment.patient = [coreDataManager objectWithObjectID:jsonResponse[APIParamPatientID] objectArray:coreDataManager.users];
    newAppointment.provider = [coreDataManager objectWithObjectID:jsonResponse[APIParamProviderID] objectArray:coreDataManager.users];
    newAppointment.bookedByUser = [coreDataManager objectWithObjectID:jsonResponse[APIParamBookedByUserID] objectArray:coreDataManager.users];
    newAppointment.familyID = jsonResponse[APIParamUserFamilyID];
    newAppointment.state = jsonResponse[APIParamState];
    return newAppointment;

}

- (AppointmentState)appointmentState {
    return [self.state integerValue];
}

- (nonnull NSString *)stringifiedAppointmentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"EEE', 'MMM','DD'";
    return [dateFormatter stringFromDate:self.date];
}

- (nonnull NSString *)stringifiedAppointmentTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"HH':'MM";
    return [dateFormatter stringFromDate:self.date];
}

@end
