//
//  User.h
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Appointment, ConversationParticipant, Role;

@interface User : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * credentialSuffix;
@property (nonatomic, retain) NSDate * dob;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * familyID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middleInitial;
@property (nonatomic, retain) NSString * practiceID;
@property (nonatomic, retain) NSString * suffix;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *appointmentsToAdminister;
@property (nonatomic, retain) NSSet *appointmentsToBeAt;
@property (nonatomic, retain) Appointment *appointmentsToBeSeen;
@property (nonatomic, retain) ConversationParticipant *participant;
@property (nonatomic, retain) Role *role;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addAppointmentsToAdministerObject:(Appointment *)value;
- (void)removeAppointmentsToAdministerObject:(Appointment *)value;
- (void)addAppointmentsToAdminister:(NSSet *)values;
- (void)removeAppointmentsToAdminister:(NSSet *)values;

- (void)addAppointmentsToBeAtObject:(Appointment *)value;
- (void)removeAppointmentsToBeAtObject:(Appointment *)value;
- (void)addAppointmentsToBeAt:(NSSet *)values;
- (void)removeAppointmentsToBeAt:(NSSet *)values;

@end
