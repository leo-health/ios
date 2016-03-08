//
//  LEOPusherHelper.m
//  Leo
//
//  Created by Zachary Drossman on 7/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOPusherHelper.h"
#import "SessionUser.h"
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
        
        _client = [PTPusher pusherWithKey:[Configuration pusherKey] delegate:self encrypted:YES];
        NSString *pusherAuthURLString = [NSString stringWithFormat:@"%@/%@/%@", [Configuration APIEndpointWithProtocol],[Configuration APIVersion], APIEndpointPusherAuth];
        _client.authorizationURL = [NSURL URLWithString:pusherAuthURLString];
        [_client connect];
    }

    return _client;
}

- (PTPusherEventBinding *)connectToPusherChannel:(NSString *)channel withEvent:(NSString *)event sender:(id)sender withCompletion:(void (^)(NSDictionary *channelData))completionBlock {
    
    __weak id blockSender = sender;


    PTPusherChannel *chatChannel = [self privateChannelNamed:channel];

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

    NSString *authTokenString = [NSString stringWithFormat:@"&authentication_token=%@",[SessionUser authToken]];

    NSString *bodyString = [readableBody stringByAppendingString:authTokenString];

    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
}

- (PTPusherChannel *)privateChannelNamed:(NSString *)channelName {
    NSString *privateChannelName = [NSString stringWithFormat:@"private-%@",channelName];
    return [self.client channelNamed:privateChannelName];
}

- (void)removeBinding:(PTPusherEventBinding *)binding fromPrivateChannelWithName:(NSString *)channelName {

    [[self privateChannelNamed:channelName] removeBinding:binding];
}

//- (void)unsubscribeFromPrivateChannelWithName:(NSString *)channelName {
//
//    [self unsubscribeFromChannelWithName:privateChannelName];
//}
//
//- (void)unsubscribeFromChannelWithName:(NSString *)channelName {
//
//    PTPusherChannel *chatChannel = [self.client channelNamed:channelName];
//    [chatChannel unsubscribe];
//}

//TODO: At some point, we're going to want to implement something like this per the docs to ensure we are dealing with failures to connect.

//- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error
//{
//    [self handleDisconnectionWithError:error];
//}
//
//- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error willAttemptReconnect:(BOOL)willAttemptReconnect
//{
//    if (!willAttemptReconnect) {
//        [self handleDisconnectionWithError:error];
//    }
//}
//
//- (void)handleDisconnectionWithError:(NSError *)error
//{
//    Reachability *reachability = [Reachability reachabilityWithHostname:self.client.connection.URL.host];
//    
//    if (error && [error.domain isEqualToString:PTPusherFatalErrorDomain]) {
//        NSLog(@"FATAL PUSHER ERROR, COULD NOT CONNECT! %@", error);
//    }
//    else {
//        if ([reachability isReachable]) {
//            // we do have reachability so let's wait for a set delay before trying again
//            [self.client performSelector:@selector(connect) withObject:nil afterDelay:5];
//        }
//        else {
//            // we need to wait for reachability to change
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(_reachabilityChanged:)
//                                                         name:kReachabilityChangedNotification
//                                                       object:reachability];
//            
//            [reachability startNotifier];
//        }
//    }
//}
//
//- (void)_reachabilityChanged:(NSNotification *note)
//{
//    Reachability *reachability = [note object];
//    
//    if ([reachability isReachable]) {
//        // we're reachable, we can try and reconnect, otherwise keep waiting
//        [self.client connect];
//        
//        // stop watching for reachability changes
//        [reachability stopNotifier];
//        
//        [[NSNotificationCenter defaultCenter]
//         removeObserver:self
//         name:kReachabilityChangedNotification
//         object:reachability];
//    }
//}
@end
