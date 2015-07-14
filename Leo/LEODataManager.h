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

@interface LEODataManager : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (strong, nonatomic) NSArray *cards; //TODO: Maybe make private and method implementation to lazily instantiate somehow...
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) NSString *userToken; //FIXME: To be moved to the .m once pulling from the keychain as it should be
@property (strong, nonatomic) NSArray *availableDates;

@property (strong, nonatomic) NSArray *users;


- (NSArray *)availableTimesForDate:(NSDate*)date;

+ (instancetype)sharedManager;


//Cards
- (void)getCardsWithCompletion:(void (^)(NSArray *cards))completionBlock;

//Users
- (void)createUserWithUser:(nonnull User *)user password:(nonnull NSString *)password withCompletion:(void (^)( NSDictionary * __nonnull rawResults))completionBlock;
- (void)loginUserWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password withCompletion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock;
- (void)resetPasswordWithEmail:(nonnull NSString *)email withCompletion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock;

//Appointments
- (void)createAppointmentWithAppointment:(nonnull Appointment *)appointment withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock;
- (void)getAppointmentsForFamilyOfCurrentUserWithCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock;
- (NSArray *)fetchSlots;


//Conversations
- (void)getConversationsForCurrentUserWithCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock;
- (void)createMessage:(Message *)message forConversation:(nonnull Conversation *)conversation withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock;
- (void)getMessagesForConversation:(Conversation *)conversation withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock;

//Helper Data
- (void)getFamilyWithCompletion:(void (^)(Family *family))completionBlock;
- (void)getProvidersForPractice:(Practice *)practice withCompletion:(void (^)(NSArray *providers))completionBlock;
- (void)getVisitTypesWithCompletion:(void (^)(NSArray *visitTypes))completionBlock;

//Helper methods
- (id)objectWithObjectID:(NSString *)objectID objectArray:(NSArray *)objects;


- (void)addCard:(LEOCard *)card;
- (void)removeCard:(LEOCard *)card;


NS_ASSUME_NONNULL_END
@end
