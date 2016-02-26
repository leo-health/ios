//
//  LEOFeedMessageService.h
//  Leo
//
//  Created by Zachary Drossman on 2/24/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEOFeedMessageService : NSObject

- (NSURLSessionTask *)getFeedMessageForDate:(NSDate *)date withCompletion:(void (^)(NSString *feedMessage, NSError *error))completionBlock;

@end
