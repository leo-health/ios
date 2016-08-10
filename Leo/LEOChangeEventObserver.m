//
//  LEOChangeEventObserver.m
//  Leo
//
//  Created by Adam Fanslau on 8/1/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOChangeEventObserver.h"
#import "LEOPusherHelper.h"
#import <Pusher/Pusher.h>

@interface LEOChangeEventObserver ()

@property (strong, nonatomic) PTPusherEventBinding *binding;

@end

@implementation LEOChangeEventObserver

+ (instancetype)subscribeToChannel:(NSString *)channel
                         withEvent:(NSString *)event
                           handler:(id<LEOChangeEventRequestHandler>)requestHandler
                          delegate:(id<LEOChangeEventDelegate>)delegate {

    return [[LEOChangeEventObserver alloc] initWithChannel:channel
                                                 withEvent:event
                                                   handler:requestHandler
                                                  delegate:delegate];
}

- (instancetype)initWithChannel:(NSString *)channel
                      withEvent:(NSString *)event
                        handler:(id<LEOChangeEventRequestHandler>)requestHandler
                       delegate:(id<LEOChangeEventDelegate>)delegate {

    self = [super init];
    if (self) {

        _requestHandler = requestHandler;
        _delegate = delegate;
        _channel = channel;
        _event = event;

        [self subscribe];
        [self setupNotifications];
    }

    return self;
}

- (void)setupNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification {

    if ([notification.name isEqualToString:UIApplicationDidEnterBackgroundNotification] ||
        [notification.name isEqualToString:UIApplicationWillResignActiveNotification]) {

        [self unsubscribe];
    }

    if ([notification.name isEqualToString:UIApplicationDidBecomeActiveNotification]) {

        // TODO: implement GET missed events
        // GET /pusher/events?since={datetime}&channel={channel optional}

        [self handleEvent:@{}];
        [self subscribe];
    }
}

- (void)handleEvent:(NSDictionary *)eventData {

    if ([self.delegate respondsToSelector:@selector(observer:didReceiveChangeEvent:)]) {
        [self.delegate observer:self didReceiveChangeEvent:eventData];
    }

    if ([self.delegate respondsToSelector:@selector(observer:willRequestDataFromRemote:)]) {
        [self.delegate observer:self willRequestDataFromRemote:eventData];
    }

    if ([self.requestHandler respondsToSelector:@selector(observer:fetchFullDataForEvent:completion:)]) {

        __weak typeof(self) weakSelf = self;
        [self.requestHandler observer:self fetchFullDataForEvent:eventData completion:^(NSDictionary *hash, NSError *error) {
            __strong typeof(self) strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(observer:didReceiveResponseFromRemote:error:)]) {
                [strongSelf.delegate observer:strongSelf
                 didReceiveResponseFromRemote:hash
                                        error:error];
            }
        }];
    }
}

- (void)subscribe {

    if (self.binding) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    self.binding =
    [[LEOPusherHelper sharedPusher] connectToPusherChannel:self.channel
                                                 withEvent:self.event
                                                    sender:self
                                            withCompletion:^(NSDictionary *channelData) {
                                                __strong typeof(self) strongSelf = weakSelf;
                                                [strongSelf handleEvent:channelData];
                                            }];
}

- (void)unsubscribe {
    
    [[LEOPusherHelper sharedPusher] removeBinding:self.binding
                       fromPrivateChannelWithName:self.channel];
    self.binding = nil;
}

- (BOOL)isSubscribed {
    return !!self.binding;
}


@end
