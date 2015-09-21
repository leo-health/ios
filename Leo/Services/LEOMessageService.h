//
//  LEOMessageService.h
//  Leo
//
//  Created by Zachary Drossman on 9/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class Message, Conversation;

#import <Foundation/Foundation.h>

@interface LEOMessageService : NSObject

- (void)createMessage:(Message *)message forConversation:( Conversation *)conversation withCompletion:(void (^)(Message  *  message, NSError *error))completionBlock;
- (void)getMessagesForConversation:(Conversation *)conversation page:(NSInteger)page offset:(NSInteger)offset withCompletion:( void (^)(NSArray *messages))completionBlock;
- (void)getConversationsForCurrentUserWithCompletion:(void (^)(Conversation*  conversation))completionBlock;

@end
