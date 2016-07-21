//
//  Family.h
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOJSONSerializable.h"

@class Patient;
@class Guardian;

@interface Family : LEOJSONSerializable <NSCoding>
NS_ASSUME_NONNULL_BEGIN

@property (copy, nonatomic, nullable) NSString *objectID;
@property (copy, nonatomic) NSArray *guardians;
@property (copy, nonatomic) NSArray *patients;

- (instancetype)initWithObjectID:(nullable NSString *)objectID guardians:(NSArray *)guardians patients:(NSArray *)patients;

- (void)addPatient:(Patient *)patient;
- (void)addGuardian:(Guardian *)guardian;
- (Guardian *)guardianWithID:(NSString *)objectID;
- (NSArray *)guardiansExceptGuardianWithID:(NSString *)objectID;
- (BOOL)hasAdditionalCaregivers;

NS_ASSUME_NONNULL_END
@end
