//
//  LEOPusherHelper.h
//  Leo
//
//  Created by Zachary Drossman on 7/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Pusher/Pusher.h>

@interface LEOPusherHelper : NSObject <PTPusherDelegate>

+ (instancetype)sharedPusher;

- (void) updateClientForNewKeys;

- (PTPusherEventBinding *)connectToPusherChannel:(NSString *)channel withEvent:(NSString *)event sender:(id)sender withCompletion:(void (^)(NSDictionary *channelData))completionBlock;\
- (void)removeBinding:(PTPusherEventBinding *)binding fromPrivateChannelWithName:(NSString *)channelName;


@end
