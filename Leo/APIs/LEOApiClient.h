//
//  LEOApiClient.h
//  Leo
//
//  Created by Zachary Drossman on 5/12/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class Appointment;


@interface LEOApiClient : NSObject
NS_ASSUME_NONNULL_BEGIN

//Users
+ (void)createUserWithParameters:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock;
+ (void)loginUserWithParameters:(NSDictionary *)loginParams withCompletion:(void (^)(NSDictionary * rawResults))completionBlock;
+ (void)resetPasswordWithParameters:(NSDictionary *)resetParams withCompletion:(void (^)(NSDictionary * rawResults))completionBlock;
+ (void)getAvatarFromURL:(NSString *)avatarURL withCompletion:(void (^)(NSData *data))completionBlock;

//Cards
+ (void)getCardsForUser:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock;

//Support API
+ (void)getPracticesWithCompletion:(void (^)(NSDictionary *rawResults))completionBlock;
+ (void)getAppointmentTypesWithCompletion:(void (^)(NSDictionary *rawResults))completionBlock;
+ (void)getFamilyWithUserParameters:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock;
+ (void)getPracticeWithParameters:(NSDictionary *)practiceParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock;

//Appointments
+ (void)createAppointmentWithParameters:(NSDictionary *)apptParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock;
+ (void)getAppointmentsForFamilyWithParameters:(NSDictionary *)params withCompletion:(void (^)(NSDictionary  * rawResults))completionBlock;
+ (void)getSlotsWithParameters:(NSDictionary *)slotParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock;
+ (void)cancelAppointmentWithParameters:(NSDictionary *)apptParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock;

//Conversations
+ (void)createMessageForConversation:(NSString *)conversationID withParameters:(NSDictionary *)messageParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock;
+ (void)getConversationsForFamilyWithParameters:(NSDictionary *)conversationParams withCompletion:(void (^)(NSDictionary  * rawResults))completionBlock;
+ (void)getMessagesForConversation:(NSString *)conversationID withParameters:(NSDictionary *)messageParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock;


NS_ASSUME_NONNULL_END


@end
