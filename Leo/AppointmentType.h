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

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *typeDescriptor;
@property (nonatomic, strong, nullable) NSNumber *duration;

- (instancetype)initWithID:(NSString *)id typeDescriptor:(NSString *)typeDescriptor duration:(nullable NSNumber *)duration;
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

NS_ASSUME_NONNULL_END
@end