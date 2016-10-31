//
//  AppointmentType.h
//  Leo
//
//  Created by Zachary Drossman on 6/16/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOJSONSerializable.h"

/**
 *  Unclear whether this object is going to be used at all at this point.
 */
@interface AppointmentType : LEOJSONSerializable
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy) NSString *objectID;
@property (nonatomic) AppointmentTypeCode typeCode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, copy) NSString *longDescription;
@property (nonatomic, copy) NSString *shortDescription;


- (instancetype)initWithObjectID:(NSString *)objectID name:(NSString *)name typeCode:(AppointmentTypeCode)typeCode duration:(nullable NSNumber *)duration longDescription:(NSString *)longDescription shortDescription:(NSString *)shortDescription;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;
 

NS_ASSUME_NONNULL_END
@end
