//
//  LEOFeedMessageService.m
//  Leo
//
//  Created by Zachary Drossman on 2/24/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEONoticeService.h"
#import "LEOS3JSONSessionManager.h"
#import "NSDate+Extensions.h"
#import "NSDictionary+Extensions.h"
#import "Configuration.h"
#import "LEOCachedDataStore.h"
#import "Notice.h"

@implementation LEONoticeService

static NSString *const kDefaultMessage = @"Welcome to Leo @ Flatiron Pediatrics. Say hello. Book an appointment. Review your child's health record.";

- (NSURLSessionTask *)getFeedNoticeForDate:(NSDate *)date withCompletion:(void (^)(NSString *feedMessage, NSError *error))completionBlock {

    NSString *dateString = [NSDate leo_stringifiedDashedShortDateYearMonthDay:date];
    NSString *endpoint = [NSString stringWithFormat:@"http://%@/%@.json",[Configuration contentURL],dateString];

    NSURLSessionTask *task = [[self sessionManager] unauthenticatedGETRequestForJSONDictionaryFromS3WithURLString:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        NSString *feedString;

        if (!error) {
            feedString = [[rawResults leo_itemForKey:APIParamData] leo_itemForKey:APIParamFeedMessageHeaderText];
        } else {
            feedString = kDefaultMessage;
        }

        if (completionBlock) {
            completionBlock(feedString, error);
        }

    }];
    
    return task;
}

- (NSURLSessionTask *)getConversationNoticesWithCompletion:(void (^)(NSArray *notices, NSError *error)) completionBlock {

    NSString *endpoint = [NSString stringWithFormat:@"http://%@/%@.json",[Configuration contentURL],APIEndpointConversationNotices];

    if ([LEOCachedDataStore sharedInstance].notices) {
        completionBlock([LEOCachedDataStore sharedInstance].notices, nil);
    } else {

        NSURLSessionTask *task =
        [[self sessionManager] unauthenticatedGETRequestForJSONDictionaryFromS3WithURLString:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

            if (!error) {

                NSArray *notices =
                [Notice noticesFromJSONArray:rawResults[APIParamData]];

                [LEOCachedDataStore sharedInstance].notices = notices;

                if (completionBlock) {
                    completionBlock(notices, error);
                }

            } else
            {
                if (completionBlock) {
                    completionBlock(nil, error);
                }
            }
        }];

        return task;
    }

    return nil;
}


- (LEOS3JSONSessionManager *)sessionManager {

    return [LEOS3JSONSessionManager sharedClient];
    
}
@end
