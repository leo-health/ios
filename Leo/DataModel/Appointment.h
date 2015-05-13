//
//  Appointment.h
//  
//
//  Created by Zachary Drossman on 5/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Appointment : NSManagedObject

@property (nonatomic, retain) NSString * athenaAppointmentType;
@property (nonatomic, retain) NSNumber * athenaAppointmentTypeID;
@property (nonatomic, retain) NSNumber * athenaDepartmentID;
@property (nonatomic, retain) NSNumber * athenaId;
@property (nonatomic, retain) NSNumber * athenaPatientID;
@property (nonatomic, retain) NSNumber * athenaProviderID;
@property (nonatomic, retain) NSNumber * bookedByUserID;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * familyID;
@property (nonatomic, retain) NSNumber * frozenyn;
@property (nonatomic, retain) NSString * leoAppointmentType;
@property (nonatomic, retain) NSNumber * leoPatientID;
@property (nonatomic, retain) NSNumber * leoProviderID;
@property (nonatomic, retain) NSNumber * rescheduledAppointmentID;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDate * updatedAt;

@end
