//
//  LEOHelperService.h
//  Leo
//
//  Created by Zachary Drossman on 8/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class Family, Practice, LEOPromise, Provider;

#import <Foundation/Foundation.h>
#import "LEOModelService.h"

@interface LEOPracticeService : LEOModelService

- (LEOPromise *)getPracticeWithCompletion:(void (^)(Practice *practices, NSError *error))completionBlock;
- (LEOPromise *)putPractice:(Practice *)practice withCompletion:(void (^)(Practice *practice, NSError *error))completionBlock;

- (LEOPromise *)getPracticesWithCompletion:(void (^)(NSArray<Practice *> *practices, NSError *error))completionBlock;
- (LEOPromise *)putPractices:(NSArray<Practice *> *)practices withCompletion:(void (^)(NSArray<Practice *> *practices, NSError *error))completionBlock;

- (LEOPromise *)getProvidersWithCompletion:(void (^)(NSArray<Provider *> *providers, NSError *error))completionBlock;
- (LEOPromise *)getAppointmentTypesWithCompletion:(void (^)(NSArray *appointmentTypes, NSError *error))completionBlock;
- (LEOPromise *)getInsurersAndPlansWithCompletion:(void (^)(NSArray *insurersAndPlans, NSError *error))completionBlock;

- (NSArray<Provider *> *)getProviders;
- (Provider *)getProviderWithID:(NSString *)objectID;

@end
