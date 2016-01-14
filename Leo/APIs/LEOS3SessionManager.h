//
//  LEOs3SessionMananger.h
//  Leo
//
//  Created by Zachary Drossman on 8/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface LEOS3SessionManager : AFHTTPSessionManager

+ (LEOS3SessionManager *)sharedClient;

- (NSURLSessionDataTask *)presignedGETRequestForImageFromS3WithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(UIImage *rawImage, NSError *error))completionBlock;

@end
