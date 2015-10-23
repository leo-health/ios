//
//  LEOMessageService.m
//  Leo
//
//  Created by Zachary Drossman on 9/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOMessageService.h"
#import "LEOAPISessionManager.h"
#import "Message.h"
#import "Conversation.h"

@implementation LEOMessageService

- (void)createMessage:(Message *)message forConversation:( Conversation *)conversation withCompletion:(void (^)(Message  *  message, NSError *error))completionBlock {
    
    NSArray *messageValues;
    
    if (message.text) {
        messageValues = @[message.text, @"text"];
    } else {
        messageValues = @[message.media, @"media"];
    }
    
    NSArray *messageKeys = @[APIParamMessageBody, APIParamType];
    
    NSDictionary *messageParams = [[NSDictionary alloc] initWithObjects:messageValues forKeys:messageKeys];
    
    
    NSString *createMessageForConversationURLString = [NSString stringWithFormat:@"%@/%@/%@",APIEndpointConversations,conversation.objectID, APIEndpointMessages];
    
    [[LEOMessageService leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:createMessageForConversationURLString params:messageParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        Message *message = [[Message alloc] initWithJSONDictionary:rawResults[APIParamData]];
        
        if (completionBlock) {
            completionBlock(message, error);
        }
    }];
}

- (void)getMessagesForConversation:(Conversation *)conversation page:(NSInteger)page offset:(NSInteger)offset withCompletion:( void (^)(NSArray *messages))completionBlock {
    
    NSArray *messageValues = @[@(page), @(offset)];
    NSArray *messageKeys = @[@"page", @"offset"];
    
    NSDictionary *messageParams = [[NSDictionary alloc] initWithObjects:messageValues forKeys:messageKeys];
    
    NSString *getMessagesForConversationURLString = [NSString stringWithFormat:@"%@/%@/%@",APIEndpointConversations,conversation.objectID, APIEndpointMessages];
    
    [[LEOMessageService leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:getMessagesForConversationURLString params:messageParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (!error) {
            NSArray *messageDictionaries = rawResults[APIParamData];
            
            NSMutableArray *mutableMessages = [[NSMutableArray alloc] init];
            
            for (NSDictionary *messageDictionary in messageDictionaries) {
                
                Message *message = [[Message alloc] initWithJSONDictionary:messageDictionary];
                
                [mutableMessages addObject:message];
            }
            
            NSArray *immutableMessages = [mutableMessages copy];
            
            if (completionBlock) {
                completionBlock(immutableMessages);
            }
        } else {
            
            //TODO: Obviously all of our API calls should return errors, and all should be more descriptive / useful than this. That said, we are already handling user messaging at the API level via UIAlertControllers, so this can take a backseat. For now.
            NSLog(@"Error!");
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
            
            User *user = [[NSUserDefaults standardUserDefaults] objectForKey:participantIDString];
            if (user) {
                [participants addObject:user];
            } else {
                //TODO: Return a placeholder most likely as opposed to go looking for the user.
            }
        }
        
        //        self.conversationParticipants = [participants copy];
        
        Conversation *conversation = [[Conversation alloc] initWithJSONDictionary:rawResults[APIParamData]];
        
        if (completionBlock) {
            completionBlock(conversation);
        }
    }];
}

+ (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}

@end