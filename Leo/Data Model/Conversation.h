//
//  Conversation.h
//  Leo
//
//  Created by Zachary Drossman on 5/29/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConversationParticipant, Message;
@class Family;

typedef enum ConversationState {
    ConversationStateInitialize,
    ConversationStateNewMessage,
    ConversationStateReplied,
} ConversationState;

@interface Conversation : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy) NSString * objectID;
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) NSArray *participants;

@property (nonatomic, strong, nullable) NSDate * lastMessageCreated;

@property (nonatomic, strong, nullable) NSNumber * archived;
@property (nonatomic, strong, nullable) NSDate * archivedAt;
@property (nonatomic, copy, nullable) NSString * archivedByID;

- (instancetype)initWithObjectID:(NSString *)objectID messages:(NSArray *)messages participants:(NSArray *)participants;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

+ (NSDictionary *)dictionaryFromConversation:(Conversation *)coversation;

- (void)addMessage:(Message *)message;

NS_ASSUME_NONNULL_END
@end