//
//  Appointment.h
//  Leo
//
//  Created by Zachary Drossman on 5/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Appointment : NSManagedObject

@property (nonatomic, retain) NSString * bookedByUserID;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * familyID;
@property (nonatomic, retain) NSNumber * leoAppointmentType;
@property (nonatomic, retain) NSString * leoPatientID;
@property (nonatomic, retain) NSString * leoProviderID;
@property (nonatomic, retain) NSString * practiceID;
@property (nonatomic, retain) NSString * rescheduledAppointmentID;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *users;
@end

@interface Appointment (CoreDataGeneratedAccessors)

- (void)addUsersObject:(User *)value;
- (void)removeUsersObject:(User *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

@end
