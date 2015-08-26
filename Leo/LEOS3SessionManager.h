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

- (NSURLSessionDataTask *)standardGETRequestForDataFromS3WithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSData *rawData, NSError *error))completionBlock;
- (NSURLSessionDataTask *)standardPOSTRequestForS3WithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSData *rawData, NSError *error))completionBlock;


@end
