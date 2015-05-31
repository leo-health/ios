//
//  LEOCoreDataManager.h
//  
//
//  Created by Zachary Drossman on 5/11/15.
//
//

#import <Foundation/Foundation.h>
@import CoreData;
@class User;
@class LEOApiClient;
@class Appointment;
@class Conversation;
@class Message;

@interface LEOCoreDataManager : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *cards;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) NSString *userToken; //FIXME: To be moved to the .m once pulling from the keychain as it should be

@property (strong, nonatomic) NSArray *users;

- (void)fetchDataWithCompletion:(void (^) (void))completionBlock;
+ (instancetype)sharedManager;

//Users
- (void)createUserWithUser:(nonnull User *)user password:(nonnull NSString *)password withCompletion:(void (^)( NSDictionary * __nonnull rawResults))completionBlock;
- (void)loginUserWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password withCompletion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock;
- (void)resetPasswordWithEmail:(nonnull NSString *)email withCompletion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock;

//Appointments
- (void)createAppointmentWithAppointment:(nonnull Appointment *)appointment withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock;
- (void)getAppointmentsForFamilyOfCurrentUserWithCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock;

//Conversations
- (void)getConversationsForCurrentUserWithCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock;
- (void)createMessage:(Message *)message forConversation:(nonnull Conversation *)conversation withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock;
- (void)getMessagesForConversation:(Conversation *)conversation withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock;

- (id)objectWithObjectID:(NSString *)objectID objectArray:(NSArray *)objects;

NS_ASSUME_NONNULL_END
@end
