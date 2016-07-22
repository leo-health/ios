//
//  LEOMediaService.m
//  Leo
//
//  Created by Zachary Drossman on 1/20/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOMediaService.h"
#import "LEOS3Image.h"
#import "LEOS3ImageSessionManager.h"

@implementation LEOMediaService

- (LEOPromise *)getImageForS3Image:(LEOS3Image *)s3Image
                    withCompletion:(void (^)(UIImage *rawImage, NSError *error))completionBlock {

    if (s3Image.baseURL && s3Image.parameters) {

        return [self.cachedService get:APIEndpointImage
                                params:[s3Image serializeToJSON]
                            completion:^(NSDictionary *response, NSError *error) {

            if (completionBlock) {
                completionBlock(response[APIParamImage], error);
            }
        }];
    }

    return nil;
}

+ (LEOS3ImageSessionManager *)leoMediaSessionManager {
    return [LEOS3ImageSessionManager sharedClient];
}

@end
