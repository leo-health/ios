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

+ (void)standardGETRequestForJSONDictionaryFromAPIWithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock;
+ (void)standardPOSTRequestForJSONDictionaryFromAPIWithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock;

NS_ASSUME_NONNULL_END

@end
