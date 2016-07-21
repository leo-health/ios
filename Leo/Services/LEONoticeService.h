//
//  LEOFeedMessageService.h
//  Leo
//
//  Created by Zachary Drossman on 2/24/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEONoticeService : NSObject

- (NSURLSessionTask *)getFeedNoticeForDate:(NSDate *)date withCompletion:(void (^)(NSString *feedMessage, NSError *error))completionBlock;
- (NSURLSessionTask *)getConversationNoticesWithCompletion:(void (^)(NSArray *notices, NSError *error)) completionBlock;

@end
