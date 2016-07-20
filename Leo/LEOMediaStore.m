//
//  LEOMediaStore.m
//  Leo
//
//  Created by Adam Fanslau on 7/20/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOMediaStore.h"
#import "LEOS3ImageSessionManager.h"


@implementation LEOMediaStore

- (LEOPromise *)get:(NSString *)endpoint params:(NSDictionary *)params completion:(LEODictionaryErrorBlock)completion {

    NSString *baseURL = params[APIParamImageBaseURL];
    NSDictionary *extraParams = params[APIParamImageURLParameters];

    [self.leoMediaSessionManager presignedGETRequestForImageFromS3WithURL:baseURL params:extraParams completion:^(UIImage *rawImage, NSError *error) {

        NSMutableDictionary *response = [NSMutableDictionary new];
        [response addEntriesFromDictionary:params];
        response[APIParamImage] = rawImage;

        if (completion) {
            completion([response copy], error);
        }
    }];
    return [LEOPromise waitingForCompletion];
}

- (LEOS3ImageSessionManager *)leoMediaSessionManager {
    return [LEOS3ImageSessionManager sharedClient];
}

@end
