//
//  AppointmentStatus.h
//  Leo
//
//  Created by Zachary Drossman on 11/18/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointmentStatus : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy) NSString *objectID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *athenaCode;
@property (nonatomic) AppointmentStatusCode statusCode;

- (instancetype)initWithObjectID:(NSString *)objectID name:(NSString *)name athenaCode:(NSString *)athenaCode statusCode:(AppointmentStatusCode)statusCode;
- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse;
+ (NSDictionary *)dictionaryFromAppointmentStatus:(AppointmentStatus *)status;

NS_ASSUME_NONNULL_END
@end
