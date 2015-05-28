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
+ (void)createUserWithParameters:(nonnull NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock;
+ (void)loginUserWithParameters:(nonnull NSDictionary *)loginParams withCompletion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock;
+ (void)resetPasswordWithParameters:(nonnull NSDictionary *)resetParams withCompletion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock;

//Appointments
+ (void)createAppointmentWithParameters:(nonnull NSDictionary *)apptParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock;
+ (void)getAppointmentsForFamilyWithParameters:(nonnull NSDictionary *)params withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock;

//Conversations
+ (void)createMessageForConversation:(NSString *)conversationID withParameters:(nonnull NSDictionary *)messageParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock;
+ (void)getConversationsForFamilyWithParameters:(nonnull NSDictionary *)conversationParams withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock;
+ (void)getMessagesForConversation:(NSString *)conversationID withParameters:(nonnull NSDictionary *)messageParams withCompletion:(void (^)(NSDictionary *rawResults))completionBlock;


NS_ASSUME_NONNULL_END
@end
