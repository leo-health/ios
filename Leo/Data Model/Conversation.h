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

@interface Conversation : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, copy) NSString * objectID;
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) NSArray *participants;
@property (nonatomic, strong) NSNumber *state;
@property (nonatomic, readonly) NSInteger messageCount;
@property (nonatomic) ConversationStatusCode statusCode;
@property (nonatomic) ConversationStatusCode priorStatusCode;

- (instancetype)initWithObjectID:(NSString *)objectID messages:(NSArray *)messages participants:(NSArray *)participants statusCode:(ConversationStatusCode)statusCode;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

+ (NSDictionary *)dictionaryFromConversation:(Conversation *)coversation;

- (void)addMessage:(Message *)message;
- (void)addMessages:(NSArray *)messages;
- (void)addMessageFromJSON:(NSDictionary *)messageDictionary;
//- (void)addMessagesFromJSON:(NSArray *)messagesArray;


- (void)reply;
- (void)call;
- (void)dismiss;
- (void)returnToPriorState;

- (void)fetchMessageWithID:(NSString *)messageID completion:(void (^)(void))completionBlock;

NS_ASSUME_NONNULL_END
@end