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

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, strong, nullable) NSDate *escalatedAt;
@property (nonatomic, strong) NSNumber *messageType;
@property (nonatomic, strong, nullable) NSDate *resolvedApprovedAt;
@property (nonatomic, strong, nullable) NSDate *resolvedRequestAt;
@property (nonatomic, strong) User *sender;

- (instancetype)initWithID:(nullable NSString *)id body:(NSString *)body sender:(User *)sender;

- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse;

+ (NSDictionary *)dictionaryFromMessage:(Message *)message;

NS_ASSUME_NONNULL_END
@end
