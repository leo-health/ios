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
- (void)connectToPusherChannel:(NSString *)channel withEvent:(NSString *)event withCompletion:(void (^)(NSDictionary *channelData))completionBlock;

@end
