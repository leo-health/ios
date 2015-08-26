//
//  LEOAPIHelper.h
//  Leo
//
//  Created by Zachary Drossman on 5/18/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOAPIHelper : NSObject

NS_ASSUME_NONNULL_BEGIN

+ (void)standardGETRequestForJSONDictionaryFromAPIWithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock;

+ (void)standardGETRequestForDataFromS3WithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSData *rawResults, NSError *error))completionBlock;

+ (void)standardPOSTRequestForJSONDictionaryFromAPIWithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock;

NS_ASSUME_NONNULL_END

@end
