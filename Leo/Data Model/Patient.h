//
//  Patient.h
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@class Family, LEOS3Image;

@interface Patient : User <NSCopying>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, Gender) {
    GenderMale = 0,
    GenderFemale = 1
};

typedef NS_ENUM(NSUInteger, PatientStatusCode) {
    PatientStatusInactive = 1,
    PatientStatusActive = 2
};

@property (nonatomic, strong) NSDate * dob;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *genderDisplayName;
@property (nonatomic, copy) NSString *status; //FIXME: Should probably be using the PatientStatus instead of a string. Come back and update eventually!
@property (nonatomic, copy, nullable) NSString *familyID;

- (instancetype)initWithObjectID:(nullable NSString *)objectID familyID:(nullable NSString *)familyID title:(nullable NSString *)title firstName:(NSString * __nonnull)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString * __nonnull)lastName suffix:(nullable NSString *)suffix email:(nullable NSString *)email avatar:(nullable LEOS3Image *)avatar dob:(NSDate *)dob gender:(NSString *)gender status:(NSString *)status;

- (instancetype)initWithTitle:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(nullable NSString *)email avatar:(nullable LEOS3Image *)avatar dob:(NSDate *)dob gender:(NSString *)gender status:(nullable NSString *)status;

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName avatar:(LEOS3Image *)avatar dob:(NSDate *)dob gender:(NSString *)gender;


- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

+ (NSDictionary *)dictionaryFromUser:(Patient *)patient;

- (BOOL)isValid;
- (void)copyFrom:(Patient *)otherPatient;
- (BOOL)hasAvatarDifferentFromPlaceholder;

NS_ASSUME_NONNULL_END
@end
