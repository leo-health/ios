//
//  LEOHelperService.h
//  Leo
//
//  Created by Zachary Drossman on 8/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class Family, Practice;

#import <Foundation/Foundation.h>

@interface LEOHelperService : NSObject

- (NSURLSessionTask *)getPracticesWithCompletion:(void (^)(NSArray *practices, NSError *error))completionBlock;
- (NSURLSessionTask *)getPracticeWithID:(NSString *)practiceID withCompletion:(void (^)(Practice *practice, NSError *error))completionBlock;
- (NSURLSessionTask *)getFamilyWithCompletion:(void (^)(Family *family, NSError *error))completionBlock;
- (NSURLSessionTask *)getAppointmentTypesWithCompletion:(void (^)(NSArray *appointmentTypes, NSError *error))completionBlock;

@end
