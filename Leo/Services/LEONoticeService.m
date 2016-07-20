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
#import "LEOSession.h"
#import "Notice.h"
#import "LEOCachedService.h"

@implementation LEONoticeService

static NSString *const kDefaultMessage = @"Welcome to Leo + Flatiron Pediatrics. Say hello. Book an appointment. Review your child's health record.";

- (LEOPromise *)getFeedNoticeForDate:(NSDate *)date withCompletion:(LEOObjectErrorBlock)completionBlock {

    NSString *dateString = [NSDate leo_stringifiedDashedShortDateYearMonthDay:date];
    NSString *endpoint = [NSString stringWithFormat:@"http://%@/%@.json",[Configuration contentURL],dateString];

    [self.S3Network unauthenticatedGETRequestForJSONDictionaryFromS3WithURLString:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

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
    
    return [LEOPromise waitingForCompletion];
}

- (LEOPromise *)getConversationNoticesWithCompletion:(LEOArrayErrorBlock)completionBlock {

    return [self.cachedService get:APIEndpointConversationNotices params:nil completion:^(NSDictionary *response, NSError *error) {

        NSArray *notices;
        if (!error) {

            NSArray *rawNotices = response[@"notices"];
            if (rawNotices) {
                notices = [Notice deserializeManyFromJSON:rawNotices];
            }
        }

        if (completionBlock) {
            completionBlock(notices, error);
        }
    }];
}

- (LEOS3JSONSessionManager *)S3Network {
    return [LEOS3JSONSessionManager sharedClient];
}
@end
