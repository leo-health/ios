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

//Users
+ (void)createUserWithUser:(nonnull User *)user withCompletion:(nullable void (^)( NSDictionary * __nonnull rawResults))completionBlock;
+ (void)loginUserWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password completion:(nullable void (^)(NSDictionary * __nonnull rawResults))completionBlock;


//Appointments
+ (void)createAppointmentWithAppointment:(nonnull Appointment *)appointment andUser:(nonnull User *)user withCompletion:(nullable void (^)(NSDictionary  * __nonnull rawResults))completionBlock;
+ (void)getAppointmentsForFamilyOfUser:(nonnull User *)user withCompletion:(nullable void (^)(NSDictionary  * __nonnull rawResults))completionBlock;


@end
