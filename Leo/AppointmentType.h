//
//  AppointmentType.h
//  Leo
//
//  Created by Zachary Drossman on 6/16/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Unclear whether this object is going to be used at all at this point.
 */
@interface AppointmentType : NSObject
NS_ASSUME_NONNULL_BEGIN





@property (nonatomic, copy) NSString *objectID;
@property (nonatomic) AppointmentReasonCode reasonCode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, copy) NSString *fullDescription;

- (instancetype)initWithObjectID:(NSString *)objectID name:(NSString *)name reasonCode:(AppointmentReasonCode)reasonCode duration:(nullable NSNumber *)duration description:(NSString *)fullDescription;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;


NS_ASSUME_NONNULL_END
@end