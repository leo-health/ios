//
//  LEOMessageService.m
//  Leo
//
//  Created by Zachary Drossman on 9/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOMessageService.h"
#import "LEOAPISessionManager.h"
#import "LEOS3SessionManager.h"
#import "Message.h"
#import "MessageText.h"
#import "MessageImage.h"
#import "Conversation.h"
#import <JSQPhotoMediaItem.h>

@implementation LEOMessageService

- (void)createMessage:(Message *)message forConversation:( Conversation *)conversation withCompletion:(void (^)(Message  *  message, NSError *error))completionBlock {
    
    NSArray *messageValues;
    
    if ([message isKindOfClass:[MessageText class]]) {
        messageValues = @[message.text, @"text"];
    }

    if ([message isKindOfClass:[MessageImage class]]) {

        NSString *photoString = [UIImagePNGRepresentation(((JSQPhotoMediaItem *)message.media).image) base64EncodedStringWithOptions:0];
        messageValues = @[photoString, @"image"];

        //Log size of photo being shared
        NSUInteger bytes = [photoString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"Size of photo being uploaded to server in megabytes: %lu", (unsigned long)bytes / 1024.0);
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
                
                Message *message = [Message messageWithJSONDictionary:messageDictionary];
                
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

- (void)getImageFromURL:(NSString *)imageURL withCompletion:(void (^)(UIImage *rawImage, NSError *error))completionBlock {

    if (imageURL) {

        [[LEOMessageService leoMediaSessionManager] unauthenticatedGETRequestForImageFromS3WithURL:imageURL params:nil completion:^(UIImage *rawImage, NSError *error) {
                completionBlock ? completionBlock(rawImage, error) : nil;
        }];

    } else {
        completionBlock ? completionBlock(nil, nil) : nil;
    }
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

+ (LEOS3SessionManager *)leoMediaSessionManager {
    return [LEOS3SessionManager sharedClient];
}
@end
