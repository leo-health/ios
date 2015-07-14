//
//  Message.h
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Message : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy) NSString *objectID;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, strong, nullable) User *escalatedTo;
@property (nonatomic, strong, nullable) User *escalatedBy;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSNumber *statusID;
@property (nonatomic, strong) User *sender;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSNumber *typeID;
@property (nonatomic, strong) NSDate *escalatedAt;


- (instancetype)initWithObjectID:(nullable NSString *)objectID body:(NSString *)body sender:(User *)sender escalatedTo:(nullable User *)escalatedTo escalatedBy:(nullable User *)escalatedBy status:(nullable NSString *)status statusID:(NSNumber *)statusID createdAt:(NSDate *)createdAt escalatedAt:(nullable NSDate *)escalatedAt type:(nullable NSString *)type typeID:(NSNumber *)typeID;

- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse;

+ (NSDictionary *)dictionaryFromMessage:(Message *)message;

NS_ASSUME_NONNULL_END
@end
