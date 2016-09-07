//
//  LEOHTTPSerializedSessionManager.h
//  Leo
//
//  Created by Zachary Drossman on 8/31/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface LEOHTTPSerializedSessionManager : AFHTTPSessionManager

+ (LEOHTTPSerializedSessionManager *)sharedClient;

- (NSURLSessionDataTask *)standardGETRequestForJSONDictionaryFromAPIWithEndpoint:(NSString *)urlString params:(NSDictionary *)params progressBlock:(void (^)(NSProgress *downloadProgress))progressBlock completion:(void (^)(NSData *binaryData, NSError *error))completionBlock;

@end
