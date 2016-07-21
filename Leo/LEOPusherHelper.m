//
//  LEOPusherHelper.m
//  Leo
//
//  Created by Zachary Drossman on 7/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOPusherHelper.h"
#import "LEOCredentialStore.h"
#import "Configuration.h"
#import "LEOAPISessionManager.h"

@interface LEOPusherHelper ()

@property (strong, nonatomic) PTPusher *client;

@end

@implementation LEOPusherHelper 

+ (instancetype)sharedPusher {
    
    static LEOPusherHelper *sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

- (PTPusher *)client {
    
    if (!_client) {
        
        [self updateClientForNewKeys];
    }

    return _client;
}

- (void) updateClientForNewKeys {

    _client = [PTPusher pusherWithKey:[Configuration pusherKey] delegate:self encrypted:YES];
    NSString *pusherAuthURLString = [NSString stringWithFormat:@"%@/%@/%@", [Configuration APIEndpointWithProtocol],[Configuration APIVersion], APIEndpointPusherAuth];
    _client.authorizationURL = [NSURL URLWithString:pusherAuthURLString];
    [_client connect];
}

- (PTPusherEventBinding *)connectToPusherChannel:(NSString *)channel withEvent:(NSString *)event sender:(id)sender withCompletion:(void (^)(NSDictionary *channelData))completionBlock {
    
    __weak id blockSender = sender;


    PTPusherPrivateChannel *chatChannel = [self privateChannelNamed:channel];

    if (!chatChannel) {
        chatChannel = [self.client subscribeToPrivateChannelNamed:channel];
    }

    return [chatChannel bindToEventNamed:event handleWithBlock:^(PTPusherEvent *channelEvent) {

        NSLog(@"pusher activated by: %@", blockSender);
        
        if (completionBlock) {
            completionBlock(channelEvent.data);
        }
    }];
}

- (void)pusher:(PTPusher *)pusher willAuthorizeChannel:(PTPusherChannel *)channel withRequest:(NSMutableURLRequest *)request
{

    NSString *readableBody = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];

    NSString *authTokenString = [NSString stringWithFormat:@"&authentication_token=%@",[LEOCredentialStore authToken]];

    NSString *bodyString = [readableBody stringByAppendingString:authTokenString];

    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
}

- (PTPusherPrivateChannel *)privateChannelNamed:(NSString *)channelName {
    NSString *privateChannelName = [NSString stringWithFormat:@"private-%@",channelName];
    return (PTPusherPrivateChannel *)[self.client channelNamed:privateChannelName];
}

- (void)removeBinding:(PTPusherEventBinding *)binding fromPrivateChannelWithName:(NSString *)channelName {

    [[self privateChannelNamed:channelName] removeBinding:binding];
}


@end
