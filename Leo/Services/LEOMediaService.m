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

- (void)getImageForS3Image:(LEOS3Image *)s3Image withCompletion:(void (^)(UIImage *rawImage, NSError *error))completionBlock {

    if (s3Image.baseURL && s3Image.parameters) {

        [[LEOMediaService leoMediaSessionManager] presignedGETRequestForImageFromS3WithURL:s3Image.baseURL params:s3Image.parameters completion:^(UIImage *rawImage, NSError *error) {
            completionBlock ? completionBlock(rawImage, error) : nil;
        }];

    } else {
        completionBlock ? completionBlock(nil, nil) : nil;
    }
}

+ (LEOS3ImageSessionManager *)leoMediaSessionManager {
    return [LEOS3ImageSessionManager sharedClient];
}

@end
