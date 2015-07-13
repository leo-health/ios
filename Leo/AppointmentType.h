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
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong, nullable) NSNumber *duration;
@property (nonatomic, copy) NSString *typeDescription;

- (instancetype)initWithObjectID:(NSString *)objectID type:(NSString *)type duration:(nullable NSNumber *)duration typeDescription:(NSString *)typeDescription;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

NS_ASSUME_NONNULL_END
@end