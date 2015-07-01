//
//  Message.h
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation;

@interface Message : NSObject

@property (nonatomic, copy) NSString * body;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSDate * escalatedAt;
@property (nonatomic, copy) NSString * messageID;
@property (nonatomic, strong) NSNumber * messageType;
@property (nonatomic, strong) NSDate * resolvedApprovedAt;
@property (nonatomic, strong) NSDate * resolvedRequestAt;
@property (nonatomic, copy) NSString * senderID;
@property (nonatomic, strong) NSDate * updatedAt;
@property (nonatomic, strong) Conversation *conversation;

- (instancetype)initWithBody:(NSString *)body senderID:(NSString *)senderID;
- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse;

@end
