//
//  LEONetworkStore.m
//  Leo
//
//  Created by Adam Fanslau on 7/5/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEONetworkStore.h"
#import "LEOAPISessionManager.h"
#import "LEOS3JSONSessionManager.h"
#import "LEOPromise.h"
#import "Configuration.h"
#import "LEOMediaStore.h"

@implementation LEONetworkStore

- (LEOPromise *)get:(NSString *)endpoint params:(NSDictionary *)params completion:(LEODictionaryErrorBlock)completion {

    if ([endpoint isEqualToString:APIEndpointConversationNotices]) {
        return [self getConversationNoticesWithCompletion:completion];
    }

    if ([endpoint isEqualToString:APIEndpointImage]) {
        return [[LEOMediaStore new] get:endpoint params:params completion:completion];
    }

    [self.network standardGETRequestForJSONDictionaryFromAPIWithEndpoint:endpoint
                                                                  params:params
                                                              completion:[self unwrapJSONForEndpoint:endpoint then:^(NSDictionary *rawResults, NSError *error) {

        // HACK: should standardize backend results structure. No need for the extra APIParamFamily json key
        NSDictionary *parsedResult = rawResults;
        if ([endpoint isEqualToString:APIEndpointFamily]) {
            parsedResult = rawResults[APIParamFamily];
        }

        if ([endpoint isEqualToString:APIEndpointCurrentUser]) {
            parsedResult = rawResults[APIParamUser];
        }

        if (completion) {
            completion(parsedResult, error);
        }
    }]];
    return [LEOPromise waitingForCompletion];
}

- (LEOPromise *)put:(NSString *)endpoint params:(NSDictionary *)params completion:(LEODictionaryErrorBlock)completion {

    [self.network standardPUTRequestForJSONDictionaryToAPIWithEndpoint:endpoint
                                                                params:params
                                                            completion:[self unwrapJSONThen:^(NSDictionary *rawResults, NSError *error) {
        // HACK: should standardize backend results structure. No need for the extra APIParamFamily json key
        NSDictionary *parsedResult = rawResults;

        // TODO: find a better way to parse urls
        NSArray *path = [endpoint componentsSeparatedByString:@"/"];
        if ([endpoint isEqualToString:APIEndpointCurrentUser]) {
            parsedResult = rawResults[APIParamUser];
        }

        if ([path.firstObject isEqualToString:APIEndpointPatients]) {
            parsedResult = rawResults[APIParamUserPatient];
        }

        if (completion) {
            completion(parsedResult, error);
        }
    }]];
    return [LEOPromise waitingForCompletion];
}

- (LEOPromise *)post:(NSString *)endpoint params:(NSDictionary *)params completion:(LEODictionaryErrorBlock)completion {

    if ([endpoint isEqualToString:APIEndpointUsers] ||
        [endpoint isEqualToString:APIEndpointLogin]) {

        [self.network unauthenticatedPOSTRequestForJSONDictionaryToAPIWithEndpoint:endpoint
                                                                            params:params
                                                                        completion:[self unwrapJSONThen:completion]];
    } else {

        [self.network standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:endpoint
                                                                     params:params
                                                                 completion:[self unwrapJSONThen:^(NSDictionary *rawResults, NSError *error) {

            // HACK: should standardize backend results structure. No need for the extra APIParamFamily json key
            NSDictionary *parsedResult = rawResults;

            if ([endpoint isEqualToString:APIEndpointPatients]) {
                parsedResult = rawResults[APIParamUserPatient];
            }

            if ([endpoint isEqualToString:APIEndpointAvatars]) {
                parsedResult = rawResults[APIParamUserAvatar];
            }

            if (completion) {
                completion(parsedResult, error);
            }
        }]];
    }
    return [LEOPromise waitingForCompletion];
}


- (LEOPromise *)destroy:(NSString *)endpoint params:(NSDictionary *)params completion:(LEODictionaryErrorBlock)completion {

    [self.network standardDELETERequestForJSONDictionaryToAPIWithEndpoint:endpoint
                                                                   params:params
                                                               completion:[self unwrapJSONThen:completion]];
    return [LEOPromise waitingForCompletion];
}

- (void(^)(NSDictionary *, NSError *))unwrapJSONForEndpoint:(NSString *)endpoint then:(LEODictionaryErrorBlock)completion {

    return [self unwrapJSONThen:^(id json, NSError *error) {

        NSDictionary *parsedResult;

        if ([json isKindOfClass:[NSDictionary class]]) {
            parsedResult = json;
        }

        // HACK: backend should add a wrapper around all array results.
        if ([endpoint isEqualToString:APIEndpointAppointmentTypes]) {
            NSMutableDictionary *mutableResult = [NSMutableDictionary new];
            mutableResult[APIEndpointAppointmentTypes] = json;
            parsedResult = [mutableResult copy];
        }

        if (completion) {
            completion(parsedResult, error);
        }
    }];
}

- (void(^)(NSDictionary *, NSError *))unwrapJSONThen:(void(^)(id, NSError *))completion {

    return ^(NSDictionary *result, NSError *error) {

        NSDictionary *parsedResult = result;

        if (!error) {
            parsedResult = result[APIParamData];
        }

        if (completion) {
            completion(parsedResult, error);
        }
    };
}

- (LEOAPISessionManager *)network {
    return [LEOAPISessionManager sharedClient];
}



# pragma mark  -  S3 Resources

// TODO: refactor blocks to use LEODictionaryErrorBlock alias
- (LEOPromise *)getConversationNoticesWithCompletion:(LEODictionaryErrorBlock)completionBlock {

    NSString *endpoint = [NSString stringWithFormat:@"http://%@/%@.json", [Configuration contentURL], APIEndpointConversationNotices];

    [self.S3Network unauthenticatedGETRequestForJSONDictionaryFromS3WithURLString:endpoint params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        NSDictionary *notices;
        if (!error) {

            NSArray *rawNotices = rawResults[APIParamData];
            notices = rawNotices ? @{@"notices": rawNotices} : nil;
        }

        if (completionBlock) {
            completionBlock(notices, error);
        }
    }];
    return [LEOPromise waitingForCompletion];
}

- (LEOS3JSONSessionManager *)S3Network {
    return [LEOS3JSONSessionManager sharedClient];
}

@end
