//
//  LEOChangeEventObserver.h
//  Leo
//
//  Created by Adam Fanslau on 8/1/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LEOChangeEventObserver;

@protocol LEOChangeEventDelegate <NSObject>

@optional
- (void)observer:(LEOChangeEventObserver *)observer didReceiveChangeEvent:(NSDictionary *)eventData;
- (void)observer:(LEOChangeEventObserver *)observer willRequestDataFromRemote:(NSDictionary *)eventData;
- (void)observer:(LEOChangeEventObserver *)observer didReceiveResponseFromRemote:(NSDictionary *)remoteResponse error:(NSError *)error;

@end


@protocol LEOChangeEventRequestHandler <NSObject>

@required
- (void)observer:(LEOChangeEventObserver *)observer
fetchFullDataForEvent:(NSDictionary *)eventData
      completion:(LEODictionaryErrorBlock)completion;

@end


@interface LEOChangeEventObserver : NSObject

@property (weak, nonatomic, readonly) id<LEOChangeEventRequestHandler> requestHandler;
@property (weak, nonatomic, readonly) id<LEOChangeEventDelegate> delegate;
@property (strong, nonatomic, readonly) NSString *channel;
@property (strong, nonatomic, readonly) NSString *event;

@property (nonatomic, readonly, getter=isSubscribed) BOOL subscribed;

+ (instancetype)subscribeToChannel:(NSString *)channel
                         withEvent:(NSString *)event
                           handler:(id<LEOChangeEventRequestHandler>)requestHandler
                          delegate:(id<LEOChangeEventDelegate>)delegate;
- (void)unsubscribe;

@end
