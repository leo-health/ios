//
//  LEOPusherHelper.m
//  Leo
//
//  Created by Zachary Drossman on 7/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOPusherHelper.h"
#import "SessionUser.h"

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


- (void)connectToPusherChannel:(NSString *)channel withEvent:(NSString *)event withCompletion:(void (^)(NSDictionary *channelData))completionBlock {
    
    self.client = [PTPusher pusherWithKey:@"218006d766a6d76e8672" delegate:self encrypted:YES];
    
    PTPusherChannel *chatChannel = [self.client subscribeToChannelNamed:channel];
    
    [chatChannel bindToEventNamed:event handleWithBlock:^(PTPusherEvent *channelEvent) {

        NSString *message = [channelEvent.data objectForKey:@"text"];
        NSLog(@"message received: %@", message);
        
        if (completionBlock) {
            completionBlock(channelEvent.data);
        }
    }];
    
    [self.client connect];
}

//- (void)pusher:(PTPusher *)pusher willAuthorizeChannel:(PTPusherChannel *)channel withRequest:(NSMutableURLRequest *)request
//{
//
//    [request setValue:[[SessionUser currentUser].credentialStore authToken] forHTTPHeaderField:@"X-MyCustom-AuthTokenHeader"];
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
