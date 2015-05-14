//
//  User.h
//  
//
//  Created by Zachary Drossman on 5/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Appointment, ConversationParticipant, UserRole;

@interface User : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * dob;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * familyID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middleInitial;
@property (nonatomic, retain) NSNumber * practiceID;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *appointments;
@property (nonatomic, retain) ConversationParticipant *participant;
@property (nonatomic, retain) NSSet *roles;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addAppointmentsObject:(Appointment *)value;
- (void)removeAppointmentsObject:(Appointment *)value;
- (void)addAppointments:(NSSet *)values;
- (void)removeAppointments:(NSSet *)values;

- (void)addRolesObject:(UserRole *)value;
- (void)removeRolesObject:(UserRole *)value;
- (void)addRoles:(NSSet *)values;
- (void)removeRoles:(NSSet *)values;

@end
