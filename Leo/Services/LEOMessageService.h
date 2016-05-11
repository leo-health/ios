//
//  LEOMessageService.h
//  Leo
//
//  Created by Zachary Drossman on 9/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class Message, Conversation, Notice;

#import <Foundation/Foundation.h>

@interface LEOMessageService : NSObject
NS_ASSUME_NONNULL_BEGIN

- (void)createMessage:(Message *)message forConversation:( Conversation *)conversation withCompletion:(void (^)(Message  *  message, NSError *error))completionBlock;
- (void)getMessagesForConversation:(Conversation *)conversation page:(nullable NSNumber *)page offset:(nullable NSNumber *)offset sinceDateTime:(nullable NSDate *)sinceDateTime withCompletion:(void (^)(NSArray *messages, NSError *error))completionBlock;
- (void)getConversationsForCurrentUserWithCompletion:(void (^)(Conversation *conversation))completionBlock;
- (void)getMessageWithIdentifier:(NSString *)messageIdentifier withCompletion:(void (^)(Message *message, NSError *error))completionBlock;
- (void)getConversationNoticeWithCompletion:(void (^)(Notice *conversationNotice, NSError *error))completionBlock;

NS_ASSUME_NONNULL_END
@end
