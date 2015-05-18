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

@interface LEOCoreDataManager : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *cards;
@property (strong, nonatomic) User *currentUser;

- (void)fetchDataWithCompletion:(void (^) (void))completionBlock;
+ (instancetype)sharedManager;

//Users
- (void)createUserWithUser:(nonnull User *)user password:(nonnull NSString *)password withCompletion:(void (^)( NSDictionary * __nonnull rawResults))completionBlock;
- (void)loginUserWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password completion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock;


//Appointments
- (void)createAppointmentWithAppointment:(nonnull Appointment *)appointment withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock;
- (void)getAppointmentsForFamilyOfUser:(nonnull User *)user withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock;

//Conversations
- (void)getConversationsForCurrentUserWithCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock;
- (void)createMessageForConversation:(nonnull Conversation *)conversation withContents:(NSDictionary *)content withCompletion:(nonnull void (^)(NSDictionary  * __nonnull rawResults))completionBlock;




NS_ASSUME_NONNULL_END
@end
