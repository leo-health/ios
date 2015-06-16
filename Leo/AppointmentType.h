//
//  AppointmentType.h
//  Leo
//
//  Created by Zachary Drossman on 6/16/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointmentType : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *typeDescriptor;
@property (nonatomic, copy) NSNumber *duration;

- (instancetype)initWithID:(NSString *)id typeDescriptor:(NSString *)typeDescriptor duration:(NSNumber *)duration;

@end