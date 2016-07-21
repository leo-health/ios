//
//  LEOMediaService.h
//  Leo
//
//  Created by Zachary Drossman on 1/20/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class LEOS3Image;

#import <Foundation/Foundation.h>

@interface LEOMediaService : NSObject

- (NSURLSessionDataTask *)getImageForS3Image:(LEOS3Image *)s3Image withCompletion:(void (^)(UIImage *rawImage, NSError *error))completionBlock;

@end
