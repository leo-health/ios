//
//  LEOCoreDataManager.h
//
//
//  Created by Zachary Drossman on 5/11/15.
//
//

#import <Foundation/Foundation.h>
@class User;
@class LEOApiClient;
@class Appointment;
@class Conversation;
@class Message;
@class LEOCard;
@class Guardian;
@class Family;
@class Provider;
@class Practice;
@class AppointmentType;
@class SessionUser;

@interface LEODataManager : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (strong, nonatomic) NSArray *cards; //TODO: Maybe make private and method implementation to lazily instantiate somehow...
@property (strong, nonatomic) NSArray *availableDates;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) NSArray *avatars;
@property (nonatomic, strong) NSArray *conversationParticipants;
@property (strong, nonatomic) Family *family;

+ (instancetype)sharedManager;


//Cards
- (void)getCardsWithCompletion:(void (^)(NSArray *cards, NSError *error))completionBlock;

//Users
- (void)createUserWithUser:( User *)user password:( NSString *)password withCompletion:(void (^)( NSDictionary * rawResults, NSError *error))completionBlock;
- (void)loginUserWithEmail:( NSString *)email password:( NSString *)password withCompletion:(void (^)(SessionUser *user, NSError *error))completionBlock;
- (void)resetPasswordWithEmail:(NSString *)email withCompletion:(void (^)(NSDictionary * rawResults, NSError *error))completionBlock;
- (void)getAvatarForUser:(User *)user withCompletion:(void (^)(UIImage *rawImage, NSError *error))completionBlock;

//Appointments
- (void)createAppointmentWithAppointment:( Appointment *)appointment withCompletion:(void (^)(NSDictionary  * rawResults, NSError *error))completionBlock;
- (void)getAppointmentsForFamilyOfCurrentUserWithCompletion:(void (^)(NSDictionary  * rawResults, NSError *error))completionBlock;
- (void)cancelAppointment:(Appointment *)appointment withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock;
- (void)getSlotsForAppointmentType:(AppointmentType *)appointmentType provider:(Provider *)provider startDate:(NSDate *)startDate endDate:(NSDate *)endDate withCompletion:(void (^)(NSArray *slots, NSError *error))completionBlock;

//Conversations
- (void)getConversationsForCurrentUserWithCompletion:(void (^)(Conversation*  conversation))completionBlock;
- (void)createMessage:(Message *)message forConversation:( Conversation *)conversation withCompletion:(void (^)(Message  *  message, NSError *error))completionBlock;
- (void)getMessagesForConversation:(Conversation *)conversation withCompletion:( void (^)(NSArray *messages))completionBlock;

//Helper Data
- (void)getFamilyWithCompletion:(void (^)(Family *family, NSError *error))completionBlock;
- (void)getAppointmentTypesWithCompletion:(void (^)(NSArray *appointmentTypes, NSError *error))completionBlock;
- (void)getPracticeWithID:(NSString *)practiceID withCompletion:(void (^)(Practice *practice, NSError *error))completionBlock;

//Helper methods
- (id)objectWithObjectID:(NSString *)objectID objectArray:(NSArray *)objects;


- (id)unarchiveObjectWithPathComponent:(NSString *)pathComponent;
- (void)archiveObject:(id)object withPathComponent:(NSString *)pathComponent;

NS_ASSUME_NONNULL_END
@end
