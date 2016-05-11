//
//  LEOMessageService.m
//  Leo
//
//  Created by Zachary Drossman on 9/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOMessageService.h"
#import "LEOAPISessionManager.h"
#import "LEOS3ImageSessionManager.h"
#import "Message.h"
#import "MessageText.h"
#import "MessageImage.h"
#import "Conversation.h"
#import <JSQPhotoMediaItem.h>
#import "NSDate+Extensions.h"
#import "Notice.h"
#import "NSDictionary+Extensions.h"

@implementation LEOMessageService

- (void)getConversationNoticeWithCompletion:(void (^)(Notice *conversationNotice, NSError *error))completionBlock {

    [[LEOMessageService leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointConversationNotices params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        Notice *messageHeader;

        if (!error) {
            messageHeader = [[Notice alloc] initWithJSONDictionary:[rawResults leo_itemForKey:APIParamData]];
        }

        if (completionBlock) {
            completionBlock(messageHeader, error);
        }
    }];
}


- (void)createMessage:(Message *)message forConversation:( Conversation *)conversation withCompletion:(void (^)(Message  *  message, NSError *error))completionBlock {

    NSArray *messageValues;
    
    if ([message isKindOfClass:[MessageText class]]) {
        messageValues = @[message.text, @"text"];
    }

    if ([message isKindOfClass:[MessageImage class]]) {

        NSString *photoString = [UIImageJPEGRepresentation(((JSQPhotoMediaItem *)message.media).image, kImageCompressionFactor) base64EncodedStringWithOptions:0];
        messageValues = @[photoString, @"image"];

        //TODO: Remove this when ready to launch
        NSUInteger bytes = [photoString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"Size of photo being uploaded to server in megabytes: %f", (unsigned long)bytes / 1024.0 / 1024.0);
    }
    
    NSArray *messageKeys = @[APIParamMessageBody, APIParamType];
    
    NSDictionary *messageParams = [[NSDictionary alloc] initWithObjects:messageValues forKeys:messageKeys];

    NSString *createMessageForConversationURLString = [NSString stringWithFormat:@"%@/%@/%@",APIEndpointConversations,conversation.objectID, APIEndpointMessages];
    
    [[LEOMessageService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:createMessageForConversationURLString params:messageParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        Message *message = [Message messageWithJSONDictionary:rawResults[APIParamData]];
        
        if (completionBlock) {
            completionBlock(message, error);
        }
    }];
}

- (void)getMessagesForConversation:(Conversation *)conversation page:(nullable NSNumber *)page offset:(nullable NSNumber *)offset sinceDateTime:(nullable NSDate *)sinceDateTime withCompletion:(void (^)(NSArray *messages, NSError *error))completionBlock {

    NSMutableDictionary *messageParams = [NSMutableDictionary new];

    if (page) {
        messageParams[APIParamMessagePage] = page;
    }

    if (offset) {
        messageParams[APIParamMessageOffset] = offset;
    }

    if (sinceDateTime) {
        messageParams[APIParamMessageMinDate] = [NSDate leo_stringifiedDate:sinceDateTime withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    }

    NSString *getMessagesForConversationURLString = [NSString stringWithFormat:@"%@/%@/%@",APIEndpointConversations,conversation.objectID, APIEndpointMessages];
    
    [[LEOMessageService leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:getMessagesForConversationURLString params:messageParams completion:^(NSDictionary *rawResults, NSError *error) {

        NSArray *immutableMessages;

        if (!error) {
            NSArray *messageDictionaries = rawResults[APIParamData];
            
            NSMutableArray *mutableMessages = [[NSMutableArray alloc] init];
            
            for (NSDictionary *messageDictionary in messageDictionaries) {
                
                Message *message = [Message messageWithJSONDictionary:messageDictionary];
                
                [mutableMessages addObject:message];
            }
            
            immutableMessages = [mutableMessages copy];
        }

        if (completionBlock) {
            completionBlock(immutableMessages, error);
        }
    }];
}

- (void)getConversationsForCurrentUserWithCompletion:(void (^)(Conversation*  conversation))completionBlock {
    
    [[LEOMessageService leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointConversations params:nil completion:^(NSDictionary *rawResults, NSError *error) {
        
        NSArray *participantArray = rawResults[APIParamData][APIParamConversationParticipants];
        
        NSMutableArray *participants = [[NSMutableArray alloc] init];
        
        for (NSNumber *participantID in participantArray) {
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *participantIDString = [numberFormatter stringFromNumber:participantID];
            
            //TODO: Check if this is even working in any way. Not sure this is ever being set much less synchronized.
            User *user = [[NSUserDefaults standardUserDefaults] objectForKey:participantIDString];
            if (user) {
                [participants addObject:user];
            } else {
                //TODO: Return a placeholder most likely as opposed to go looking for the user.
            }
        }
                
        Conversation *conversation = [[Conversation alloc] initWithJSONDictionary:rawResults[APIParamData]];
        
        if (completionBlock) {
            completionBlock(conversation);
        }
    }];
}

- (void)getMessageWithIdentifier:(NSString *)messageIdentifier withCompletion:(void (^)(Message *message, NSError *error))completionBlock {
    
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@",APIParamMessages, messageIdentifier];
    [[LEOMessageService leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {
            Message *message = [Message messageWithJSONDictionary:rawResults[APIParamData]];
            completionBlock(message, nil);
        } else {
            completionBlock(nil, error);
        }
        
    }];
}

+ (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}

+ (LEOS3ImageSessionManager *)leoMediaSessionManager {
    return [LEOS3ImageSessionManager sharedClient];
}
@end
