//
//  Patient.h
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@class Family;

@interface Patient : User
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong) NSDate * dob;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *status;

- (instancetype)initWithObjectID:(nullable NSString *)objectID title:(nullable NSString *)title firstName:(NSString * __nonnull)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString * __nonnull)lastName suffix:(nullable NSString *)suffix email:(nullable NSString *)email photoURL:(nullable NSURL *)photoURL photo:(nullable UIImage *)photo dob:(NSDate *)dob gender:(NSString *)gender status:(NSString *)status;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

+ (NSDictionary *)dictionaryFromUser:(Patient *)patient;

NS_ASSUME_NONNULL_END
@end
