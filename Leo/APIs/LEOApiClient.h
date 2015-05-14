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
+ (void)createUserWithUser:(nonnull User *)user password:(nonnull NSString *)password withCompletion:(void (^)( NSDictionary * __nonnull rawResults))completionBlock;
+ (void)loginUserWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password completion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock;


//Appointments
+ (void)createAppointmentWithAppointment:(nonnull Appointment *)appointment withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock;
+ (void)getAppointmentsForFamilyOfUser:(nonnull User *)user withCompletion:(void (^)(NSDictionary  * __nonnull rawResults))completionBlock;

NS_ASSUME_NONNULL_END
@end
