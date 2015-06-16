//
//  Appointment.h
//  Leo
//
//  Created by Zachary Drossman on 6/16/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Appointment : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * familyID;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) id leoAppointmentType;
@property (nonatomic, retain) NSString * practiceID;
@property (nonatomic, retain) NSString * rescheduledAppointmentID;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) User *bookedByUser;
@property (nonatomic, retain) User *patient;
@property (nonatomic, retain) User *provider;

@end
