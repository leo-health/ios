//
//  LEOS3JSONSessionManager.h
//  Leo
//
//  Created by Zachary Drossman on 2/24/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface LEOS3JSONSessionManager : AFHTTPSessionManager

+ (LEOS3JSONSessionManager *)sharedClient;

- (NSURLSessionDataTask *)unauthenticatedGETRequestForJSONDictionaryFromS3WithURLString:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock;


@end
