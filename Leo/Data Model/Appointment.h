//
//  Appointment.h
//  
//
//  Created by Zachary Drossman on 5/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Appointment : NSManagedObject

@property (nonatomic, retain) NSNumber * bookedByUserID;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * familyID;
@property (nonatomic, retain) NSString * leoAppointmentType;
@property (nonatomic, retain) NSNumber * leoPatientID;
@property (nonatomic, retain) NSNumber * leoProviderID;
@property (nonatomic, retain) NSNumber * rescheduledAppointmentID;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *users;
@end

@interface Appointment (CoreDataGeneratedAccessors)

- (void)addUsersObject:(User *)value;
- (void)removeUsersObject:(User *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

@end
