//
//  Appointment+Methods.m
//  
//
//  Created by Zachary Drossman on 5/14/15.
//
//

#import "Appointment+Methods.h"
#import "LEOConstants.h"


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

- (NSArray *)prepareButtonsForState:(AppointmentState)state {
    
    NSMutableArray *buttonArray = [[NSMutableArray alloc] init];
    
    switch (state) {
        case AppointmentStateMake: {
            UIButton *makeAppointmentButton = [[UIButton alloc] init];
            [makeAppointmentButton setTitle:@"Make Appointment" forState:UIControlStateNormal];
            [buttonArray addObject:makeAppointmentButton];
            break;
        }
        case AppointmentStateMade:
            break;
            
        case AppointmentStateCancelled:
            break;
            
        default:
            break;
    }
  
    return buttonArray;
}

@end
