//
//  LEOFeedMessageService.m
//  Leo
//
//  Created by Zachary Drossman on 2/24/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOFeedMessageService.h"
#import "LEOS3JSONSessionManager.h"
#import "NSDate+Extensions.h"
#import "NSDictionary+Additions.h"
#import "Configuration.h"

@implementation LEOFeedMessageService

static NSString *const kDefaultMessage = @"Welcome to Leo @ Flatiron Pediatrics. Say hello. Book an appointment. Review your child's health record.";

- (NSURLSessionTask *)getFeedMessageForDate:(NSDate *)date withCompletion:(void (^)(NSString *feedMessage, NSError *error))completionBlock {

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

- (LEOS3JSONSessionManager *)sessionManager {

    return [LEOS3JSONSessionManager sharedClient];

}
@end
