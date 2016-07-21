//
//  LEOFeedMessageService.h
//  Leo
//
//  Created by Zachary Drossman on 2/24/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOModelService.h"

@interface LEONoticeService : LEOModelService

- (LEOPromise *)getFeedNoticeForDate:(NSDate *)date withCompletion:(LEOObjectErrorBlock)completionBlock;
- (LEOPromise *)getConversationNoticesWithCompletion:(LEOArrayErrorBlock)completionBlock;
- (LEOPromise *)putConversationNotices:(NSArray *)notices withCompletion:(LEOArrayErrorBlock)completionBlock;

@end
