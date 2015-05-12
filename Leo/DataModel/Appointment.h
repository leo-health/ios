//
//  Appointment.h
//  
//
//  Created by Zachary Drossman on 5/12/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Appointment : NSManagedObject

@property (nonatomic, retain) NSString * appointmentStatus;
@property (nonatomic, retain) NSString * athenaAppointmentType;
@property (nonatomic, retain) NSNumber * athenaDepartmentId;
@property (nonatomic, retain) NSNumber * athenaId;
@property (nonatomic, retain) NSNumber * athenaAppointmentTypeId;
@property (nonatomic, retain) NSNumber * leoProviderId;
@property (nonatomic, retain) NSNumber * athenaProviderId;
@property (nonatomic, retain) NSNumber * leoPatientId;
@property (nonatomic, retain) NSNumber * athenaPatientId;
@property (nonatomic, retain) NSNumber * bookedByUserId;
@property (nonatomic, retain) NSNumber * rescheduledAppointmentId;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSDate * appointmentDate;
@property (nonatomic, retain) NSDate * appointmentStartTime;
@property (nonatomic, retain) NSNumber * frozenyn;
@property (nonatomic, retain) NSString * leoAppointmentTime;
@property (nonatomic, retain) NSNumber * familyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;

@end
