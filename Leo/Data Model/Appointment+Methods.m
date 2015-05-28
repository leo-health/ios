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
#import "UserRole+Methods.h"

@implementation Appointment (Methods)


+ (Appointment * __nonnull)insertEntityWithDate:(nonnull NSDate *)date duration:(nonnull NSNumber *)duration appointmentType:(nonnull NSNumber *)leoAppointmentType patientID:(nonnull NSString *)leoPatientID providerID:(nonnull NSString *)leoProviderID familyID:(nonnull NSString *)familyID managedObjectContext:(nonnull NSManagedObjectContext *)context {

    Appointment *newAppointment = [NSEntityDescription insertNewObjectForEntityForName:@"Appointment" inManagedObjectContext:context];
    newAppointment.date = date;
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
    newAppointment.leoAppointmentType = jsonResponse[APIParamApptType];
    newAppointment.leoPatientID = jsonResponse[APIParamPatientID];
    newAppointment.leoProviderID = jsonResponse[APIParamProviderID];
    newAppointment.familyID = jsonResponse[APIParamUserFamilyID];
    
    return newAppointment;

}

- (AppointmentState)appointmentState {
    return [self.state integerValue];
}

//FIXME: Refactoring necessary to separate these out into associated classes
- (nonnull User *)primaryForAppointment {
    
    for (User *user in self.users) {
        for (UserRole *userRole in user.roles) {
            if (userRole.role.roleType == RoleTypeChild) {
                return user;
            }
        }
    }
    
    return nil; //FIXME: Replace with an exception and shouldn't be nil.
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
