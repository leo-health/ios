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

typedef enum ConversationState {
    ConversationStateInitialize,
    ConversationStateNewMessage,
    ConversationStateReplied,
} ConversationState;

@interface Conversation : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong, nullable) NSNumber * archived;
@property (nonatomic, strong, nullable) NSDate * archivedAt;
@property (nonatomic, copy, nullable) NSString * archivedByID;
@property (nonatomic, copy) NSString * conversationID;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, copy) NSString * familyID;
@property (nonatomic, strong, nullable) NSDate * lastMessageCreated;
@property (nonatomic, strong) NSDate * updatedAt;
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) NSArray *participants;

- (instancetype)initWithFamilyID:(NSString *)familyID conversationID:(NSString *)conversationID;
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;


NS_ASSUME_NONNULL_END
@end